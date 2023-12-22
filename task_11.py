from sqlalchemy import create_engine, Column, Integer, String, text
from sqlalchemy.orm import sessionmaker
from sqlalchemy.orm import declarative_base
from sqlalchemy import MetaData
from sqlalchemy import Table, select, insert, update, delete, func
from sqlalchemy import case, literal_column

login = 'login'  # Поменяйте на свои значения
password = 'password'  # Поменяйте на свои значения
engine = create_engine(f'postgresql://{login}:{password}@localhost/postgres')
schema_name = 'league_of_pharmacist'

metadata = MetaData()
metadata.reflect(bind=engine, schema=schema_name)
table_names = metadata.tables.keys()


# Красивое отображение таблицы
def write_select(columns, rows, _len_):
    print("|", "|".join(columns), "|")
    print("-" * ((_len_ + 1) * len(columns) + 2))
    for row in rows:
        print("|", "|".join([str(i).ljust(_len_) for i in row]), "|")


# Select запрос к таблице users
users_table = Table('users', metadata, autoload=True, autoload_with=engine, schema=schema_name)
columns = [
    users_table.c.name,
    users_table.c.surname,
    users_table.c.sex,
    users_table.c.birthdate,
    users_table.c.registration_date,
    users_table.c.city
]
header = [
    str(column.key).ljust(17)
    for column in columns
]
select_query = select(columns)
with engine.connect() as conn:
    result = conn.execute(select_query)
write_select(header, result, 17)

# Insert запрос к users
insert_query = insert(users_table).values(
    name='Oleg',
    surname='Terentev',
    sex='male',
    passport='1234 123233',
    birthdate='2002-10-22',
    registration_date='2023-12-22',
    city='Saint Petersburg',
    mail='oeterentev@edu.hse.ru',
    phone_number='8-911-032-23-63'
)
with engine.connect() as conn:
    conn.execute(insert_query)

# Update запрос к users
update_query = update(users_table).where(users_table.c.user_id == '12').values(phone_number='8-911-111-11-12')
with engine.connect() as conn:
    conn.execute(update_query)

# Delete запрос к users
delete_query = delete(users_table).where(users_table.c.user_id == '12')
with engine.connect() as conn:
    conn.execute(delete_query)

# Запрос на подсчет количества пользователей определенного пола в каждом городе: 
query = select([
    users_table.c.city,
    users_table.c.sex,
    func.count().label('user_count')
]).group_by(users_table.c.city, users_table.c.sex)

with engine.connect() as conn:
    result = conn.execute(query)
write_select([i.ljust(17) for i in ['Город', 'Пол', 'Количество']], result, 17)

# Запрос на количество ставок по каждому событию
events = Table('events', metadata, autoload=True, autoload_with=engine, schema=schema_name)
event_types = Table('event_types', metadata, autoload=True, autoload_with=engine, schema=schema_name)
bets = Table('bets', metadata, autoload=True, autoload_with=engine, schema=schema_name)
ratios = Table('ratios', metadata, autoload=True, autoload_with=engine, schema=schema_name)

event_statistics_query = (
    select([
        events.c.event_name,
        event_types.c.name.label('event_type_name'),
        func.count(bets.c.bet_id).label('total_bets'),
        func.coalesce(func.sum(bets.c.amount), 0).label('total_bet_amount'),
        func.sum(
            case(
                [(ratios.c.is_lost == False, bets.c.amount)],
                else_=literal_column('0')
            )
        ).label('total_winnings')
    ])
    .select_from(
        events
        .join(event_types, events.c.event_type_id == event_types.c.event_type_id)
        .outerjoin(bets, events.c.event_id == bets.c.event_id)
        .outerjoin(ratios, (bets.c.event_id == ratios.c.event_id) & (
                    bets.c.acceptable_condition_id == ratios.c.acceptable_condition_id))
    )
    .group_by(events.c.event_id, events.c.event_name, event_types.c.name)
)

with engine.connect() as conn:
    result = conn.execute(event_statistics_query)
write_select(
    [i.ljust(25) for i in ['event_name', 'event_type_name', 'total_bets', 'total_bet_amount', 'total_winnings']],
    result, 25)

# Database

## Source of data

1. Dataset for [Brent Spot Price of Crude Oil](https://www.eia.gov/dnav/pet/hist_xls/RBRTEd.xls) (Brent Spot Price, dollars per Barrel) from U.S. Energy Information Administration
2. ETF price from [`yfinance`](https://pypi.org/project/yfinance/) Yahoo! Finance's API for ticker `RYE` - Invesco S&P 500 Equal Weight Energy ETF
3. ETF portfolio holdings from [Invesco](https://www.invesco.com/us/financial-products/etfs/holdings?audienceType=Investor&ticker=RYE) for this ETF

## Database application

We've decided to use PostgreSQL as our database, as it is easy and efficient for us to connect with our [Jupyter Notebook](https://github.com/kobertlam/Energy_ETF_RYE_Forecast/blob/database/postgresql_connection.ipynb). 

Below shows the Entity Relationship Diagram of our database. 

![](Resources/ERD.png)

## Connect with Jupyter Notebook

Below shows the [code](https://github.com/kobertlam/Energy_ETF_RYE_Forecast/blob/database/postgresql_connection.ipynb) to set up and connect to the database. 

```
from sqlalchemy import create_engine
from config import db_password

db_string = f'postgresql://postgres:{db_password}@127.0.0.1:5432/energy_etf_rye_forecast'
engine = create_engine(db_string)
db_connection = engine.connect()
```

Below is an example to export the Pandas DataFrame to our database. 

```
rye.to_sql('rye', engine)
brent.to_sql('brent', engine)
```

Below is an example to import the data from our database into Pandas DataFrame. 

```
query = 'SELECT * FROM rye'
rye = pd.read_sql(query, db_connection, parse_dates=['date'], index_col='date')
print('rye shape:', rye.shape)

query = 'SELECT * FROM brent_spot_price_crude_oil'
brent = pd.read_sql(query, db_connection, parse_dates=['date'], index_col='date')
print('brent shape:', brent.shape)

query = 'SELECT rye.*, brent_spot_price_crude_oil.brent FROM rye JOIN brent_spot_price_crude_oil ON rye.date = brent_spot_price_crude_oil.date'
model_df = pd.read_sql(query, db_connection, parse_dates=['date'], index_col='date')
print('model_df shape:', model_df.shape)
```

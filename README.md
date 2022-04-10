# Technologies Used

## Database Storage

PostgreSQL is used in our project, as it is efficient for us to connect through Python/Jupyter Notebook/Jupyter Lab.

## Data Cleaning and Analysis

`Yfinance` package is used to acquire the data though Yahoo Finance api. Pandas is used to clean the data and export to our local PostgreSQL database. 

In a separate notebook, pandas is used with a SQL query to join two tables and import them from our local PostgreSQL database into our notebook. Then, Pandas is used to perform further analysis. 

## Machine Learning

ARIMA and TensorFlow with Keras Sequential Model are the Machine Learning models that we have used. Details can also be found in the [machine_learning_model](https://github.com/kobertlam/Energy_ETF_RYE_Forecast/tree/machine_learning_model) branch. 

## Dashboard
Tableau is used to create an interactive dashboard. 

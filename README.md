# Energy ETF RYE Forecast

## Overview 

### Background

Brent crude spot price jumped to $133 a barrel on March 8, 2022 and it represents the highest oil prices since 2008. Oil companies supply billions of barrels of petroleum products daily to power transportation and industry. The fluctuation of the crude oil price has direct impact on the production cost of the carbon-based fuels and products, which in turn impacting the profitability and the stock prices of the oil companies. In this project, we would like bring insights to fund managers and investors who are interested in investing the oil-related sector. We will study if there is any relationship between the crude oil price and the Energy ETF (RYE) price.

### Purpose of this Project

This is the final project for Data Analytics Bootcamp for our group (Group 4). We have integrated the data analystic skills and tools we have learnt from the bootcamp into this final project. We aim to, based on the historical prices of an Exchanged Traded Fund (ETF) in the Energy sector and oil Brent prices, forecast the future prices of the ETF prices (Invesco S&P 500® Equal Weight Energy ETF). 

### Questions to be Answered

1. Are there seasonal trends and patterns on the Energy ETF? Can we forecast the future ETF prices solely based on the historical ETF prices (time series)?
2. Is there any relationship between the crude oil prices and the ETF prices? Can we forecast the future ETF price based on both the historical ETF prices and the historical crude oil prices?

### Benefits

The value investment theories indicate that the market/nominal stock value of any company tends to approach the real value. If a stock is under-valued for now, the stock price tends to increase. If a stock is over-valued for now, the stock price is likely to decrease over time. 

If we are able to determine the relationship between the stock prices of the oil companies and the crude oil prices, investors or fund managers will be able to make better decisions when analyzing the stock market. 

### Presentation

We prepared a [Google Slide](https://docs.google.com/presentation/d/1M9gE1Wv08GLSOgKtwCtLHypvGdmYd1BzGTxuklBDWRo/edit?usp=sharing) for presentation purposes.

We included "Speaker Notes" in the Google Slide, and will provide the record of our presentation practice file.

Details on our presentation of the project can also be found in the [presentation](https://github.com/kobertlam/Oil_Price_and_Stock_Price_Analysis/tree/presentation) branch.

## Database

### Source of data

1. Dataset for [Brent Spot Price of Crude Oil](https://www.eia.gov/dnav/pet/hist_xls/RBRTEd.xls) (Brent Spot Price, dollars per Barrel) from U.S. Energy Information Administration. The same data is also available from [`yfinance`](https://pypi.org/project/yfinance/) with ticker `BZ=F`. 
2. ETF price from [`yfinance`](https://pypi.org/project/yfinance/) Yahoo! Finance's API for ticker `RYE` - Invesco S&P 500 Equal Weight Energy ETF
3. ETF portfolio holdings from [Invesco](https://www.invesco.com/us/financial-products/etfs/holdings?audienceType=Investor&ticker=RYE) for this ETF

### Database application

We've decided to use PostgreSQL as our database, as it is easy and efficient for us to connect with our [Jupyter Notebook](postgresql_connection.ipynb). 

Below shows the Entity Relationship Diagram of our database. 

![](../database/Resources/ERD.png)

### Connect with Jupyter Notebook

Below shows the code to set up and connect to the database. 

```
from sqlalchemy import create_engine
from config import db_password

# Connect to database
db_string = f'postgresql://postgres:{db_password}@127.0.0.1:5432/energy_etf_forecast'
engine = create_engine(db_string)
db_connection = engine.connect()
```

Below is an example to pull data from Yahoo Finance API with `yfinance`. 

```
# Acquire data and pre-processing
ticker = 'RYE'
rye = yf.download(ticker)
rye = rye.rename_axis('date')
rye.columns = ['open', 'high', 'low', 'close', 'adj close', 'volume']

# Acquire data and pre-processing
ticker = 'BZ=F'
brent = yf.download(ticker)
brent = brent.rename_axis('date')
brent.columns = ['open', 'high', 'low', 'brent', 'adj close', 'volume']
brent = brent[['brent']]
```

Below is an example to export the Pandas DataFrame to our database. 

```
# Export to database
rye.to_sql('rye', engine)
brent.to_sql('brent_spot_price_crude_oil', engine)
```

Below is an example to import the data from our database into Pandas DataFrame. 

```
# Import and join ETF and brent oil data in the future

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

## Machine Learning Models

### Data preprocessing

After acquiring our datasets, we have imported them into our Jupyter Notebook, conducted some preprocessing, and completed some preliminary analysis. 

Below shows the shapes of our tables. With 'date' to be the index, we have 'open', 'high', 'low', 'close', 'adj close', 'volume', and 'brent' as columns. We have 3,882 rows for the RYE historical trading data and 3,643 rows for the Brent Spot Price of Crude Oil data. After joining the tables together, we have a total of 3,642 valid rows. The date range of our data is from July 30, 2007 to April 8, 2022. 

```
rye shape: (3882, 6)
brent shape: (3643, 1)
model_df shape: (3642, 7)
```

#### Preliminary analysis

Below shows the historical daily close prices of the Invesco S&P 500 Equal Weight Energy ETF, which is an exchange traded fund with a portfolio of companies in the energy sector. 

![](../machine_learning_model/Resources/rye_daily.png)

The data is also visualized below through a probability distribution. 

![](../machine_learning_model/Resources/rye_probability_distribution.png)

#### Stationarity analysis

Commonly, a given time series consist of three systematic components and one non-systematic component. The three systematic components include Level, Trend, and Seasonality. The one non-systematic component is the noise. 

> - Level: the average value in the series
> - Trend: the increasing or decreasing value in the series
> - Seasonality: the repeating short-term cycle in the series
> - Noise: the random variation in the series

Before further analysis, we have conducted the [Augmented Dickey-Fuller Test](https://en.wikipedia.org/wiki/Augmented_Dickey%E2%80%93Fuller_test) to check if our time series data is stationary or not, as the time series analysis only works with stationary data. 

The ADF test is one of the most popular statistical tests used to determine the presence of a unit root in the time series, which helps identify if a time series is stationary or not. The null and alternate hypotheses are the following. If we fail to reject the null hypothesis, we can say that the time series is non-stationary, which means this time series can be linear or difference stationary. If both the mean and the standard deviation lines are flat, which implies that the mean and the variance are constant, the time series are stationary. 

- Null Hypothesis: the series has a unit root (value of a = 1)
- Alternate Hypothesis: the series has no unit root

Below are the results and the visualization. We can see that the time series is not stationary. The p-value is 0.214452, greater than 0.05, so we are not able to reject the Null Hypothesis. In addition, the Test Statistics are greater than the critical values. From the graph, we are able to see that the mean and the variance are fluctuating as well.

```
Results of dickey fuller test
Test Statistics                  -2.177664
p-value                           0.214452
No. of lags used                  0.000000
Number of observations used    3641.000000
critical value (1%)              -3.432147
critical value (5%)              -2.862334
critical value (10%)             -2.567193
dtype: float64
```

![](../machine_learning_model/Resources/rye_stationarity.png)

#### Separate trend and seasonality

In order to perform a time series analysis, we need to separate trend and seasonality from the time series. The resultant series will become stationary through this process. 

![](../machine_learning_model/Resources/rye_seasonality.png)

The `seasonal_decompose` function has been used to take a log of the time series to reduce the magnitude of the values and reduce the rising trend. Then, we find the rolling average of the time series. A rolling average is calculated by taking input for the past 12 months and by giving a mean consumption value at every point further ahead in the time series. 

![](../machine_learning_model/Resources/rye_masd.png)

### Feature engineering and selection

Forecasting the price of a financial asset is a complex challenge. In general, the price is determined by a variety of variables, economic cycles, unforeseen events, psychological factors, market sentiment, the weather, or even war. All these variables will more or less have an influence on the price of the financial asset. In addition, many of these variables are interdependent, which makes statistical modeling even more complex. 

A univariate forecast model reduces this complexity to a minimum – a single factor and ignores the other dimensions. A multivariate model is a simplification as well, but it can take several factors into account. For example, a multivariate stock market prediction model can consider the relationship between the closing price and the opening price, moving averages, daily highs, the price of other stocks, and so on. Multivariate models are not able to fully cover the complexity of the market. However, they offer a more detailed abstraction of reality than univariate models. Multivariate models thus tend to provide more accurate predictions than univariate models.

![](../machine_learning_model/Resources/uni_multi.png)

For the multivariate model, we have included open, high, low, close prices, and volume of this ETF as our features. 

![](../machine_learning_model/Resources/rye_multi.png)

Because the exchange traded fund of our selection is an ETF from the energy sector, in addtion to the open, high, low, close prices, and volume of this ETF, we have also included the Brent Spot Price of Crude Oil into our neural networks model. 

![](../machine_learning_model/Resources/sequential_daily.png)  

The correlation between the ETF closing price and Crude oil closing price shows below.  

![](../machine_learning_model/Resources/correlation_RYE_Oil.png)  

After thorough group discussion, we have decided to proceed with one univariate approach and one multivariate approach. The univariate approach will be using the ARIMA model, to predict the future ETF prices solely based on the historical ETF prices. The multivariate approach will be using the Sequential model in neural networks, taking the open, high, low, close prices, volume, as well as the Brent Spot Price of Crude Oil into consideration. Below shows the features that we are going to use in our multivariate model. 

![](../machine_learning_model/Resources/features.png)

### Data split into training and testing sets

For both models, ARIMA and Sequential, we have split the data into 80% training dataset and 20% testing dataset. 

![](../machine_learning_model/Resources/arima_split.png)

### Models of choice

#### ARIMA

The Auto ARIMA `auto_arima` function is used to identify the most optimal parameters for an ARIMA model, and returns a fitted ARIMA model. This function is based on the commonly-used R function, `forecast::auto.arima`. It works by conducting different tests, including Kwiatkowski–Phillips–Schmidt–Shin, Augmented Dickey-Fuller or Phillips–Perron, to determine the order of differencing, d, and then fitting models within ranges of defined start_p, max_p, start_q, max_q ranges. If the seasonal optional is enabled, it can also identify the optimal P and Q hyper-parameters after conducting the Canova-Hansen to determine the optimal order of seasonal differencing, D. 

As can be seen from below results, the best model that we will proceed with is `ARIMA(0,1,0)`. 

```
Performing stepwise search to minimize aic
 ARIMA(0,1,0)(0,0,0)[0] intercept   : AIC=-14267.273, Time=0.11 sec
 ARIMA(1,1,0)(0,0,0)[0] intercept   : AIC=-14265.770, Time=0.18 sec
 ARIMA(0,1,1)(0,0,0)[0] intercept   : AIC=-14265.808, Time=0.12 sec
 ARIMA(0,1,0)(0,0,0)[0]             : AIC=-14269.250, Time=0.06 sec
 ARIMA(1,1,1)(0,0,0)[0] intercept   : AIC=-14267.863, Time=0.72 sec

Best model:  ARIMA(0,1,0)(0,0,0)[0]          
Total fit time: 1.202 seconds
                               SARIMAX Results                                
==============================================================================
Dep. Variable:                      y   No. Observations:                 2910
Model:               SARIMAX(0, 1, 0)   Log Likelihood                7135.625
Date:                Sun, 10 Apr 2022   AIC                         -14269.250
Time:                        14:20:14   BIC                         -14263.275
Sample:                             0   HQIC                        -14267.098
                               - 2910                                         
Covariance Type:                  opg                                         
==============================================================================
                 coef    std err          z      P>|z|      [0.025      0.975]
------------------------------------------------------------------------------
sigma2         0.0004   5.29e-06     81.916      0.000       0.000       0.000
===================================================================================
Ljung-Box (L1) (Q):                   0.50   Jarque-Bera (JB):              6432.95
Prob(Q):                              0.48   Prob(JB):                         0.00
Heteroskedasticity (H):               0.40   Skew:                            -0.50
Prob(H) (two-sided):                  0.00   Kurtosis:                        10.22
===================================================================================

Warnings:
[1] Covariance matrix calculated using the outer product of gradients (complex-step).
```

![](../machine_learning_model/Resources/arima_auto_arima.png)

#### Neural networks - Sequential

Multivariate models are trained on a three-dimensional data structure. The first dimension is the sequences, the second dimension is the time steps (batches), and the third dimension is the features. Below shows the steps that we have used to transform the multivariate data into a shape that our neural networks model can process during the training. When doing a forecast later on, we will use the same structure. 

![](../machine_learning_model/Resources/transforming.png)

Below shows the shape of our 1-day, 3-day, and 5-day training and testing datasets. 

```
# 1-day
Train X shape: (2864, 50, 6)
Train Y shape: (2864, 1)
Test X shape: (678, 50, 6)
Test Y shape: (678, 1)

# 3-day
Train X shape: (2862, 50, 6)
Train Y shape: (2862, 1)
Test X shape: (676, 50, 6)
Test Y shape: (676, 1)

# 5-day
Train X shape: (2860, 50, 6)
Train Y shape: (2860, 1)
Test X shape: (674, 50, 6)
Test Y shape: (674, 1)
```

Below shows the structure of our Sequential models. 

```
Number of neurons: 300
Training data shape: (2864, 50, 6)
Model: "sequential"
_________________________________________________________________
 Layer (type)                Output Shape              Param #   
=================================================================
 lstm (LSTM)                 (None, 50, 300)           368400    
                                                                 
 lstm_1 (LSTM)               (None, 300)               721200    
                                                                 
 dense (Dense)               (None, 5)                 1505      
                                                                 
 dense_1 (Dense)             (None, 1)                 6         
                                                                 
=================================================================
Total params: 1,091,111
Trainable params: 1,091,111
Non-trainable params: 0
_________________________________________________________________
```

Another important step in our multivariate model is to slice the data into multiple input data sequences with associated target values. Two variables, `sequence_length` and `pred_int` will be defined here with the option to modify for different model training. 

We have used the sliding windows algorithm, which moves a window step by step through the time series data, adding a sequence of `sequence_length` number of data points to the train sequence (input data) with each step. Then, the algorithm stores the target value (close) following this train sequence by `pred_int` positions in a separate target value dataset. This process will repeat itself with the window and the target value pushed further until going through the entire time series data. Eventually, the algorithm will create a dataset containing the train sequences (batches) and their corresponding target values. This process will be applied to both training and testing data. 

![](../machine_learning_model/Resources/batch.png)

The model loss drops quickly until stablized at a lower level, impling that the model has improved throughout the training process. Below shows the model loss for our 1-day model only. The model loss for the 3-day and 5-day models are available in the Resources folder in the [machine_learning_model](https://github.com/kobertlam/Energy_ETF_RYE_Forecast/tree/machine_learning_model) branch. 

![](../machine_learning_model/Resources/sequential_model_loss1.png)

### Results

#### ARIMA

Below shows the results of the forecast by our ARIMA model on the test dataset based on 95% confidence level. 

![](../machine_learning_model/Resources/arima_forecast.png)

Due to the huge fluctuation of the ETF prices, the time series model ARIMA does not work very well in forecasting the future prices, which is expected, as there are other far more significant variables that have impact on the prices of this ETF. Below shows some commonly used accuracy metrics to evaluate our forecast results. 

```
Mean Squared Error: 0.14445563111243653
Mean Absolute Error: 0.28327873123343045
Root Mean Squared Error: 0.38007319178342025
Mean Absolute Percentage Error: 0.08338582241621081
```

#### Neural networks - Sequential

Below shows the predictions vs actuals from the full time period. 

![](../machine_learning_model/Resources/sequential_predictions_full.png)

Below shows the predictions vs actuals from the test time period only. 

![](../machine_learning_model/Resources/sequential_predictions_test.png)

We have created the function of making a prediction based on the current data on the ETF price of a future date. The interval between the future date and the latest date from the dataset can be adjusted by changing `pred_int`. Currently, `pred_int` is set to 1 to predict the next day's ETF close price. For example, `pred_int` can be set to 5 to predict the next week's (5 business days hereon) ETF close price. From our latest run, we have created 3 models with `pred_int` to be 1, 3, and 5, and we have got the following excellent results. 

As for our 1-day model, the MAPE is 2.26% which means the mean of our predictions deviates from the actual values by 2.26%. The MDAPE is 1.56%, lower than the MAPE, which means there are some outliers among the forecast errors. Half of our forecasts deviate by more than 1.56% while the other half by less than 1.56%. 

```
# 1-day
Median Absolute Error (MAE): 0.81
Mean Absolute Percentage Error (MAPE): 2.26 %
Median Absolute Percentage Error (MDAPE): 1.56 %

# 3-day
Median Absolute Error (MAE): 1.56
Mean Absolute Percentage Error (MAPE): 4.27 %
Median Absolute Percentage Error (MDAPE): 3.12 %

# 5-day
Median Absolute Error (MAE): 1.95
Mean Absolute Percentage Error (MAPE): 5.76 %
Median Absolute Percentage Error (MDAPE): 3.98 %
```

#### Post-processing and results

Below shows an overview of the DataFrame after our processing and with our forecasts. 

![](../machine_learning_model/Resources/forecasts_table.png)

Below shows the forecasts from our 1-day, 3-day, and 5-day models respectively. 

![](../machine_learning_model/Resources/forecasts.png)

### Flow Chart

The flow chart can be seen below. 

![Machine Learning Flow Chart](../machine_learning_model/Resources/ml_flow_chart1.jpeg)

## Dashboard

We export the data from [`master.ipynb`](../main/master.ipynb) into CSV files, and then import the CSV files into [Tablueau Public](https://public.tableau.com/app/profile/kobert.lam/viz/EnergyETFRYEBrentOilViz/EnergyETFRYEBrentOilViz?publish=yes) to create interactive dashboard.
The data of the predicted RYE prices come from the results of the neural networks models.

Here is the outline of the dashboard:

![Dashboard Blueprint1](../presentation/Resources/RYE_Portfolio.png)
![Dashboard Blueprint2](../presentation/Resources/Time-Series.png)

The dashboard will include the following viz:
1. A Heatmap for Energy ETF (RYE) portfolio breakdown
2. A bar chart showing the market value of the individual company within RYE
3. A time-series plot showing both the Brent crude oil price and RYE price
4. A time-series plot showing the seasonal changes on oil and RYE price
5. A time-series plot showing the historical and future price of RYE for the next day, next 3 or 5 days

The interactive elements:
* There will be a linkage between the heatmap and bar chart, so that user can filter the data by **Sector**, and both charts will be updated based on the selected Sector
* User can select different prediction of RYE prices for the next day, next 3 days, or next 5 days

## Technologies

Details can also be found in the [technologies](https://github.com/kobertlam/Energy_ETF_RYE_Forecast/tree/technologies) branch. 

### Database Storage

PostgreSQL is used in our project, as it is efficient for us to connect through Python/Jupyter Notebook/Jupyter Lab.

### Data Cleaning and Analysis

`Yfinance` package is used to acquire the data though Yahoo Finance api. Pandas is used to clean the data and export to our local PostgreSQL database. 

In a separate notebook, pandas is used with a SQL query to join two tables and import them from our local PostgreSQL database into our notebook. Then, Pandas is used to perform further analysis. 

### Machine Learning

ARIMA and TensorFlow with Keras Sequential Model are the Machine Learning models that we have used. Details can also be found in the [machine_learning_model](https://github.com/kobertlam/Energy_ETF_RYE_Forecast/tree/machine_learning_model) branch. 

### Dashboard
Tableau is used to create an interactive dashboard. 
  
## Conclusion  

### Answers to the questions

1. Are there seasonal trends and patterns on the Energy ETF? Can we forecast the future ETF prices solely based on the historical ETF prices (time series)?

    - Yes, there are. Base on our analysis in [Stationarity Analysis](https://github.com/kobertlam/Energy_ETF_RYE_Forecast#stationarity-analysis), we have used the [Augmented Dickey-Fuller Test](https://en.wikipedia.org/wiki/Augmented_Dickey%E2%80%93Fuller_test) to check if our time series data is stationary or not, and the results show that the data is non-stationary, which means there are seasonal trends and patterns. 

    - No, based on our ARIMA model, we are not able to forecast the future ETF prices accurately solely based on the historical ETF prices (time seires). 

2. Is there any relationship between the crude oil prices and the ETF prices? Can we forecast the future ETF price based on both the historical ETF prices and the historical crude oil prices?

    - Pedro

    - Yes, based on our Keras Sequential model, we have built models that are able to provide forecasts with decent accuracy to the future ETF price based on both the historical ETF prices and the historical crude oil prices. 

### Results and Limitations

Due to the fluctuation of the ETF prices and lack of seasonality of data, the time series ARIMA model wasn't able to provide decent future price forecasts. 

However, through neural networks sequential model, we are able to find relatively accurate ETF price predictions 1, 3, or 5 day(s) ahead. As for our 1-day model, the MAPE is 2.26% which means the mean of our predictions deviates from the actual values by 2.26%. The MDAPE is 1.56%, lower than the MAPE, which means there are some outliers among the forecast errors. Half of our forecasts deviate by more than 1.56% while the other half by less than 1.56%. The prediction accuracy of these 3 models tend to decrease with the increase of prediction intervels. 

### Recommendations

Though our current sequential models perform well and serves as a great tool for investors to make decisions, they do require time and energy from investors to frequently look at the predictions and make adjustments if applicable. For long-term strategy planning, it will definitely require better prediction accuracy from a longer time interval. While we have current models focus on the price volatility, we suggest to enhance the project by adding Fear & Greed Index as a feature/variable to assess the market sentiment impact on ETF prices. 

The Facebook Prophet model can also be tried as an alternative to the sequential model, to see if it is able to provide more accurate forecasts. 

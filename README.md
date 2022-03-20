# Oil Price and Stock Price Analysis

This is the final project for Data Analytics Bootcamp for our group (Group 4). We have integrated the data analystic skills and tools we have learnt from the bootcamp into this final project.

We aim to, based on the crude oil price, predict the stock prices of a portfolio that we have created which includes the 10 largest oil companies by market cap traded in the stock market.

## [Purpose of this Project](https://github.com/kobertlam/Oil_Price_and_Stock_Price_Analysis/tree/presentation)

### Background

Brent crude spot price jumped to $133 a barrel on March 8, 2022 and it represents the highest oil prices since 2008. Oil companies supply billions of barrels of petroleum products daily to power transportation and industry. The fluctuation of the crude oil price has direct impact on the production cost of the carbon-based fuels and products, which in turn impacting the profitability and the stock prices of the oil companies. In this project, we would like bring insights to fund managers and investors who are interested in investing the oil-related sector. We will study if there is any relationship between the crude oil price and the stock prices of the top 10 oil companies trading in U.S. Ideally, we may suggest if the portfolio is currently under-valued or over-valued for investing, and also see if we are able to identify a trend or pattern in the future.

### Questions to be Answered

1. Is there any relationship between the crude oil price and the stock prices of the oil companies?
2. What are the trends and patterns of the portfolio prices?
3. Which oil company stock(s) would be affected the most by the crude oil prices? Which would be affect the least? 
4. Any sessional trends and patterns on crude oil price?

### Benefits

The value investment theories indicate that the market/stock value of any company tends to approach the actual/real value. If we are able to determine the relationship between the stock prices of the oil companies and the crude oil prices, investors or fund managers will be able to make better decisions when analyzing the stock market. 

### Team Collaboration - Communication Protocols

* We created a private group chat in `Slack` as the primary communication channel within the team.
* We also used Zoom meeting for group collaboration.

## Data Source

The data that we will be using are from the following sources. The data tables are available in the [dataset](https://github.com/kobertlam/Oil_Price_and_Stock_Price_Analysis/tree/dataset) branch. 

1. Dataset for [Brent Crude Oil Price](https://www.eia.gov/dnav/pet/hist_xls/RBRTEd.xls) (Brent Spot Price, dollars per Barrel) from U.S. Energy Information Administration
2. [Nasdaq Screener](https://www.nasdaq.com/market-activity/stocks/screener) to select top 10 oil companies
3. Stock price from [`yfinance`](https://pypi.org/project/yfinance/) Yahoo! Finance's API 

## Machine Learning Model

* The models will use one dependent variable (stock price) and one independent variable (oil price).
* The programming language will be Python and the main libraries are: Numpy, Pandas, Matplotlib and SickitLearn. 
* We have decided to use 3 different Machine Learning Models: Regression Analysis, Random Forest and Tensor Flow.

* ![Machine Learning Flow Chart](https://github.com/kobertlam/Oil_Price_and_Stock_Price_Analysis/blob/machine_learning_model/Resources/ml_flow_chart.jpeg)

## [Database](https://github.com/kobertlam/Oil_Price_and_Stock_Price_Analysis/tree/database)

We've decided to use SQL, and the ERD was created based on the datasets below:
1. brent_spot_price_crude_oil
* Primary key: date
2. nasdaq_screener
* Primary key: ticker
3. Top 10 oil companies historical stock price - 10 ticker files
* Foreign Key: date
* Foreign Key: ticker

Our ERD is shown below and details are available in the [database](https://github.com/kobertlam/Oil_Price_and_Stock_Price_Analysis/tree/database) branch. 

![QuickDBD](https://github.com/kobertlam/Oil_Price_and_Stock_Price_Analysis/blob/database/Resources/QuickDBD.png)

Note: Table 11 and 12 are not displayed with full information due to the limitation of free version QuickDBD.

## [Technologies Used](https://github.com/kobertlam/Oil_Price_and_Stock_Price_Analysis/tree/technologies)

### Data Cleaning and Analysis
Pandas will be used to clean the data and perform an exploratory analysis. Further analysis will be completed using Python/Jupyter Notebook/Jupyter Lab.

### Database Storage
PostgreSQL is the database we intend to use, and we will connect to the database through Python/Jupyter Notebook/Jupyter Lab.

### Machine Learning

Regression Analysis, Random Forest, TensorFlow with Keras Sequential Model are the Machine Learning libraries we'll be using. Please refer to [the Machine Learning Model section](https://github.com/kobertlam/Oil_Price_and_Stock_Price_Analysis#machine-learning-model). Details can also be found at the [machine_learning_model](https://github.com/kobertlam/Oil_Price_and_Stock_Price_Analysis/tree/machine_learning_model) branch. 

### Dashboard
Tableau will be used to create a interactive dashboard. 

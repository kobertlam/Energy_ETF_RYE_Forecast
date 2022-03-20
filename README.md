# Oil Price and Stock Price Analysis

This is the final project for Data Analytics Bootcamp for our group (Group 4). We integrated the data analystic skills and tools we learnt from the bootcamp into this final project.

## [Objective](https://github.com/kobertlam/Oil_Price_and_Stock_Price_Analysis/tree/presentation)

* **Topic:** Predicting the stock prices for a portfolio of the top 10 oil companies trading in U.S. based on the crude oil price.
* Brent crude spot price jumped to $133 a barrel on 8 March 2022 represents the highest oil prices since 2008.  Oil companies supply billions of barrels of petroleum products daily to power transportation and industry.  The fluctuation of the crude oil price has direct impact on the production cost of the carbon-based fuels and products, which in turn impacting the profitability and the stock prices of the oil companies.  In this project, we would like bring insights to fund managers and investors who are interested in investing the oil-related sector.  We will study if there is any relationship between the crude oil price and the stock prices of the top 10 oil companies trading in U.S.  Ideally, we may suggest if the portfolio is currently under-valued or over-valued for investing, and also the trend in the future.
  
## [Source of Data](https://github.com/kobertlam/Oil_Price_and_Stock_Price_Analysis/tree/dataset)

1. Dataset for [Brent Crude Oil Price](https://www.eia.gov/dnav/pet/hist_xls/RBRTEd.xls) (Brent Spot Price, dollars per Barrel) from U.S. Energy Information Administration
2. [Nasdaq Screener](https://www.nasdaq.com/market-activity/stocks/screener) to select top 10 oil companies
3. Stock price from [`yfinance`](https://pypi.org/project/yfinance/) Yahoo! Finance's API 

## Questions to Answer with the Data

1. What is the best and worst performers among the 10 oil companies?
2. Any sessional pattern on crude oil price?
3. Is there any relationship between the crude oil price and the stock prices of the oil companies?
4. What is the trend of the portfolio price?

## Communication Protocols

* We created a private group chat in `Slack` as the primary communication channel within the team.
* We also used Zoom meeting for group collaboration.

## Machine Learning Model

* by *Pedro*

## [Database Model](https://github.com/kobertlam/Oil_Price_and_Stock_Price_Analysis/tree/database)

![QuickDBD](https://user-images.githubusercontent.com/93500353/159140505-adecb2ca-1ac1-481a-97da-a7c9e87b2562.png)

We've decided to use SQL, and the ERD was created based on the datasets below:
1. brent_spot_price_crude_oil
* Primary key: date
2. nasdaq_screener
* Primary key: ticker
3. Top 10 oil companies historical stock price - 10 ticker files
* Foreign Key: date
* Foreign Key: ticker
  
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
# Machine Learning Models

## Data preprocessing

After acquiring our datasets, we have imported them into our Jupyter Notebook, conducted some preprocessing, and completed some preliminary analysis. 

Below shows the historical daily close prices of the Invesco S&P 500 Equal Weight Energy ETF, which is an exchange traded fund with a portfolio of companies in the energy sector. 

![](Resources/rye_daily.png)

The data is also visualized below through a probability distribution. 

![](Resources/rye_probability_distribution.png)

Commonly, a given time series consist of three systematic components and one non-systematic component. The three systematic components include Level, Trend, and Seasonality. The one non-systematic component is noice. 

![](Resources/rye_stationarity.png)

## Feature engineering and selection

## Data split into training and testing sets

## Models of choice

### ARIMA

### Sequential

## Results

















![](Resources/rye_seasonality.png)

![](Resources/rye_masd.png)



![](Resources/arima_split.png)

![](Resources/arima_auto_arima.png)

![](Resources/arima_forecast.png)

![](Resources/rye_multi.png)

![](Resources/sequential_model_loss.png)

![](Resources/sequential_predictions_full.png)

![](Resources/sequential_predictions_test.png)


## Labels

For now, our models will use one dependent variable and only one independent variable for now. More can be explored in the future. 

The dependent variable (Y) will be the scaled stock price of the portfolio composed of 10 largest oil companies. 

The independent variable (X) will be the brent spot price of the crude oil. 

## Proposed Machine Learning Models to Use

1. Supervised Regression Analysis: establish a relationship between the two variables by estimating how much one variable affects the other.
2. Random Forest: take into consideration mutliple regression decision trees and calculates the averages of all predictions to generate an expected stock price.
3. TensorFlow with Keras Sequential Model: Deep learning model where each layer receives input information, calculate the parameters and output the information transformed, following the same process to the next layer until the final result. 

## Flow Chart

The flow chart can be seen below. 

![Machine Learning Flow Chart](https://github.com/kobertlam/Oil_Price_and_Stock_Price_Analysis/blob/machine_learning_model/Resources/ml_flow_chart.jpeg)
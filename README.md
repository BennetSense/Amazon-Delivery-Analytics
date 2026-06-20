\# Amazon Delivery Analytics



\## Project Overview



This project analyzes Amazon delivery operations using SQL, Python, Power BI, and Machine Learning.



The objective is to identify the main factors affecting delivery time, perform statistical analysis, build predictive models, and generate business recommendations for improving delivery performance.



\---



\## Business Problem



Delivery time directly impacts customer satisfaction and operational costs.



This project investigates:



\- Which factors increase delivery time

\- Impact of traffic conditions

\- Impact of weather

\- Delivery performance by hour

\- Delivery performance by weekday

\- Feature importance using Machine Learning



\---



\## Dataset



Amazon Delivery Dataset



Records: 43,492



Features include:



\- Agent Age

\- Agent Rating

\- Weather

\- Traffic

\- Vehicle

\- Area

\- Category

\- Distance

\- Preparation Time

\- Delivery Time



\---



\## Technologies Used



\- Python

\- Pandas

\- NumPy

\- Matplotlib

\- Seaborn

\- SciPy

\- Scikit-Learn

\- SQL

\- Power BI



\---



\## Project Structure



```

Amazon-delivery-analytics/



│

├── Data/

├── Python/

├── SQL/

├── PowerBI/

├── Images/

├── Docs/

├── README.md

└── requirements.txt

```



\---



\## Exploratory Data Analysis



Performed:



\- Data Cleaning

\- Missing Value Handling

\- Feature Engineering

\- Correlation Analysis

\- Outlier Detection

\- Distance Calculation (Haversine Formula)



Visualizations:



\- Delivery Time Distribution

\- Traffic Analysis

\- Weather Analysis

\- Distance vs Delivery Time

\- Orders by Hour

\- Delivery Time by Hour

\- Delivery Time by Weekday



\---



\## Statistical Analysis



Performed ANOVA tests for:



\- Traffic

\- Weather

\- Vehicle Type



Results showed statistically significant differences between groups.



\---



\## Machine Learning



Models:



\- Linear Regression

\- Random Forest Regressor



Model Comparison



| Model | R² |

|------|------|

| Linear Regression | 0.29 |

| Random Forest | 0.80 |



Random Forest significantly outperformed Linear Regression.



\---



\## Feature Importance



Most important predictors:



1\. Category

2\. Agent Rating

3\. Weather

4\. Distance

5\. Agent Age



\---



\## Business Insights



\- Heavy traffic significantly increases delivery time.

\- Weather conditions affect delivery efficiency.

\- Longer distances increase delivery duration.

\- Evening hours experience the longest deliveries.

\- Random Forest provides accurate delivery time prediction.



\---



\## Business Recommendations



\- Optimize routes during traffic peaks.

\- Improve courier assignment.

\- Consider weather forecasts when planning deliveries.

\- Use predictive models for ETA estimation.



\---



\## Author



Abdulla Kazimli



Junior Data Analyst



Baku, Azerbaijan


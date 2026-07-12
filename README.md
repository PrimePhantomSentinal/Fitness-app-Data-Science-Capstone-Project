# Fitness App Data Science Capstone Project

## Project Title

**Assess Fitness App Usage & Calorie Burn Patterns to Drive Personalized Engagement**

## Project Overview

This capstone project analyzes fitness app user profiles, workout activity, calorie burn patterns, and app engagement behaviour.

The goal is to understand:

- Who uses the app
- Which workouts users prefer
- Which workouts burn more calories
- How users engage with app features
- Whether notifications, completions, and purchases show useful engagement patterns
- How simple machine learning models can support personalized engagement

## Main Notebook

The main project notebook is:

```text
app/main.ipynb
```

The notebook includes:

- Data loading and inspection
- Data cleaning checks
- Exploratory Data Analysis
- Statistical analysis
- Hypothesis testing
- Feature engineering
- Dataset merging
- SQLite analysis
- Machine learning models
- Business summary and recommendations

## Dataset Files

The local dataset folder is:

```text
Datasets /
```

It contains:

- `User_Profile.xlsx`
- `Activity.xlsx`
- `App_Engagement.xlsx`
- `FitTech_Final_Dataset.xlsx`
- `README.md`

Excel datasets are ignored by Git to avoid pushing raw/generated data files repeatedly.

For reproducibility, the dataset package is included as:

```text
Datasets .zip
```

## Machine Learning Models Implemented

The notebook implements:

- Logistic Regression
- KNN
- Decision Tree
- Linear Regression

The classification models predict whether a user is highly engaged.

The regression model predicts total session time.

The notebook also uses:

- Label encoding for ordered `Age_Group`
- OneHotEncoder for unordered categorical columns
- StandardScaler for scaled model inputs
- Confusion matrix visual for classification interpretation

## SQL and Database Documentation

Database-related files are stored in:

```text
database_docs/
```

Files included:

- `fittech_database_schema.sql`
- `fittech_sql_automations.sql`
- `lucidchart_erd_prompt.md`

These files support database schema creation, business SQL views, and ERD generation in Lucidchart.

## Learning Guides

Supporting explanation files:

- `Objective_4_5_7_10_Learning_Guide.md`
- `Machine_Learning_Models_Line_By_Line_Guide.md`
- `Screenshot_Changes_Log.md`

These files explain the project work in a beginner-friendly way.

## Important Run Setting

The notebook contains:

```python
SAVE_OUTPUTS = False
```

This prevents `Run All` from repeatedly generating Excel files, model files, and database files.

Change it to `True` only when exports are intentionally needed.

## Project Tools Used

- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- SQLite
- Scikit-learn
- Power BI
- Lucidchart

## Business Use Cases

This project can support:

- Personalized reminders
- Workout recommendations
- User engagement segmentation
- Subscription strategy
- App feature improvement
- Dashboard and reporting development

## Current Status

The Python notebook, SQL documentation, machine learning explanation, and business summary are ready.

Excel dashboard and Power BI reporting can be further improved as the next project step.

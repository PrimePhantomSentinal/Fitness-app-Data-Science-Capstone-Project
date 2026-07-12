# Objective 4, 5, 7 and 10 Learning Guide

This file explains the knowledge needed for Objective 4, 5, 7 and 10, followed by how those parts were implemented in the project notebook.

The project is:

**Assess Fitness App Usage & Calorie Burn Patterns to Drive Personalized Engagement**

---

## Part 1: Prerequisite Knowledge

### Objective 4: Statistical Analysis

Before understanding Objective 4, these concepts are important.

#### 1. Descriptive Statistics

Descriptive statistics help summarize the data.

Common examples:

- Mean: average value
- Median: middle value
- Minimum and maximum: lowest and highest values
- Standard deviation: how spread out the values are
- Count: number of records

In this project, descriptive statistics help understand workout duration, calories burned, steps, and session duration.

#### 2. Correlation

Correlation checks whether two numerical columns move together.

Example:

- If workout duration increases, do calories burned also increase?
- If steps increase, do calories burned increase?

Correlation values usually range from `-1` to `+1`.

- Close to `+1`: strong positive relationship
- Close to `-1`: strong negative relationship
- Close to `0`: weak or no relationship

#### 3. Groupby Analysis

`groupby()` is used to compare values across categories.

Example:

```python
activity_df.groupby('Workout_Type')['Calories_Burned'].mean()
```

This helps answer questions like:

- Which workout type burns the most calories on average?
- Which feature has the longest average session duration?

#### 4. Crosstab

`pd.crosstab()` compares two categorical columns.

Example:

```python
pd.crosstab(user_profile_df['Subscription_Type'], user_profile_df['Goal_Type'])
```

This helps compare user goals across subscription plans.

#### 5. Hypothesis Testing

Hypothesis testing is used to check whether a pattern is statistically meaningful.

Basic terms:

- Null Hypothesis `(H0)`: assumes there is no difference or no relationship.
- Alternate Hypothesis `(H1)`: assumes there is a difference or relationship.
- P-value: helps decide whether to reject the null hypothesis.

Simple rule used in this project:

```text
If p-value < 0.05, reject H0.
If p-value >= 0.05, fail to reject H0.
```

#### 6. Tests Used

ANOVA:

- Used when comparing average values across more than two groups.
- In this project, it checks whether average calories burned differs by workout type.

Chi-square test:

- Used when comparing two categorical columns.
- In this project, it checks whether notification click and workout completion are related.

T-test:

- Used when comparing the average of two groups.
- In this project, it checks whether session duration differs between users who clicked notifications and users who did not.

---

### Objective 5: Feature Engineering

Feature engineering means creating useful new columns from existing columns.

#### 1. What Is a Feature?

A feature is an input column used for analysis or machine learning.

Example:

- `Duration_Minutes`
- `Calories_Burned`
- `Workout_Type`
- `Subscription_Type`

#### 2. Why Feature Engineering Is Needed

Raw columns are useful, but sometimes new columns make analysis easier.

Example:

Instead of only using:

```text
Calories_Burned
Duration_Minutes
```

we can create:

```text
Calories_Per_Minute
```

This gives a better idea of workout intensity.

#### 3. Common Beginner Feature Engineering Techniques

Ratio feature:

- Example: calories burned per minute

Category feature:

- Example: short, medium, or long workout

Flag feature:

- Example: notification clicked flag
- `Yes` becomes `1`
- `No` becomes `0`

Mapping feature:

- Example: converting age groups into numbers

#### 4. Important Caution

Feature engineering can happen before merging if the feature only uses one table.

Example:

- `Calories_Per_Minute` can be created inside `activity_df`.

But features that need multiple tables should be created after merging.

Example:

- User-level engagement score using activity + engagement + profile data should be created after merging.

---

### Objective 7: SQLite Analysis

SQLite is a lightweight database used to store and query data.

#### 1. Why SQLite Is Used

SQLite helps practice SQL queries inside the project without needing a separate database server.

It is useful for:

- Storing cleaned datasets
- Running business queries
- Creating summary reports
- Automating small business outputs

#### 2. Tables

A table stores data in rows and columns.

In this project, important SQLite tables include:

- `user_profile`
- `activity`
- `app_engagement`
- `activity_summary`
- `engagement_summary`
- `final_user_summary`

#### 3. Basic SQL Commands

`SELECT`

Used to choose columns.

```sql
SELECT User_ID, Total_Workouts
FROM final_user_summary;
```

`WHERE`

Used to filter rows.

```sql
WHERE Completion_Rate < 0.60
```

`GROUP BY`

Used to summarize by category.

```sql
GROUP BY Subscription_Type
```

`ORDER BY`

Used to sort results.

```sql
ORDER BY Purchase_Percentage DESC
```

#### 4. Business Queries

Business queries are SQL queries written to answer practical business questions.

In this project, SQL is used to answer questions such as:

- Which users are most active?
- Which subscription type has the highest average calories?
- Which region has higher session duration?
- Which goal type has better workout completion?

These queries support reporting and business interpretation without adding extra automation tables.

---

### Objective 10: Machine Learning

Machine learning is used to make predictions from data.

In this project, the model predicts whether a user is highly engaged.

#### 1. Supervised Learning

Supervised learning means the model learns from input columns and a known target column.

Example:

Input columns:

- Age group
- Region
- Subscription type
- Total workouts
- Completion rate

Target column:

- High engagement flag

#### 2. Classification

Classification is used when the target has categories.

In this project:

```text
High_Engagement_Flag = 1 means high engagement
High_Engagement_Flag = 0 means not high engagement
```

This is a classification problem.

#### 3. Train-Test Split

The dataset is split into:

- Training data: used to train the model
- Testing data: used to check model performance

This helps avoid judging the model only on data it already learned from.

#### 4. Encoding Categorical Columns

Machine learning models need numbers.

In the notebook, two encoding methods are used:

- `Age_Group` is label encoded because it has a natural order.
- Other text columns are one-hot encoded using `OneHotEncoder` because they do not have a meaningful order.

This avoids giving fake ranking to columns like `Region`, `Gender`, or `Goal_Type`.

#### 5. Models Used

Logistic Regression:

- Simple beginner-friendly classification model
- Good for yes/no prediction

KNN:

- Compares users with similar users
- Works better when values are scaled

Decision Tree:

- Easy to understand
- Splits data using simple decision rules

Linear Regression:

- Predicts a numerical value
- Used here to predict total session time

#### 6. Model Evaluation

The model is evaluated using:

- Accuracy
- Confusion matrix
- Classification report

Accuracy tells how many predictions were correct overall.

The confusion matrix shows:

- Correct predictions for class `0`
- Correct predictions for class `1`
- Wrong predictions for both classes

#### 7. Model Saving

After choosing a model, it can be saved using `joblib`.

This helps store the trained model for future use.

---

## Part 2: Implementation Explanation

### Objective 4 Implementation: Statistical Analysis

In the notebook, Objective 4 starts with basic statistical analysis.

The implementation includes:

1. Correlation between numerical activity columns:
   - `Duration_Minutes`
   - `Calories_Burned`
   - `Steps_Count`

2. Average calories by workout type:
   - This helps identify which workout type burns more calories on average.

3. Average session duration by feature used:
   - This helps identify which app features keep users engaged longer.

4. Crosstab between subscription type and goal type:
   - This helps compare user goals across subscription plans.

5. Hypothesis testing:
   - ANOVA for calories by workout type
   - Chi-square test for notification clicks and workout completion
   - T-test for session duration by notification click status

6. Validation summary:
   - The hypothesis test results are summarized and exported as `Validation_Summary.xlsx`.

This objective helps move from simple observation to statistically supported findings.

---

### Objective 5 Implementation: Feature Engineering

Objective 5 creates simple new columns for analysis and modeling.

Activity features created:

- `Calories_Per_Minute`
- `Duration_Category`
- `Steps_Category`

Engagement features created:

- `Notification_Clicked_Flag`
- `Workout_Completed_Flag`
- `Purchase_Flag`
- `Session_Duration_Category`

User profile features created:

- `Age_Group_Number`
- `Paid_User_Flag`

These features make the data easier to analyze and prepare it for merging, reporting, and machine learning.

The code is kept basic using:

- Division
- `pd.cut()`
- `map()`

---

### Objective 7 Implementation: SQLite Analysis

Objective 7 stores project data in SQLite and runs business queries.

The implementation includes:

1. Creating a SQLite connection:

```python
conn = sqlite3.connect('fittech.db')
```

2. Loading dataframes into SQLite tables using `to_sql()`.

3. Running SQL queries for:

- Top active users
- Average calories by subscription type
- Average session duration by region
- Purchase rate by subscription plan
- Workout completion rate by goal type
- High engagement users

4. Business SQL queries:

- Top active users
- Average calories by subscription type
- Average session duration by region
- Purchase rate by subscription plan
- Workout completion rate by goal type
- High engagement users

This objective connects the analysis to business use cases through clear SQL queries.

---

### Objective 10 Implementation: Machine Learning

Objective 10 builds a simple machine learning model.

The implementation steps are:

1. Copy the final merged dataset:

```python
ml_df = final_df.copy()
```

2. Create the target column:

```text
High_Engagement_Flag
```

Users with total session time greater than or equal to the median are marked as high engagement.

3. Select input columns:

- User profile columns
- Activity summary columns
- Engagement summary columns

4. Encode categorical columns using label encoding for `Age_Group` and `OneHotEncoder` for unordered text columns.

5. Split the data using `train_test_split()`.

6. Apply `StandardScaler` to scale the input columns.

7. Train classification models:

- Logistic Regression
- KNN
- Decision Tree

8. Evaluate classification models using:

- Accuracy
- Confusion matrix
- Classification report

9. Train a Linear Regression model to predict total session time.

10. Evaluate Linear Regression using:

- MAE
- RMSE
- R2 score

11. Select the best classification model based on testing accuracy.

12. Save the models, scaler, and model results:

- `Best_Engagement_Classification_Model.pkl`
- `Linear_Regression_Session_Time_Model.pkl`
- `Standard_Scaler.pkl`
- `One_Hot_Encoder.pkl`
- `ML_Model_Results.xlsx`

This objective is a beginner-level machine learning implementation. It is enough for a capstone first version, but it can be improved later.

---

## Part 3: How This Helps the Final Presentation

For the PowerPoint presentation, these objectives can be explained in this order:

1. What statistical analysis was done and why.
2. What new features were created and how they helped.
3. How SQL was used for business reporting.
4. What machine learning target was selected.
5. Which model was selected and why.
6. What recommendations came from the project.

The Excel dashboard and Power BI report can be prepared after the notebook work is stable. The current notebook gives the cleaned data, summaries, SQL reports, and model outputs needed to build those dashboards.


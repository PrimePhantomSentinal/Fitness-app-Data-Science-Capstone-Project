# Machine Learning Models Line-by-Line Guide

This file explains the machine learning section in `app/main.ipynb` in a beginner-friendly way.

The goal is not only to run models, but to tell a business story:

- Which users are likely to be highly engaged?
- Can we predict how much time users spend in the app?
- Which model gives a better result?
- How can this help the business improve engagement?

---

## 1. Machine Learning Story

In this project, machine learning is used in two ways.

### Classification Story

Classification is used to predict a category.

Here the category is:

```text
High engagement user or not high engagement user
```

The target column is:

```text
High_Engagement_Flag
```

Meaning:

```text
1 = High engagement user
0 = Not high engagement user
```

Business use:

- Find users who are likely to stay engaged.
- Identify users who may need reminders or personalized offers.
- Support retention and engagement campaigns.

Models used:

- Logistic Regression
- KNN
- Decision Tree

---

### Regression Story

Regression is used to predict a number.

Here the number is:

```text
Total_Session_Time
```

Business use:

- Estimate how much time a user may spend in the app.
- Understand which factors may increase engagement time.
- Support user engagement planning.

Model used:

- Linear Regression

---

## 2. Why StandardScaler Is Used

Some columns have small values.

Example:

```text
Completion_Rate = 0.75
Purchase_Rate = 0.12
```

Some columns have very large values.

Example:

```text
Total_Steps = 300000
Total_Calories = 50000
```

This can confuse some models because large-number columns may dominate smaller-number columns.

`StandardScaler` solves this by putting the columns on a similar scale.

It is especially useful for:

- Logistic Regression
- KNN
- Linear Regression

Decision Tree does not strictly need scaling, but using the same scaled data keeps the code simple.

---

## 3. Step-by-Step Code Explanation

### Step 1: Create a copy of the final dataset

```python
ml_df = final_df.copy()
```

Line-by-line explanation:

- `final_df` is the merged dataset.
- `.copy()` creates a separate copy for machine learning.
- This avoids accidentally changing the original final dataset.

---

### Step 2: Find the median session time

```python
median_session_time = ml_df['Total_Session_Time'].median()
```

Line-by-line explanation:

- `Total_Session_Time` shows total time spent by each user in the app.
- `.median()` finds the middle value.
- This median is used to divide users into high and low engagement groups.

---

### Step 3: Create the classification target

```python
ml_df['High_Engagement_Flag'] = np.where(
    ml_df['Total_Session_Time'] >= median_session_time,
    1,
    0
)
```

Line-by-line explanation:

- A new column called `High_Engagement_Flag` is created.
- `np.where()` works like an if-else condition.
- If `Total_Session_Time` is greater than or equal to the median, the value becomes `1`.
- Otherwise, the value becomes `0`.

Business meaning:

- `1` means the user is highly engaged.
- `0` means the user is not highly engaged.

---

### Step 4: Select input columns

```python
ml_features = [
    'Gender',
    'Age_Group',
    'Region',
    'Subscription_Type',
    'Goal_Type',
    'Preferred_Workout_Type',
    'Total_Workouts',
    'Avg_Calories',
    'Avg_Duration',
    'Total_Steps',
    'Completion_Rate',
    'Notification_Click_Rate',
    'Purchase_Rate'
]
```

Line-by-line explanation:

- This list stores the columns used as model inputs.
- Profile columns explain who the user is.
- Activity columns explain workout behavior.
- Engagement columns explain how users interact with the app.

Important point:

- `Total_Session_Time` is not used as an input for classification because it is used to create the target.
- This avoids data leakage.

---

### Step 5: Create X and y

```python
X = ml_df[ml_features]
y_classification = ml_df['High_Engagement_Flag']
y_regression = ml_df['Total_Session_Time']
```

Line-by-line explanation:

- `X` contains the input columns.
- `y_classification` is the target for classification models.
- `y_regression` is the target for Linear Regression.

Simple meaning:

```text
X = questions given to the model
y = answer the model should learn
```

---

### Step 6: Convert categorical columns into numbers

The notebook uses two encoding methods.

#### Label encoding for `Age_Group`

```python
age_group_order = {
    '18-25': 1,
    '26-35': 2,
    '36-45': 3,
    '46+': 4
}

X_encoded['Age_Group'] = X_encoded['Age_Group'].map(age_group_order)
```

Line-by-line explanation:

- `Age_Group` has a natural order.
- `18-25` is younger than `26-35`, and so on.
- Because there is a real order, label encoding makes sense here.
- `.map()` replaces each age group with a number.

#### One-hot encoding for unordered columns

```python
encoder = OneHotEncoder(drop='first', sparse_output=False, handle_unknown='ignore')

encoded_array = encoder.fit_transform(X_encoded[categorical_columns])
encoded_columns = encoder.get_feature_names_out(categorical_columns)
```

Line-by-line explanation:

- Columns like `Gender`, `Region`, `Goal_Type`, and `Preferred_Workout_Type` do not have a natural order.
- Label encoding these columns would create fake ranking.
- Example: Mumbai should not be treated as greater than Delhi just because of a number.
- `OneHotEncoder` converts each category into separate numeric columns.
- `drop='first'` removes one category from each group to avoid duplicate information.
- `handle_unknown='ignore'` prevents errors if a new category appears later.

Why not label encode everything?

- Label encoding works for ordered categories.
- It is not ideal for unordered categories when using Logistic Regression, KNN, or Linear Regression.
- So the notebook uses label encoding only where it fits well.

---

### Step 7: Split the data

```python
X_train, X_test, y_class_train, y_class_test, y_reg_train, y_reg_test = train_test_split(
    X,
    y_classification,
    y_regression,
    test_size=0.2,
    random_state=42,
    stratify=y_classification
)
```

Line-by-line explanation:

- `train_test_split()` divides the data into training and testing data.
- `X` is the input data.
- `y_classification` is the classification target.
- `y_regression` is the regression target.
- `test_size=0.2` means 20% of the data is used for testing.
- `random_state=42` keeps the split the same every time.
- `stratify=y_classification` keeps the balance of high and low engagement users similar in train and test data.

Why this matters:

- The model learns from training data.
- The model is checked on testing data.
- This helps us see whether the model works on unseen data.

---

### Step 8: Apply StandardScaler

```python
scaler = StandardScaler()
```

Explanation:

- This creates the scaler object.

```python
X_train_scaled = scaler.fit_transform(X_train)
```

Explanation:

- The scaler learns the mean and standard deviation from training data.
- Then it transforms the training data.

```python
X_test_scaled = scaler.transform(X_test)
```

Explanation:

- The same scaling is applied to test data.
- We do not use `fit_transform()` on test data because the test data should stay unseen.

---

## 4. Classification Models

### Logistic Regression

Code:

```python
logistic_model = LogisticRegression(max_iter=1000)
logistic_model.fit(X_train_scaled, y_class_train)
logistic_predictions = logistic_model.predict(X_test_scaled)
```

Line-by-line explanation:

- `LogisticRegression()` creates the model.
- `max_iter=1000` gives the model enough attempts to learn.
- `.fit()` trains the model using training data.
- `.predict()` predicts high or low engagement for test data.

Model purpose:

- Predict whether a user is highly engaged.

Business story:

- Useful for identifying users who may stay active in the app.

---

### KNN

Code:

```python
knn_model = KNeighborsClassifier(n_neighbors=5)
knn_model.fit(X_train_scaled, y_class_train)
knn_predictions = knn_model.predict(X_test_scaled)
```

Line-by-line explanation:

- `KNeighborsClassifier()` creates the KNN model.
- `n_neighbors=5` means the model checks the 5 nearest users.
- `.fit()` stores the training data pattern.
- `.predict()` predicts based on similar users.

Model purpose:

- Predict high engagement by comparing a user with similar users.

Business story:

- If a new user looks similar to highly engaged users, KNN may classify them as high engagement.

Why scaling matters:

- KNN depends on distance.
- Without scaling, large columns like steps could dominate the distance calculation.

---

### Decision Tree

Code:

```python
tree_model = DecisionTreeClassifier(max_depth=4, random_state=42)
tree_model.fit(X_train_scaled, y_class_train)
tree_predictions = tree_model.predict(X_test_scaled)
```

Line-by-line explanation:

- `DecisionTreeClassifier()` creates a tree model.
- `max_depth=4` keeps the tree small and simple.
- `random_state=42` makes the result repeatable.
- `.fit()` trains the tree.
- `.predict()` predicts engagement class.

Model purpose:

- Predict high engagement using simple decision rules.

Business story:

- Decision Trees are easy to explain because they work like if-else rules.

---

## 5. Classification Model Evaluation

Code:

```python
classification_results = pd.DataFrame({
    'Model': ['Logistic Regression', 'KNN', 'Decision Tree'],
    'Accuracy': [
        accuracy_score(y_class_test, logistic_predictions),
        accuracy_score(y_class_test, knn_predictions),
        accuracy_score(y_class_test, tree_predictions)
    ]
})
```

Line-by-line explanation:

- A dataframe is created to compare model results.
- Each model name is listed.
- `accuracy_score()` checks how many predictions were correct.

Simple meaning:

```text
Higher accuracy = better overall prediction performance
```

---

## 6. Best Classification Model

Code:

```python
best_classification_model_name = classification_results.sort_values(
    by='Accuracy',
    ascending=False
).iloc[0]['Model']
```

Line-by-line explanation:

- The results are sorted by accuracy.
- `ascending=False` means highest accuracy comes first.
- `.iloc[0]` selects the first row.
- `['Model']` selects the model name.

Business meaning:

- This tells which model is best for predicting high engagement in this project.

---

## 7. Confusion Matrix Visual

The notebook also creates a heatmap for the confusion matrix.

Code:

```python
best_confusion_matrix = confusion_matrix(y_class_test, best_classification_predictions)

plt.figure(figsize=(5, 4))
sns.heatmap(
    best_confusion_matrix,
    annot=True,
    fmt='d',
    cmap='Blues',
    xticklabels=['Not High Engagement', 'High Engagement'],
    yticklabels=['Not High Engagement', 'High Engagement']
)
plt.title('Confusion Matrix - ' + best_classification_model_name)
plt.xlabel('Predicted Value')
plt.ylabel('Actual Value')
plt.show()
```

Line-by-line explanation:

- `confusion_matrix()` compares actual values and predicted values.
- `plt.figure(figsize=(5, 4))` controls the chart size.
- `sns.heatmap()` creates the visual table.
- `annot=True` displays the numbers inside the boxes.
- `fmt='d'` shows the values as whole numbers.
- `cmap='Blues'` applies a blue color style.
- `xticklabels` shows predicted labels.
- `yticklabels` shows actual labels.
- The title includes the best model name.

Business meaning:

- This visual makes it easier to explain where the model is correct and where it is wrong.
- It supports the story of model performance in the final presentation.

---

## 8. Linear Regression Model

Code:

```python
linear_model = LinearRegression()
linear_model.fit(X_train_scaled, y_reg_train)
linear_predictions = linear_model.predict(X_test_scaled)
```

Line-by-line explanation:

- `LinearRegression()` creates the regression model.
- `.fit()` trains the model using input data and session time.
- `.predict()` predicts total session time for test users.

Model purpose:

- Predict a numeric value: `Total_Session_Time`.

Business story:

- Helps estimate how much time users may spend in the app.
- This can support engagement planning and user segmentation.

---

## 9. Regression Model Evaluation

Code:

```python
mae = mean_absolute_error(y_reg_test, linear_predictions)
rmse = np.sqrt(mean_squared_error(y_reg_test, linear_predictions))
r2 = r2_score(y_reg_test, linear_predictions)
```

Line-by-line explanation:

- `MAE` means average absolute error.
- `RMSE` gives a stronger penalty to bigger errors.
- `R2` explains how much variation the model can explain.

Simple interpretation:

- Lower MAE is better.
- Lower RMSE is better.
- Higher R2 is better.

---

## 10. Feature Importance

Feature importance helps explain what the model is using.

For Logistic Regression:

- Larger coefficients show stronger effect.

For Decision Tree:

- Larger importance values show more useful split features.

For KNN:

- KNN does not provide simple feature importance in the same direct way.
- So the notebook keeps this part simple.

Business story:

- Feature importance helps explain what may influence high engagement.

---

## 11. Saving Outputs

Code:

```python
joblib.dump(best_classification_model, 'Best_Engagement_Classification_Model.pkl')
joblib.dump(linear_model, 'Linear_Regression_Session_Time_Model.pkl')
joblib.dump(scaler, 'Standard_Scaler.pkl')
joblib.dump(encoder, 'One_Hot_Encoder.pkl')
```

Line-by-line explanation:

- `joblib.dump()` saves trained objects.
- The best classification model is saved.
- The Linear Regression model is saved.
- The StandardScaler is also saved because scaled models need the same scaler later.
- The OneHotEncoder is saved because future data must use the same category encoding.

Code:

```python
with pd.ExcelWriter('ML_Model_Results.xlsx') as writer:
    classification_results.to_excel(writer, sheet_name='Classification Results', index=False)
    regression_results.to_excel(writer, sheet_name='Regression Results', index=False)
    feature_importance.head(10).to_excel(writer, sheet_name='Top Features', index=False)
```

Line-by-line explanation:

- `pd.ExcelWriter()` creates an Excel file with multiple sheets.
- Classification model results are saved in one sheet.
- Regression results are saved in another sheet.
- Top model features are saved in another sheet.

---

## 12. How To Tell The Story In Presentation

You can explain it like this:

1. First, I created a target called `High_Engagement_Flag`.
2. Then I selected profile, activity, and engagement features.
3. I converted text columns into numbers.
4. I scaled the data because KNN, Logistic Regression, and Linear Regression are sensitive to value ranges.
5. I trained three classification models:
   - Logistic Regression
   - KNN
   - Decision Tree
6. I compared them using accuracy.
7. I selected the best classification model.
8. I also used Linear Regression to predict total session time.
9. This gives both:
   - A category prediction: high engagement or not
   - A numeric prediction: estimated session time
10. These models can help the business identify engaged users and plan retention strategies.

---

## 13. Final Beginner Summary

The machine learning section is simple but meaningful.

Classification models answer:

```text
Is this user likely to be highly engaged?
```

Linear Regression answers:

```text
How much total session time can we expect from this user?
```

Together, these models help turn fitness app data into a business story about engagement, retention, and personalization.

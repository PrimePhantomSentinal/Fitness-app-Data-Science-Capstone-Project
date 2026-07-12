# Screenshot Changes Log

This document lists the changes made in `app/main.ipynb` based on the screenshots.

## 1. Objective Numbering Clean-Up

- Renamed the merging section to `Objective 6: Merging the Datasets`.
- Renamed the SQLite section to `Objective 7: SQLite Analysis`.

## 2. SQL Query Fixes

- Fixed `Query 3: Average Session Duration by Region`.
- Fixed `Query 4: Purchase Rate by Subscription Plan`.
- These query titles now match the actual SQL code.

## 3. Validation Summary

- Added a simple validation summary after hypothesis testing.
- Saved the validation output as `Validation_Summary.xlsx`.
- The summary includes:
  - ANOVA result
  - Chi-square result
  - T-test result

## 4. Excel KPI Summary

- Removed `Objective 8: Excel KPI Summary` from the notebook because the Excel dashboard is still pending.
- Removed the placeholder file `FitTech_KPI_Summary.xlsx`.

## 5. Power BI Dashboard Preparation

- Removed `Objective 9: Power BI Dashboard Preparation` from the notebook because the Power BI report is still pending.
- Removed the placeholder file `PowerBI_Dashboard_Tables.xlsx`.

## 6. Machine Learning Improvements

- Updated the machine learning section to include:
  - Logistic Regression
  - KNN
  - Decision Tree
  - Linear Regression
- Added `StandardScaler` so scaled models make more sense.
- Created separate classification and regression results.
- Selected the best classification model based on accuracy.
- Saved:
  - `Best_Engagement_Classification_Model.pkl`
  - `Linear_Regression_Session_Time_Model.pkl`
  - `Standard_Scaler.pkl`
  - `One_Hot_Encoder.pkl`
  - `ML_Model_Results.xlsx`

## 7. Business Summary and Recommendations

- Added a final business summary section.
- Converted the final section into markdown so it reads like a project report.
- Added simple write-up sections for:
  - Business / operational summary
  - Recommendations
  - Conclusion
  - Limitations and challenges
  - Future scope
- The notebook no longer needs code cells for this final write-up section.

## 8. Kept the Code Simple

- Used basic pandas, SQLite, sklearn, and Excel export commands.
- Avoided complex pipelines and advanced model tuning.
- Kept the notebook organized by project phase/objective.

## 9. Run All Safety

- Added `SAVE_OUTPUTS = False` near the import cell.
- When this is `False`, running the full notebook does not recreate Excel files, model files, or the SQLite database file.
- Change it to `True` only when the files need to be intentionally exported again.

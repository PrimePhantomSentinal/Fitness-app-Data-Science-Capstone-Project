# Lucidchart ERD Prompt

Copy and paste this prompt into Lucidchart AI or use it as guidance when creating the ERD manually.

---

## Prompt

Create an Entity Relationship Diagram for a fitness app analytics database called **FitTech**.

The database contains three main source entities and three analytical summary entities.

### Entities and Columns

#### 1. user_profile

Primary key:

- User_ID

Columns:

- User_ID VARCHAR
- Gender VARCHAR
- Age_Group VARCHAR
- Region VARCHAR
- Subscription_Type VARCHAR
- App_Join_Date DATE
- Goal_Type VARCHAR
- Preferred_Workout_Type VARCHAR
- Engagement_Level DECIMAL

Description:

This table stores one row per user and contains demographic, subscription, goal, and workout preference details.

---

#### 2. activity

Primary key:

- Activity_ID

Foreign key:

- User_ID references user_profile.User_ID

Columns:

- Activity_ID VARCHAR
- User_ID VARCHAR
- Activity_Date DATE
- Workout_Type VARCHAR
- Duration_Minutes INT
- Calories_Burned INT
- Steps_Count INT
- Heart_Rate_Avg INT
- Workout_Time_of_Day VARCHAR
- Device_Used VARCHAR

Description:

This table stores workout activity records. One user can have many activity records.

---

#### 3. app_engagement

Primary key:

- Session_ID

Foreign key:

- User_ID references user_profile.User_ID

Columns:

- Session_ID VARCHAR
- User_ID VARCHAR
- Session_Date DATE
- Feature_Used VARCHAR
- Session_Duration_Minutes INT
- In_App_Purchase VARCHAR
- Notification_Clicked VARCHAR
- Workout_Completed VARCHAR
- User_Rating INT

Description:

This table stores app session and engagement records. One user can have many app engagement sessions.

---

#### 4. activity_summary

Primary key:

- User_ID

Foreign key:

- User_ID references user_profile.User_ID

Columns:

- User_ID VARCHAR
- Total_Workouts INT
- Total_Calories INT
- Avg_Calories DECIMAL
- Avg_Duration DECIMAL
- Total_Steps INT

Description:

This is a user-level summary table created from activity records.

---

#### 5. engagement_summary

Primary key:

- User_ID

Foreign key:

- User_ID references user_profile.User_ID

Columns:

- User_ID VARCHAR
- Total_Sessions INT
- Avg_Session_Duration DECIMAL
- Total_Session_Time INT
- Completion_Rate DECIMAL
- Notification_Click_Rate DECIMAL
- Purchase_Rate DECIMAL

Description:

This is a user-level summary table created from app engagement records.

---

#### 6. final_user_summary

Primary key:

- User_ID

Foreign key:

- User_ID references user_profile.User_ID

Columns:

- User_ID VARCHAR
- Gender VARCHAR
- Age_Group VARCHAR
- Region VARCHAR
- Subscription_Type VARCHAR
- App_Join_Date DATE
- Goal_Type VARCHAR
- Preferred_Workout_Type VARCHAR
- Age_Group_Number INT
- Paid_User_Flag INT
- Total_Workouts INT
- Total_Calories INT
- Avg_Calories DECIMAL
- Avg_Duration DECIMAL
- Total_Steps INT
- Total_Sessions INT
- Avg_Session_Duration DECIMAL
- Total_Session_Time INT
- Completion_Rate DECIMAL
- Notification_Click_Rate DECIMAL
- Purchase_Rate DECIMAL

Description:

This is the final user-level analytical table used for reporting and machine learning.

---

### Relationships

Create the following relationships:

1. user_profile.User_ID one-to-many activity.User_ID
2. user_profile.User_ID one-to-many app_engagement.User_ID
3. user_profile.User_ID one-to-one activity_summary.User_ID
4. user_profile.User_ID one-to-one engagement_summary.User_ID
5. user_profile.User_ID one-to-one final_user_summary.User_ID

### Diagram Requirements

- Put `user_profile` at the center.
- Put `activity` and `app_engagement` on either side of `user_profile`.
- Put summary tables below the source tables.
- Clearly mark primary keys and foreign keys.
- Show cardinality labels:
  - One user to many activities
  - One user to many app sessions
  - One user to one summary row
- Use a clean professional style suitable for a capstone project presentation.

---

## Simple Story To Explain The ERD

The `user_profile` table is the main user table.

Each user can perform many workouts, so `activity` has many rows for one user.

Each user can also have many app sessions, so `app_engagement` has many rows for one user.

The summary tables aggregate activity and engagement data at the user level.

The `final_user_summary` table combines profile, activity, and engagement summaries so it can be used for dashboards, SQL reporting, and machine learning.

/*
FitTech Capstone Database Schema

Purpose:
Create a clean relational database structure for the fitness app project.

Main relationship:
One user can have many workout activity records.
One user can have many app engagement session records.
*/

-- Optional database creation.
-- Use this only if your SQL server supports it and you want a new database.
-- CREATE DATABASE fittech_capstone;
-- USE fittech_capstone;

-- Stores one row per app user.
CREATE DATABASE fittech_capstone;
USE fittech_capstone;
CREATE TABLE user_profile (
    User_ID VARCHAR(20) PRIMARY KEY,
    Gender VARCHAR(20),
    Age_Group VARCHAR(20),
    Region VARCHAR(100),
    Subscription_Type VARCHAR(50),
    App_Join_Date DATE,
    Goal_Type VARCHAR(100),
    Preferred_Workout_Type VARCHAR(100),
    Engagement_Level DECIMAL(10, 2)
);

-- Stores workout activity logs.
-- Each activity belongs to one user.
CREATE TABLE activity (
    Activity_ID VARCHAR(30) PRIMARY KEY,
    User_ID VARCHAR(20) NOT NULL,
    Activity_Date DATE,
    Workout_Type VARCHAR(100),
    Duration_Minutes INT,
    Calories_Burned INT,
    Steps_Count INT,
    Heart_Rate_Avg INT,
    Workout_Time_of_Day VARCHAR(50),
    Device_Used VARCHAR(100),
    FOREIGN KEY (User_ID) REFERENCES user_profile(User_ID)
);

-- Stores app engagement sessions.
-- Each app session belongs to one user.
CREATE TABLE app_engagement (
    Session_ID VARCHAR(30) PRIMARY KEY,
    User_ID VARCHAR(20) NOT NULL,
    Session_Date DATE,
    Feature_Used VARCHAR(100),
    Session_Duration_Minutes INT,
    In_App_Purchase VARCHAR(10),
    Notification_Clicked VARCHAR(10),
    Workout_Completed VARCHAR(10),
    User_Rating INT,
    FOREIGN KEY (User_ID) REFERENCES user_profile(User_ID)
);

-- Optional user-level activity summary table.
-- This table can be refreshed from activity data for reporting.
CREATE TABLE activity_summary (
    User_ID VARCHAR(20) PRIMARY KEY,
    Total_Workouts INT,
    Total_Calories INT,
    Avg_Calories DECIMAL(10, 2),
    Avg_Duration DECIMAL(10, 2),
    Total_Steps INT,
    FOREIGN KEY (User_ID) REFERENCES user_profile(User_ID)
);

-- Optional user-level engagement summary table.
-- This table can be refreshed from app engagement data for reporting.
CREATE TABLE engagement_summary (
    User_ID VARCHAR(20) PRIMARY KEY,
    Total_Sessions INT,
    Avg_Session_Duration DECIMAL(10, 2),
    Total_Session_Time INT,
    Completion_Rate DECIMAL(10, 4),
    Notification_Click_Rate DECIMAL(10, 4),
    Purchase_Rate DECIMAL(10, 4),
    FOREIGN KEY (User_ID) REFERENCES user_profile(User_ID)
);

-- Final merged user-level summary table for analysis, dashboarding, and ML.
CREATE TABLE final_user_summary (
    User_ID VARCHAR(20) PRIMARY KEY,
    Gender VARCHAR(20),
    Age_Group VARCHAR(20),
    Region VARCHAR(100),
    Subscription_Type VARCHAR(50),
    App_Join_Date DATE,
    Goal_Type VARCHAR(100),
    Preferred_Workout_Type VARCHAR(100),
    Age_Group_Number INT,
    Paid_User_Flag INT,
    Total_Workouts INT,
    Total_Calories INT,
    Avg_Calories DECIMAL(10, 2),
    Avg_Duration DECIMAL(10, 2),
    Total_Steps INT,
    Total_Sessions INT,
    Avg_Session_Duration DECIMAL(10, 2),
    Total_Session_Time INT,
    Completion_Rate DECIMAL(10, 4),
    Notification_Click_Rate DECIMAL(10, 4),
    Purchase_Rate DECIMAL(10, 4),
    FOREIGN KEY (User_ID) REFERENCES user_profile(User_ID)
);

-- Indexes help speed up joins and business queries.
CREATE INDEX idx_activity_user_id ON activity(User_ID);
CREATE INDEX idx_app_engagement_user_id ON app_engagement(User_ID);
CREATE INDEX idx_activity_workout_type ON activity(Workout_Type);
CREATE INDEX idx_app_engagement_feature ON app_engagement(Feature_Used);
CREATE INDEX idx_final_subscription_type ON final_user_summary(Subscription_Type);
CREATE INDEX idx_final_region ON final_user_summary(Region);

/*
FitTech Business SQL Automations

These are written as views so they can be refreshed automatically when the
underlying tables are updated.

Use case:
The business team can query these views instead of rewriting the same SQL again.
*/

-- Run in the context of the fittech database (fittech_mysql.sql creates it).
-- FIX: added explicit USE so this file also works if run standalone,
-- without a schema already selected in the Workbench session.
USE fittech;


-- View 1:
-- Creates a subscription-level performance view.
-- Business use: Compare Free, Trial, and Premium users.
DROP VIEW IF EXISTS vw_subscription_performance;

CREATE VIEW vw_subscription_performance AS
SELECT
    Subscription_Type,
    COUNT(User_ID) AS Total_Users,
    ROUND(AVG(Total_Workouts), 2) AS Avg_Workouts_Per_User,
    ROUND(AVG(Total_Calories), 2) AS Avg_Calories_Per_User,
    ROUND(AVG(Total_Session_Time), 2) AS Avg_Session_Time_Per_User,
    ROUND(AVG(Completion_Rate) * 100, 2) AS Completion_Percentage,
    ROUND(AVG(Notification_Click_Rate) * 100, 2) AS Notification_Click_Percentage,
    ROUND(AVG(Purchase_Rate) * 100, 2) AS Purchase_Percentage
-- FIX: table was `final_user_summary`, which doesn't exist in the fittech
-- database. The per-user aggregate table is actually `user_features`
-- (see fittech_mysql.sql) — it has Subscription_Type, Total_Workouts,
-- Total_Calories, Total_Session_Time, Completion_Rate,
-- Notification_Click_Rate and Purchase_Rate, so it's the correct source.
FROM user_features
GROUP BY Subscription_Type;


-- Trigger 1:
-- Automatically updates the activity summary whenever a new workout is added.
-- Business use: Keeps workout summary metrics updated without manual refresh.

-- FIX: `activity_summary` was never created anywhere in this file, so the
-- trigger below would fail with "Table 'fittech.activity_summary' doesn't
-- exist" on the very first INSERT into `activity`. Also, ON DUPLICATE KEY
-- UPDATE requires a UNIQUE/PRIMARY KEY on User_ID to know when to update
-- vs. insert — added that here.
CREATE TABLE IF NOT EXISTS activity_summary (
    User_ID        VARCHAR(10) PRIMARY KEY,
    Total_Workouts INT            NOT NULL DEFAULT 0,
    Total_Calories INT            NOT NULL DEFAULT 0,
    Avg_Calories   DECIMAL(10,2)  NOT NULL DEFAULT 0,
    Avg_Duration   DECIMAL(10,2)  NOT NULL DEFAULT 0,
    Total_Steps    INT            NOT NULL DEFAULT 0,
    CONSTRAINT fk_activity_summary_user FOREIGN KEY (User_ID) REFERENCES users(User_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TRIGGER IF EXISTS trg_update_activity_summary;

DELIMITER $$

CREATE TRIGGER trg_update_activity_summary
AFTER INSERT ON activity
FOR EACH ROW
BEGIN

    INSERT INTO activity_summary (
        User_ID,
        Total_Workouts,
        Total_Calories,
        Avg_Calories,
        Avg_Duration,
        Total_Steps
    )
    VALUES (
        NEW.User_ID,
        1,
        NEW.Calories_Burned,
        NEW.Calories_Burned,
        NEW.Duration_Minutes,
        NEW.Steps_Count
    )

    ON DUPLICATE KEY UPDATE

        Total_Workouts = Total_Workouts + 1,

        Total_Calories = Total_Calories + NEW.Calories_Burned,

        Avg_Calories =
            (Total_Calories + NEW.Calories_Burned) /
            (Total_Workouts + 1),

        Avg_Duration =
            ((Avg_Duration * Total_Workouts) + NEW.Duration_Minutes) /
            (Total_Workouts + 1),

        Total_Steps = Total_Steps + NEW.Steps_Count;

END$$

DELIMITER ;


-- Stored Procedure 1:
-- Generates subscription performance report.
-- Business use: Allows managers to retrieve subscription insights using one command.

DROP PROCEDURE IF EXISTS sp_subscription_performance_report;

DELIMITER $$

CREATE PROCEDURE sp_subscription_performance_report()

BEGIN

SELECT
    Subscription_Type,
    COUNT(User_ID) AS Total_Users,
    ROUND(AVG(Total_Workouts),2) AS Avg_Workouts,
    ROUND(AVG(Total_Calories),2) AS Avg_Calories,
    ROUND(AVG(Total_Session_Time),2) AS Avg_Session_Time,
    ROUND(AVG(Completion_Rate) * 100,2) AS Completion_Percentage,
    ROUND(AVG(Notification_Click_Rate) * 100,2) AS Notification_Click_Percentage,
    ROUND(AVG(Purchase_Rate) * 100,2) AS Purchase_Percentage
-- FIX: same `final_user_summary` -> `user_features` table name correction as the view above.
FROM user_features
GROUP BY Subscription_Type
ORDER BY Avg_Calories DESC;

END$$

DELIMITER ;

-- Execute using:
-- CALL sp_subscription_performance_report();



-- Scheduler 1:
-- Refreshes the engagement summary table automatically every day.
-- Business use: Keeps reporting tables synchronized with the latest engagement data.

-- FIX: `engagement_summary` was never created anywhere in this file, so the
-- TRUNCATE TABLE in the event below would fail with "Table doesn't exist"
-- the first time it runs. Added the missing table, keyed on User_ID.
CREATE TABLE IF NOT EXISTS engagement_summary (
    User_ID                  VARCHAR(10) PRIMARY KEY,
    Total_Sessions           INT            NOT NULL DEFAULT 0,
    Avg_Session_Duration     DECIMAL(10,2)  NOT NULL DEFAULT 0,
    Total_Session_Time       INT            NOT NULL DEFAULT 0,
    Completion_Rate          DECIMAL(10,4)  NOT NULL DEFAULT 0,
    Notification_Click_Rate  DECIMAL(10,4)  NOT NULL DEFAULT 0,
    Purchase_Rate            DECIMAL(10,4)  NOT NULL DEFAULT 0,
    CONSTRAINT fk_engagement_summary_user FOREIGN KEY (User_ID) REFERENCES users(User_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- NOTE: SET GLOBAL requires SUPER / SYSTEM_VARIABLES_ADMIN privilege and
-- won't apply on managed/cloud MySQL instances that restrict global
-- variables. On a local install (which is what fittech_mysql.sql targets)
-- this is fine to run as-is.
SET GLOBAL event_scheduler = ON;

DROP EVENT IF EXISTS ev_refresh_engagement_summary;

DELIMITER $$

CREATE EVENT ev_refresh_engagement_summary

ON SCHEDULE EVERY 1 DAY

STARTS CURRENT_TIMESTAMP

DO

BEGIN

    TRUNCATE TABLE engagement_summary;

    INSERT INTO engagement_summary
    (
        User_ID,
        Total_Sessions,
        Avg_Session_Duration,
        Total_Session_Time,
        Completion_Rate,
        Notification_Click_Rate,
        Purchase_Rate
    )

    SELECT

        User_ID,

        COUNT(Session_ID),

        ROUND(AVG(Session_Duration_Minutes),2),

        SUM(Session_Duration_Minutes),

        AVG(
            CASE
                WHEN Workout_Completed = 'Yes'
                THEN 1
                ELSE 0
            END
        ),

        AVG(
            CASE
                WHEN Notification_Clicked = 'Yes'
                THEN 1
                ELSE 0
            END
        ),

        AVG(
            CASE
                WHEN In_App_Purchase = 'Yes'
                THEN 1
                ELSE 0
            END
        )

    -- FIX: table was `app_engagement`, which doesn't exist in the fittech
    -- database. The actual session-level table is `engagement`
    -- (see fittech_mysql.sql).
    FROM engagement

    GROUP BY User_ID;

END$$

DELIMITER ;

-- View the refreshed summary:
-- SELECT * FROM engagement_summary;

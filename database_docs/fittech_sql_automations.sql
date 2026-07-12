/*
FitTech Business SQL Automations

These are written as views so they can be refreshed automatically when the
underlying tables are updated.

Use case:
The business team can query these views instead of rewriting the same SQL again.
*/

-- Automation 0:
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
FROM final_user_summary
GROUP BY Subscription_Type;


-- Trigger 1:
-- Automatically updates the activity summary whenever a new workout is added.
-- Business use: Keeps workout summary metrics updated without manual refresh.

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
FROM final_user_summary
GROUP BY Subscription_Type
ORDER BY Avg_Calories DESC;

END$$

DELIMITER ;

-- Execute using:
-- CALL sp_subscription_performance_report();



-- Scheduler 1:
-- Refreshes the engagement summary table automatically every day.
-- Business use: Keeps reporting tables synchronized with the latest engagement data.

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

    FROM app_engagement

    GROUP BY User_ID;

END$$

DELIMITER ;

-- View the refreshed summary:
-- SELECT * FROM engagement_summary;
# Project Topic 02

# Case Study: Assess Fitness App Usage & Calorie Burn Patterns to Drive Personalised Engagement (FitTech)

##  Case Description
This dataset supports a case study on fitness app usage and personalized engagement analytics, exploring how user activity, workout patterns, and app feature interactions drive retention and personalization strategies.

## Dataset Overview
1. User_Profile (600 records) - Contains demographic and subscription details for each user. 

Columns:
- User_ID – Unique identifier (e.g., U1001)
- Gender – Male / Female / Other
- Age_Group – Age bracket (18–25, 26–35, 36–45, 46+)
- Region – City (Mumbai, Delhi NCR, Bangalore, Kolkata, Hyderabad, Pune, Chennai)
- Subscription_Type – Free / Premium / Trial
- App_Join_Date – Date user joined the app
- Goal_Type – Fitness goal (Weight Loss, Fitness, Strength, General)
- Preferred_Workout_Type – Cardio / Yoga / Strength / Mix


2. Activity (99,667 records) - Logs workout sessions with duration, calories, and physiological data. 

Columns:
- Activity_ID – Unique identifier (e.g., A000001)
- User_ID – Linked to User_Profile
- Date – Workout date
- Workout_Type – Cardio / Yoga / Strength / Mix
- Duration_Minutes – Workout duration (20–100 minutes)
- Calories_Burned – Estimated calories burned
- Steps_Count – Steps recorded (0 for Yoga/Strength)
- Heart_Rate_Avg – Average heart rate during session
- Workout_Time_of_Day – Morning / Afternoon / Evening
- Device_Used – Mobile / Smartwatch / Web


3. App_Engagement (200,000 records) - Captures user interactions with app features and engagement behavior. 

Columns:
- Session_ID – Unique identifier (e.g., S000001)
- User_ID – Linked to User_Profile
- Session_Date – Date of app session
- Feature_Used – Workout Tracker / Diet Log / Community / Progress
- Session_Duration_Minutes – Time spent in app (5–30 minutes)
- In_App_Purchase – Yes / No
- Notification_Clicked – Yes / No
- Workout_Completed – Yes / No (linked to Activity table)
- User_Rating – Feedback score (1–5, avg ≈ 4.5)


## Analytical Potential
- This dataset enables exploration of:
- Workout efficiency and calorie burn patterns
- Subscription type differences in retention and engagement
- Feature usage trends and their impact on loyalty
- Time-of-day participation analysis
- Derived KPIs such as Consistency Score, Engagement Score, Dropout Frequency, and Regional Volatility

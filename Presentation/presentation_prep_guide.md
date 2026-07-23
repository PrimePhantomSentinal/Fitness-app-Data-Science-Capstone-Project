# FitTech Presentation — Prep Guide

This is your rehearsal companion for `Presentation/fittech_app_analytics.html` (18 slides) and `FitTech_Capstone_Presentation.pptx` (17 slides — one slide behind the HTML; see note below). Every number below was re-verified directly against the source data and the trained models in this session — not copied from an older draft — so it's safe to say any of these out loud with confidence.

**Two rounds of updates behind these numbers:**
1. The source `User_Engagement_Level` column turned out to be real (not the constant placeholder it was earlier) — Low/Medium/High, 200 users each, genuinely correlated with behavior. It's now the classification target (replacing the old median-split `High_Engagement_Flag`), with a slide presenting that discovery and the ML Classification/Drivers slides rebuilt around it.
2. Linear Regression and K-Means Clustering results were added as their own slides with real charts (scatter of actual-vs-predicted session time, and the real 2-cluster segmentation). Adding these caused a side-effect worth knowing: the classification/regression train-test split is now stratified on the *new* 3-class target instead of the old binary one, which shifted the regression split too — so the regression metrics changed again (now MAE≈298, not the ≈261 you may recall from earlier). This is normal — a different valid split, not an error — but say the current number, not an older one from memory.

**HTML vs PPTX slide count:** the HTML has one extra slide (18 vs 17) — the "A Real, Validated Engagement Signal" discovery slide only exists in the HTML. Everything else, including the new Linear Regression and K-Means Clustering slides, is in both.

**Latest pass:** fonts were increased throughout the HTML deck (~12% larger across the board) for better readability from the back of a room — every slide was re-checked visually for overflow, and one (SQL Automations) needed tighter spacing to fit, now fixed. The hypothesis-testing t-test now explicitly shows its sample sizes (n = 73,024 vs 126,976 — both far above the n≥30 a t-test needs) in both the HTML and PPTX. **Font sizes were not touched in the PPTX** — there's no way to visually verify PPTX text for overflow the way the HTML was checked (no PowerPoint/LibreOffice available), so that was left as-is rather than risk clipped text you wouldn't see until presenting. If you want larger fonts in the PPTX too, do it directly in PowerPoint where you can see the result live.

**Note on other docs in this folder:** `presentation_client_and_beginner_guide.md` and `presentation_numbers_calculation_notes.md` were written for an earlier version of the deck (old slide 12 description, K-Means references that no longer apply here) and are now out of sync in a few places. Use *this* file as the current source of truth for the live deck; treat the other two as background reading only.

---

## 1. Before You Present — Operational Checklist

- **Internet connection required.** The deck loads Google Fonts, Font Awesome, and Chart.js from CDNs (`fonts.googleapis.com`, `cdnjs.cloudflare.com`, `cdn.jsdelivr.net`). Without internet, fonts fall back to defaults and **all charts will fail to render** (blank canvases on slides 5, 6, 7, 10, 13, 14, 15). Test on the actual presentation Wi-Fi beforehand, or open it once beforehand so the browser caches the assets.
- **Navigation:** scroll (mouse wheel / trackpad) or arrow keys / spacebar move forward; arrow-up/left moves back. There's no visible "next" button — practice this so it's muscle memory.
- **First-visit chart rendering:** charts on slides 5, 6, 7, 10, 13, 14, and 15 only render the *first time* you arrive at that slide (lazy-loaded for performance). If you jump around out of order while rehearsing, don't panic if a chart looks empty on a slide you've already passed — it rendered once and stays rendered.
- **Timing:** 18 slides. At roughly 45–60 seconds each, that's about 14–18 minutes, leaving room for Q&A. Slides 8 (hypothesis testing) and 12 (model comparison) are hover/flip-card driven — budget extra time to actually flip each card during the real thing, don't just describe them from memory.

---

## 2. Opening Pitch (30 seconds)

> "FitTech has strong baseline usage — three in four users complete their workouts — but the business doesn't yet know what actually drives a user from casually working out to becoming a highly engaged, paying customer. This project uses their full activity and engagement data to answer that: which users are likely to become high-engagement, what predicts it, and what should the business do differently as a result."

---

## 3. Slide-by-Slide Speaker Notes

**Slide 1 — Title**
State your name, batch (DA68), mentor (Priya Shanmugam), and read the problem statement once, plainly: FitTech needs to understand what drives engagement, notification response, and purchases.

**Slide 2 — Scope & Dataset Overview**
600 users, ~100K workout records, 200K engagement sessions, joined on `User_ID`. Anchor numbers: 75% completion rate, 13.8% purchase rate — say these two out loud, they reappear all through the deck.

**Slide 3 — Project Objectives**
Four objectives: understand the user, evaluate engagement, predict behavior, drive strategy. Frame it as "each later slide maps back to one of these four."

**Slide 4 — Engagement Funnel Drop-off**
Read the funnel top to bottom: Total Sessions (100%) → Workout Completed (75.0%) → Notification Clicked (36.5%) → Purchase Made (13.8%). The story: the app itself works fine (75% completion), the drop happens *after* — in getting users to respond to notifications and convert. That reframes the whole project: this isn't a "fix the app" problem, it's an "improve engagement/marketing" problem.

**Slide 5 — User Profile Analysis**
Region chart: Mumbai has the most users (108, 18%), but **Chennai converts the highest share to Premium (51.3%)**, Bangalore close behind (46.5%) — volume and conversion quality are two different things, worth calling out explicitly. Age bubble chart: the 26–35 group is both the largest bubble and near-identical in behavior to other age groups (completion ~75%, session duration ~17.8 min across all ages) — age doesn't meaningfully change behavior here, which is itself a finding.

**Slide 6 — Workout & Activity Patterns**
Cardio burns the most calories (~540 kcal avg, 9.0 cal/min — nearly double Yoga's 4.0 cal/min). Morning is the dominant workout time (45.1%) across all workout types.

**Slide 7 — App Engagement Analytics**
Trend chart now has three lines: Total Sessions (declining sharply, 70K→10K), Avg Session Duration (flat, ~17.8-17.9 min), and **Completion Rate (new, also flat — 74.9% to 75.6%, never dipping below 75% except one year)**. Say this explicitly: two independent quality metrics both held steady while volume fell — that's strong evidence this is a retention problem (losing users), not an engagement-quality problem (remaining users are fine). Second chart: Workout Tracker is the dominant feature (39.8% of sessions), Progress next (25.1%). Together, 65% of all engagement.

**Slide 8 — Statistical Hypothesis Testing**
Flip each card live. Lead with the business conclusion (front), flip to show the actual test:
- Workout type **does** significantly change calorie burn (ANOVA, p < 0.05) — expected, but now statistically proven.
- Notification clicks and workout completion are **not** significantly related (Chi-square, p = 0.34) — clicking a notification doesn't predict finishing a workout.
- Notification clicks do **not** significantly change session duration either (Welch's t-test, p = 0.22, 17.84 vs 17.82 minutes, n = 73,024 clicked vs 126,976 not-clicked — both groups enormously larger than the n≥30 needed for the test to be valid) — this is the most important one to narrate well: it means the *current* notification content isn't moving behavior, which sets up the "message quality matters more than click volume" recommendation later.

**Slide 9 — SQL Database Automations**
This is architecture, not analysis — views, a trigger, a stored procedure, an event scheduler. Say once, clearly: this turns the project from "a one-time analysis" into "a live reporting system the business can keep using."

**Slide 10 — A Real, Validated Engagement Signal** *(new)*
This slide exists because of a real data-quality story worth telling if asked: the source `User_Engagement_Level` column was originally constant (every user "Medium") — useless. It's since been corrected upstream and now holds a genuine, perfectly balanced label (200 Low / 200 Medium / 200 High). Before trusting it, it was validated against real behavior: High-tier users average 178 workouts and 359 sessions vs. 155 and 306 for Low-tier — a clean, monotonic step up, and it correlates at r≈0.73 with workout frequency. This validated label is what becomes the classification target next, not an invented threshold.

**Slide 11 — Predictive Modeling (ML) Approach**
Two goals: classification (which real engagement tier a user falls into) and regression (how much session time to expect). Target: the real `User_Engagement_Level` (Low/Medium/High) from slide 10 — not an artificial split. Pipeline: 80/20 split, StandardScaler, OneHotEncoder across Gender, Region, Subscription, Goal, and Workout Type.

**Slide 12 — ML Classification Models Evaluated**
Flip each card. This is now a genuine 3-class problem, so 33% is the random-guess baseline — anything meaningfully above that is a real signal. Logistic Regression (67.5% accuracy) is the business-recommended model — it's virtually tied with Decision Tree (68.3%, the highest), so the choice comes down entirely to explainability, not a performance trade-off like before. KNN is weakest (43.3%, and the only one of the three that ever confuses Low with High directly). Know this detail: **neither Logistic Regression nor Decision Tree ever confuses a Low-engagement user for a High-engagement one** — a strong point if asked how reliable the model is.

**Slide 13 — ML Drivers: What Impacts Engagement?**
Know this one cold. Looking at what drives the **High** tier specifically: **workout frequency dominates** (coefficient ≈ 3.09) — more than 2x the next driver, Completion Rate (≈1.36). Notification Click Rate also pushes toward High (≈0.92). Purchase Rate carries almost no weight (≈ -0.28) — buying behavior and being genuinely engaged are largely independent in this data. This is a cleaner, more intuitive story than the old binary-target version: completion and notifications now *do* matter, purchases mostly don't.

**Slide 14 — Linear Regression: Predicting Session Time** *(new)*
Switch from classification to regression here: same inputs, but now predicting an actual number — Total Session Time — instead of a tier. Metrics: **MAE ≈ 298 min, RMSE ≈ 361 min, R² ≈ 0.55**. Point at the scatter chart: the diagonal dashed line is "perfect prediction," and the real points cluster fairly tightly around it with some natural spread — a solid first-pass baseline, explicitly not pitched as production-grade. If asked why this number differs from an R²≈0.61 you might have seen earlier: the train/test split is now stratified on the new 3-class engagement target rather than the old binary one, which changed which users land in the test set — a different valid split, not an error.

**Slide 15 — K-Means Clustering: Two Real User Segments** *(new)*
This is unsupervised learning — no target, just grouping users by behavior. Features: Completion Rate, Purchase Rate, Notification Click Rate. **k=2 was chosen because it wins decisively** on silhouette (0.59 vs 0.43 at k=3), Davies-Bouldin, and Calinski-Harabasz scores — not picked for simplicity. The punchline: Completion Rate is nearly identical between the two clusters (0.75 both) — **Purchase Rate is what actually separates them**, mirroring Subscription Type almost exactly: 249 Premium users at 25% purchase rate vs. 351 Free users at just 6%. Have the honest caveat ready if asked: this clustering does **not** line up with the real `Engagement_Level` label from slide 10 — that's driven by workout frequency, not purchases, so the two segmentations answer genuinely different business questions ("who buys" vs. "who's active").

**Slide 16 — Summary of Findings & Interpretations**
This is a recap slide — six bullets pulling together workout preferences, timing, feature utility, the funnel bottleneck, the statistical reality (notifications don't extend sessions), and the modeling direction. Read it as a summary, don't introduce new numbers here.

**Slide 17 — Strategic Recommendations**
Six recommendations, each backed by a number already said earlier in the deck (feature usage, completion rates by feature, calories/minute by workout type, device share). If asked "why these six," the honest answer: each ties directly back to Objectives 3 and 4 (predict behavior, drive strategy) rather than being a generic best-practice list.

**Slide 18 — Q&A**
Just the closing slide. Transition into open questions.

**PPTX numbering note:** the offline deck doesn't have slide 10 (the engagement-signal discovery slide), so every slide from there onward is numbered one lower in the PPTX than in this list (e.g. this guide's slide 15 "K-Means Clustering" is the PPTX's slide 14). The footer in the bottom-left of each PPTX slide always shows its correct number out of 17 — trust that over this guide's numbering if presenting from the PPTX.

---

## 4. Anticipated Questions & Strong Answers

**"Why trust `User_Engagement_Level` as the target instead of building your own threshold?"**
Because it's now a real, independently-validated business label, not an artificial split. It was checked against actual behavior before being used — High-tier users genuinely average more workouts, more sessions, and higher completion than Low-tier — so predicting it is a more authentic business problem than predicting a median-based proxy.

**"Decision Tree has slightly higher accuracy (68.3% vs 67.5%) — why not just present that as the winner?"**
The gap is under 1 percentage point now — essentially tied — so accuracy isn't a deciding factor either way. Logistic Regression's per-class coefficients let you say precisely *which behaviors* push a user toward each tier and by how much, which is what lets the business actually act on the model. A decision tree's split rules are harder for non-technical stakeholders to generalize from, and with only 600 users, a single tree is more prone to instability than a linear model.

**"Total_Workouts dominates the model so heavily — isn't that a bit circular?"**
Not really, and this is actually a stronger result than before: `User_Engagement_Level` is an independent business label, not derived from `Total_Workouts` directly, so this coefficient is a genuine finding, not a tautology. And unlike the old model (where Completion Rate and Purchase Rate went slightly negative), here **Completion Rate and Notification Click Rate both push meaningfully toward High engagement** — only Purchase Rate is disconnected from it. That's a cleaner, more actionable story: engagement and monetization are separate levers.

**"You said earlier that Purchase Rate and Completion Rate were both negatively related to engagement — now Completion Rate is strongly positive. Which is it?"**
Both are correct — they answer different questions. The earlier (now-replaced) analysis predicted *session-time-based* high engagement; this one predicts the *real business-assigned* tier. Against the real label, Completion Rate and Notification Click Rate are genuinely positive drivers of the High tier; only Purchase Rate stays weak. This is exactly why the real label was worth switching to — it produces a more intuitive, defensible story.

**"Why did you drop clustering from the main analysis?"** *(only if asked — it's not in this deck's flow)*
K-Means user segmentation was explored separately (in a standalone clustering notebook) rather than folded into the main classification/regression story, to keep each notebook focused on one kind of question — supervised prediction vs. unsupervised segmentation are genuinely different analyses with different validation approaches.

**"Is there anything wrong with the data?"** *(a great one to have a strong, honest answer for)*
There was, and it's worth mentioning proactively if the conversation allows — the source `User_Profile` data originally had an `Engagement_Level` column that was identical (`"Medium"`) for all 600 users, carrying zero real signal. Rather than trust it blindly, a derived engagement score was built from actual behavior instead, and the source column was checked again once corrected upstream — it now holds a genuine, validated Low/Medium/High label, which is what the models use today. The takeaway for the mentor: always verify a column's real value distribution before trusting it, even after it's "fixed."

**"How confident are you in the regression model (predicting session time)?"**
MAE ≈ 298 minutes, RMSE ≈ 361 minutes, R² ≈ 0.55 — the model explains about 55% of the variation in total session time, with typical predictions off by roughly 298 minutes. Solid for a first-pass baseline model, not production-grade; framed honestly as a starting point rather than a final answer. There's a real scatter chart on slide 14 (actual vs. predicted with a diagonal reference line) if you want to show rather than just state this.

**"Why does the clustering slide show only 2 segments when there are 3 engagement tiers?"**
They're deliberately different analyses answering different questions. The engagement tiers (slide 10) measure overall activity, built from workout frequency; the clusters (slide 15) measure purchase propensity, built from completion/purchase/notification behavior. k=2 was the statistically correct choice for *that* feature set — it isn't meant to reproduce the 3-tier engagement split.

**"Why both SQLite and MySQL?"**
SQLite for lightweight, file-based practice and to show SQL fluency inside the notebook; MySQL to demonstrate the same schema running as a real database server, closer to how a company would actually deploy this.

---

## 5. One-Page Numbers Cheat Sheet

| Topic | Number |
|---|---|
| Users / Workouts / Sessions | 600 / ~100,000 / 200,000 |
| Completion rate | 75.0% |
| Notification click rate | 36.5% |
| Purchase rate | 13.8% |
| Most users by region | Mumbai, 108 users (18.0%) |
| Highest Premium conversion by region | Chennai, 51.3% (Bangalore 2nd, 46.5%) |
| Most common subscription | Free, 48.8% (Premium 41.5%, Trial 9.7%) |
| Largest age group | 26–35, 40.7% (244 users) |
| Highest-calorie workout | Cardio, ~540 kcal avg / 9.0 cal/min |
| Lowest-calorie workout | Yoga, 4.0 cal/min |
| Peak workout time | Morning, 45.1% |
| Top app feature | Workout Tracker, 39.8% (Progress 25.1%) |
| Device split | Mobile 33.5% / Web 33.4% / Smartwatch 33.2% |
| ANOVA — workout type vs calories | F = 15,699.11, p < 0.001 → significant |
| Chi-square — notification click vs completion | χ² = 0.91, p = 0.34 → not significant |
| T-test — notification click vs session duration | T = 1.22, p = 0.22 → not significant (17.84 vs 17.82 min, n = 73,024 vs 126,976) |
| Classification target | User_Engagement_Level — real Low/Medium/High label, 200 users each |
| Real label correlation with behavior | r ≈ 0.73 with Total_Workouts, 0.71 with Total_Sessions |
| Logistic Regression | 67.5% accuracy (vs. 33% random baseline; business winner) |
| KNN | 43.3% accuracy (weakest; only model that confuses Low with High) |
| Decision Tree | 68.3% accuracy (highest, but <1pt ahead of Logistic Regression) |
| Top ML driver (for 'High' tier) | Total_Workouts (coef ≈ 3.09), then Completion Rate (≈1.36), Notification Clicks (≈0.92); Purchase Rate ≈ -0.28 (negligible) |
| Linear Regression (session time) | MAE ≈ 298 min, RMSE ≈ 361 min, R² ≈ 0.55 |
| K-Means clusters (k=2, validated) | Cluster 0: 249 users, Premium, 25% purchase rate; Cluster 1: 351 users, Free, 6% purchase rate (Completion Rate ≈ 0.75 in both) |

---

## 6. Closing Line

> "In short: the app already works — completion is strong. What actually separates a Low-engagement user from a High-engagement one isn't purchases, it's workout frequency, completion, and responding to notifications. That's where I'd focus retention efforts next — and purchases should be treated as a separate lever, not assumed to follow from engagement."

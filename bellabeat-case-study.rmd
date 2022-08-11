> install.packages("reshape2")
Installing package into ‘C:/Users/Rahul kiroriwal/AppData/Local/R/win-library/4.2’
(as ‘lib’ is unspecified)
also installing the dependencies ‘plyr’, ‘Rcpp’

trying URL 'https://mirror.niser.ac.in/cran/bin/windows/contrib/4.2/plyr_1.8.7.zip'
Content type 'application/zip' length 1152346 bytes (1.1 MB)
downloaded 1.1 MB

trying URL 'https://mirror.niser.ac.in/cran/bin/windows/contrib/4.2/Rcpp_1.0.9.zip'
Content type 'application/zip' length 2842477 bytes (2.7 MB)
downloaded 2.7 MB

trying URL 'https://mirror.niser.ac.in/cran/bin/windows/contrib/4.2/reshape2_1.4.4.zip'
Content type 'application/zip' length 446799 bytes (436 KB)
downloaded 436 KB

package ‘plyr’ successfully unpacked and MD5 sums checked
package ‘Rcpp’ successfully unpacked and MD5 sums checked
package ‘reshape2’ successfully unpacked and MD5 sums checked

The downloaded binary packages are in
        C:\Users\Rahul kiroriwal\AppData\Local\Temp\RtmpmM8QSy\downloaded_packages
> install.packages("scales")
Warning: package ‘scales’ is in use and will not be installed
> library(tidyverse) 
> library(reshape2)

Attaching package: ‘reshape2’

The following object is masked from ‘package:tidyr’:

    smiths

> library(scales)
> dailyActivity_merged <- read.csv("dailyActivity_merged.csv")
> dailyCalories_merged <- read.csv("dailyCalories_merged.csv")
> dailyIntensities_merged <- read.csv("dailyIntensities_merged.csv")
> dailySteps_merged <- read.csv("dailySteps_merged.csv")
> sleepDay_merged <- read.csv("sleepDay_merged.csv")
> weightLogInfo_merged <- read.csv("weightLogInfo_merged.csv")
> merge_1 <- merge(dailyActivity_merged, dailyCalories_merged, by = c("Id","Calories"))
> merge_2 <- merge(dailyIntensities_merged, dailyIntensities_merged, by = c("Id","ActivityDay","SedentaryMinutes", "LightlyActiveMinutes","FairlyActiveMinutes","VeryActiveMinutes", "SedentaryActiveDistance", "LightActiveDistance", "ModeratelyActiveDistance", "VeryActiveDistance"))
> 
> merge_daily <- merge(merge_1, merge_2, by = c("Id","ActivityDay","SedentaryMinutes", "LightlyActiveMinutes","FairlyActiveMinutes","VeryActiveMinutes", "SedentaryActiveDistance", "LightActiveDistance", "ModeratelyActiveDistance", "VeryActiveDistance")) %>%
+ select(-ActivityDay) %>% rename(Date = ActivityDate)
> 
> daily_data <- merge(merge_daily, sleepDay_merged, by = "Id",all=TRUE) %>% drop_na() %>% select(-SleepDay, -TrackerDistance)
> 
> options(repr.plot.width=30)
> summary(daily_data)
       Id            SedentaryMinutes LightlyActiveMinutes FairlyActiveMinutes VeryActiveMinutes SedentaryActiveDistance LightActiveDistance ModeratelyActiveDistance VeryActiveDistance    Calories        Date             TotalSteps   
 Min.   :1.504e+09   Min.   :   0.0   Min.   :  0.0        Min.   :  0.00      Min.   :  0.00    Min.   :0.0000000       Min.   : 0.000      Min.   :0.0000           Min.   : 0.000     Min.   :   0   Length:15901       Min.   :    0  
 1st Qu.:4.020e+09   1st Qu.: 687.0   1st Qu.:  0.0        1st Qu.:  0.00      1st Qu.:  0.00    1st Qu.:0.0000000       1st Qu.: 0.000      1st Qu.:0.0000           1st Qu.: 0.000     1st Qu.:1693   Class :character   1st Qu.:    0  
 Median :4.703e+09   Median : 781.0   Median :171.0        Median :  3.00      Median :  0.00    Median :0.0000000       Median : 2.860      Median :0.1100           Median : 0.000     Median :2013   Mode  :character   Median : 6393  
 Mean   :5.117e+09   Mean   : 938.6   Mean   :156.4        Mean   : 13.58      Mean   : 18.76    Mean   :0.0005276       Mean   : 2.771      Mean   :0.5729           Mean   : 1.094     Mean   :2220                      Mean   : 6351  
 3rd Qu.:6.962e+09   3rd Qu.:1440.0   3rd Qu.:240.0        3rd Qu.: 19.00      3rd Qu.: 28.00    3rd Qu.:0.0000000       3rd Qu.: 4.480      3rd Qu.:0.7900           3rd Qu.: 1.740     3rd Qu.:2643                      3rd Qu.:10460  
 Max.   :8.792e+09   Max.   :1440.0   Max.   :518.0        Max.   :143.00      Max.   :210.00    Max.   :0.1100000       Max.   :10.300      Max.   :6.4800           Max.   :13.400     Max.   :4900                      Max.   :22988  
 TotalDistance    LoggedActivitiesDistance TotalSleepRecords TotalMinutesAsleep TotalTimeInBed 
 Min.   : 0.000   Min.   :0.00000          Min.   :1.000     Min.   : 58.0      Min.   : 61.0  
 1st Qu.: 0.000   1st Qu.:0.00000          1st Qu.:1.000     1st Qu.:360.0      1st Qu.:402.0  
 Median : 4.480   Median :0.00000          Median :1.000     Median :427.0      Median :459.0  
 Mean   : 4.487   Mean   :0.09649          Mean   :1.116     Mean   :417.3      Mean   :456.1  
 3rd Qu.: 7.390   3rd Qu.:0.00000          3rd Qu.:1.000     3rd Qu.:490.0      3rd Qu.:530.0  
 Max.   :17.950   Max.   :4.94214          Max.   :3.000     Max.   :796.0      Max.   :961.0  
> data_by_usertype <- daily_data %>%
+ summarise(
+ user_type = factor(case_when(
+     SedentaryMinutes > mean(SedentaryMinutes) & LightlyActiveMinutes < mean(LightlyActiveMinutes) & FairlyActiveMinutes < mean(FairlyActiveMinutes) & VeryActiveMinutes < mean(VeryActiveMinutes) ~ "Sedentary",
+     SedentaryMinutes < mean(SedentaryMinutes) & LightlyActiveMinutes > mean(LightlyActiveMinutes) & FairlyActiveMinutes < mean(FairlyActiveMinutes) & VeryActiveMinutes < mean(VeryActiveMinutes) ~ "Lightly Active",
+     SedentaryMinutes < mean(SedentaryMinutes) & LightlyActiveMinutes < mean(LightlyActiveMinutes) & FairlyActiveMinutes > mean(FairlyActiveMinutes) & VeryActiveMinutes < mean(VeryActiveMinutes) ~ "Fairly Active",
+     SedentaryMinutes < mean(SedentaryMinutes) & LightlyActiveMinutes < mean(LightlyActiveMinutes) & FairlyActiveMinutes < mean(FairlyActiveMinutes) & VeryActiveMinutes > mean(VeryActiveMinutes) ~ "Very Active",
+ ),levels=c("Sedentary", "Lightly Active", "Fairly Active", "Very Active")), Calories, .group=Id) %>%
+ drop_na()
> levels(user_type)
Error in levels(user_type) : object 'user_type' not found
> levels(data_by_usertype)
NULL

> data_by_usertype %>%
+ group_by(user_type) %>%
+ summarise(total = n()) %>%
+ mutate(totals = sum(total)) %>%
+ group_by(user_type) %>%
+ summarise(total_percent = total / totals) %>%
+ ggplot(aes(user_type,y=total_percent, fill=user_type)) +
+     geom_col()+
+     scale_y_continuous(labels = scales::percent) +
+     theme(legend.position="none") +
+     labs(title="User type distribution", x=NULL) 
![R 1](https://user-images.githubusercontent.com/97151154/184104793-9a2020f8-c963-488a-b787-4a100d33b8ee.PNG)


> ggplot(data_by_usertype, aes(user_type, Calories, fill=user_type)) +
+     geom_boxplot() +
+     theme(legend.position="none") +
+     labs(title="Calories burned by User type", x=NULL) +
+     theme(legend.position="none", text = element_text(size = 20),plot.title = element_text(hjust = 0.5))
 ![R2](https://user-images.githubusercontent.com/97151154/184104851-6f3cd176-5eba-45df-ac8e-c326d84936fd.PNG)

> daily_data %>%
+ summarise(
+ distance = factor(case_when(
+     TotalDistance < 4.5 ~ "< 4.5 mi",
+     TotalDistance >= 4.5 & TotalDistance <= 7 ~ "4.5 > & < 7 mi",
+     TotalDistance > 7 ~ "> 7 mi",
+ ),levels = c("> 7 mi","4.5 > & < 7 mi","< 4.5 mi")),
+ steps = factor(case_when(
+     TotalSteps < 6000 ~ "< 6k steps",
+     TotalSteps >= 6000 & TotalSteps <= 10000 ~ "6k > & < 10k Steps",
+     TotalSteps > 10000 ~ "> 10k Steps",
+ ),levels = c("> 10k Steps","6k > & < 10k Steps","< 6k steps")),
+ Calories) %>%
+ ggplot(aes(steps,Calories,fill=steps)) +
+     geom_boxplot() +
+     facet_wrap(~distance)+
+     labs(title="Calories burned by Steps and Distance",x=NULL) +
+     theme(legend.position="none", text = element_text(size = 20),plot.title = element_text(hjust = 0.5))

![R3](https://user-images.githubusercontent.com/97151154/184104912-e4c04e93-09d1-4ce9-9215-109642e0329d.PNG)

> sleepType_by_userType <- daily_data %>%
+ group_by(Id) %>%
+ summarise(
+ user_type = factor(case_when(
+     SedentaryMinutes > mean(SedentaryMinutes) & LightlyActiveMinutes < mean(LightlyActiveMinutes) & FairlyActiveMinutes < mean(FairlyActiveMinutes) & VeryActiveMinutes < mean(VeryActiveMinutes) ~ "Sedentary",
+     SedentaryMinutes < mean(SedentaryMinutes) & LightlyActiveMinutes > mean(LightlyActiveMinutes) & FairlyActiveMinutes < mean(FairlyActiveMinutes) & VeryActiveMinutes < mean(VeryActiveMinutes) ~ "Lightly Active",
+     SedentaryMinutes < mean(SedentaryMinutes) & LightlyActiveMinutes < mean(LightlyActiveMinutes) & FairlyActiveMinutes > mean(FairlyActiveMinutes) & VeryActiveMinutes < mean(VeryActiveMinutes) ~ "Fairly Active",
+     SedentaryMinutes < mean(SedentaryMinutes) & LightlyActiveMinutes < mean(LightlyActiveMinutes) & FairlyActiveMinutes < mean(FairlyActiveMinutes) & VeryActiveMinutes > mean(VeryActiveMinutes) ~ "Very Active",
+ ),levels=c("Sedentary", "Lightly Active", "Fairly Active", "Very Active")),
+ sleep_type = factor(case_when(
+     mean(TotalMinutesAsleep) < 360 ~ "Bad Sleep",
+     mean(TotalMinutesAsleep) > 360 & mean(TotalMinutesAsleep) <= 480 ~ "Normal Sleep",
+     mean(TotalMinutesAsleep) > 480 ~ "Over Sleep",
+ ),levels=c("Bad Sleep", "Normal Sleep", "Over Sleep")), total_sleep = sum(TotalMinutesAsleep) ,.groups="drop"
+ ) %>%
+ drop_na() %>%
+ group_by(user_type) %>%
+ summarise(bad_sleepers = sum(sleep_type == "Bad Sleep"), normal_sleepers = sum(sleep_type == "Normal Sleep"),over_sleepers = sum(sleep_type == "Over Sleep"),total=n(),.groups="drop") %>%
+ group_by(user_type) %>%
+ summarise(
+     bad_sleepers = bad_sleepers / total, 
+     normal_sleepers = normal_sleepers / total, 
+     over_sleepers = over_sleepers / total,
+     .groups="drop"
+ )
> sleepType_by_userType_melted<- melt(sleepType_by_userType, id.vars = "user_type")
> 
> ggplot(sleepType_by_userType_melted, aes(user_type, value, fill = variable)) +
+ geom_bar(position = "dodge", stat = "identity") +
+ scale_y_continuous(labels = scales::percent) +
+ labs(x=NULL, fill="Sleep type") + 
+ theme(legend.position="bottom",text = element_text(size = 20),plot.title = element_text(hjust = 0.5))
 
 ![R4](https://user-images.githubusercontent.com/97151154/184104988-4c6ddb51-e46d-4752-85f4-8e590a45f5e6.PNG)


After our analysis we have found the following trends that may assist with marketing of the Leaf:

1) There seems a clear relation between higher intensity activity and calories burned so logging the activity with the device could be a good motivator to increase activity for weight reduction.

2) The data also seems to show a clear trend of improved sleep quality linked to the activity level pointing to a general reduction in stress thereby improving quality of life.


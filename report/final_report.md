## Executive Sumamry
This report examines Cyclistic's bike-share data from December 2023 to 
November 2024 to uncover patterns in usage between casual riders and annual
members. Key findings reveal that casual riders primarily use bikes on weekends
and during the summer months for leisure, while annual members exhibit consistent
usgae throughout the week, likely for commuting purposes. The analysis provides
actionable recommendations for converting casual riders into annual members through
targeted marketing strategies.

## Background
Cyclistic is a bike-share company in Chicago, offering a wide range of bicycles and scooters for public use. The service includes flexible pricing plans catering to both casual riders and annual members. Casual riders purchase single-ride or full-day passes, while annual members subscribe to a membership plan. To increase profitability, Cyclistic aims to convert casual riders into annual members, as the latter group demonstrates higher usage and contributes more to long-term revenue. This analysis is conducted to identify key patterns in user behavior and inform marketing strategies.

## Objectives
1. Understand the difference in usage patterns between casual riders and annual
members.
2. Explore trends across days of the week, months, and bike types.
3. Provide insights to design marketing strategies to increase annual
memberships

## Data Description
The dataset includes historical bike trip records provided by Cyclistic. Key
features of the data include:
- Ride information: Start and end times, duration, and station names.
- Bike types: Classic bikes, electric bikes, and electric scooters.
- User types: Casual riders and annual members.

## Data Cleaning Steps
Combined monthly datasets into a single dataframe:
```R
trips_year <- rbind(Dec2023, Jan2024, Feb2024, March2024, April2024, May2024, 
                    June2024, July2024, Aug2024, Sep2024, Oct2024, Nov2024)
```
Added calculated columns for ride length, day of the week, date, month, and year:
```R
#Create Column For Ride Length
trips_year2$ride_length <- difftime(trips_year2$ended_at, trips_year2$started_at, units="mins")

#Create Column For Day of Week
trips_year2$day_of_week <- wday(trips_year2$started_at)

#Create Columns For Date, Month, Day, and Year of Each Ride
trips_year2$date <- as.Date(trips_year2$started_at)
trips_year2$month <- format(as.Date(trips_year2$date), "%m")
trips_year2$day <- format(as.Date(trips_year2$date), "%d")
trips_year2$year <- format(as.Date(trips_year2$date), "%y")
trips_year2$day_of_week <- format(as.Date(trips_year2$date), "%A")
```

Removed null values, duplicate rows, and rides with invalid durations:
```R
#Remove Duplicate Rows
trips_year2 <- distinct(trips_year2)

#Remove Null Values
trips_year2 <- na.omit(trips_year2)

#Remove Rows Where Ride Length <= 0
trips_year2 <- trips_year2[!(trips_year2$ride_length <= 0),]
```

## Analysis
### Total Rides
Key insights:
- The dataset contains a total of 5,898,151 rides across casual riders and annual members.
Summary Statistics for Ride Length:
```R
summary(trips_year2$ride_length)
```
- Minimum Ride Length: 0.0006 minutes
- 1st Quartile: 5.54 minutes
- Median: 9.70 minutes
- Mean: 15.48 minutes
- 3rd Quartile: 17.19 minutes
- Maximum Ride Length: 1,500.52 minutes

### 1. Usage by Bicycle Type
Key insights:
- Average Ride Length by Bike Type:
```R
#Ride Length By Bike Type
ride_bike_summary <- trips_year2 %>%
  group_by(rideable_type) %>%
  summarize(
    avg_ride_length = mean(ride_length, na.rm = TRUE),
    total_rides = n()
  )
```
- Electric bikes are the most used type, particularly by members.
- Classic bikes are also most often used by members.
- Casual riders tend to use electric scooters more often than members.

Visualization:
  ![Number of Trips by Bicycle Type](../visuals/num_trips_by_bike.png)

### 2. Daily Usage Patterns
Key insights:
- Members use bikes consistently throughout the week, with slightly higher usage on weekdays.
- Casual riders show a significant increase in usage on weekends.

Visualization:
![Total Rides by Day of the Week](../visuals/rides_by_day_of_week.png)

### 3. Monthly Trends
Key insights:
- Usage peaksduring summer months (June to August) for both casual riders and members.
- Casual riders show a steeper increase in summer usage, likely for leisure activities. 

Visualization:
![Number of Rides per Month](../visuals/rides_by_month.png)

### 4. Ride Duration
Key insights:
- Casual Riders have longer average ride durations to members, suggesting leisure trips.
- Members exhibit shorter, more consistent ride durations, indicative of commuting behavior.
Summary statistics for ride length by user type:
```R
#Ride Length By User Type
ride_user_summary <- trips_year2 %>%
  group_by(member_casual) %>%
  summarize(
    avg_ride_length = mean(ride_length, na.rm = TRUE),
    median_ride_length = median(ride_length, na.rm = TRUE),
    max_ride_length = max(ride_length, na.rm = TRUE),
    min_ride_length = min(ride_length, na.rm = TRUE),
    total_rides = n()
  )
```
Casual Riders
- Minimum Ride Length: 0.0008 minutes
- Median: 12.00 minutes
- Mean: 21.10 minutes
- Maximum Ride Length: 1,500.52 minutes 

Member Riders
- Minimum Ride Length: 0.0006 minutes
- Median: 8.69 minutes
- Mean: 12.23 minutes
- Maximum Ride Length: 1,499.93 minutes
  
## Recommendations
1. Target Weekend Promotions:
    - Launch weekend discounts or packages to attract casual riders.
2. Highlight Membership Benefits:
    - Create marketing campaigns emphasizing cost savings and convenience of annual memberships.
3. Seasonal Marketing:
    - Run targeted campaigns in peak summer months (June to August) to convert casual riders into members.
4. Optimize Bike Availability:
    - Ensure an adequate supply of electric bikes on weekdays for members

## Conclusion
The analysis underscores significant behavioral differences between casual
riders and annual members. Casual riders' preference for leisure trips
during weekends and summer months presents an opportunity for Cyclistic to
tailor marketing strategies and drive annual memberships. By targeting
promotions and improving bike availibility, Cyclistic can convert casual
riders into loyal members.

## Apendix
### Data Cleaning and Preparation
Detailed cleaning steps are included in the analysis script (cyclistic-analysis.R)

### Visualizatoins
All visualizations are saved in the Visuals/ folder:
- num_trips_by_bike.png
- rides_by_day_of_week.png
- rides_by_month.png
### References
- Cyclistic Bike-Share Data: Provided by Cyclistic and publicly available under data usage agreements.




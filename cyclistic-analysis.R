#Load Libraries
library(tidyverse)
library(lubridate)
library(hms)
library(data.table)

#Load Data and Rename
Dec2023 <- read.csv("Data/202312-divvy-tripdata.csv")
Jan2024 <- read.csv("Data/202401-divvy-tripdata.csv")
Feb2024 <- read.csv("Data/202402-divvy-tripdata.csv")
March2024 <- read.csv("Data/202403-divvy-tripdata.csv")
April2024 <- read.csv("Data/202404-divvy-tripdata.csv")
May2024 <- read.csv("Data/202405-divvy-tripdata.csv")
June2024 <- read.csv("Data/202406-divvy-tripdata.csv")
July2024 <- read.csv("Data/202407-divvy-tripdata.csv")
Aug2024 <- read.csv("Data/202408-divvy-tripdata.csv")
Sep2024 <- read.csv("Data/202409-divvy-tripdata.csv")
Oct2024 <- read.csv("Data/202410-divvy-tripdata.csv")
Nov2024 <- read.csv("Data/202411-divvy-tripdata.csv")

#Merge Files into Single Data Frame
trips_year <- rbind(Dec2023, Jan2024, Feb2024, March2024, April2024, May2024, 
                    June2024, July2024, Aug2024, Sep2024, Oct2024, Nov2024)

#Make a Copy of Data Frame
trips_year2 <- trips_year

#Remove Monthly Files From Environment
remove(Dec2023, Jan2024, Feb2024, March2024, April2024, May2024, 
        June2024, July2024, Aug2024, Sep2024, Oct2024, Nov2024)

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

#Remove Duplicate Rows
trips_year2 <- distinct(trips_year2)

#Remove Null Values
trips_year2 <- na.omit(trips_year2)

#Remove Rows Where Ride Length <= 0
trips_year2 <- trips_year2[!(trips_year2$ride_length <= 0),]

#Remove Unnecessary Columns
trips_year2 <- trips_year2 %>%
  select(-c(ride_id, start_station_id, end_station_id, start_lat, start_lng, end_lat, end_lng))

#Convert Ride Length to Numeric Val
trips_year2$ride_length <- as.numeric(as.character(trips_year2$ride_length))

View(trips_year2)

options(scipen=999)

#Total Rides and Average Ride Length
total_rides <- nrow(trips_year2)
summary(trips_year2$ride_length)

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

View(ride_user_summary)

#Ride Length By Bike Type
ride_bike_summary <- trips_year2 %>%
  group_by(rideable_type) %>%
  summarize(
    avg_ride_length = mean(ride_length, na.rm = TRUE),
    median_ride_length = median(ride_length, na.rm = TRUE),
    max_ride_length = max(ride_length, na.rm = TRUE),
    min_ride_length = min(ride_length, na.rm = TRUE),
    total_rides = n()
  )

View(ride_bike_summary)

#Plot Bicycle Type By Number Of Rides
trips_year2 %>%
  group_by(rideable_type, member_casual) %>%
  dplyr::summarize(count_trips = n()) %>%
  ggplot(aes(x=rideable_type, y=count_trips, fill=member_casual, color=member_casual)) +
  geom_bar(stat='identity', position='dodge') +
  theme_bw() +
  labs(title="Number of Trips by Bicycle Type", x="Bicycle Type", y="Number of Rides")

#Total Rides by Bike Type By Member Type
bike_member_summary <- trips_year2 %>%
  group_by(member_casual, rideable_type) %>%
  count(rideable_type)

View(bike_member_summary)

#Arrange Days of the Week in Order
trips_year2$day_of_week <- 
  ordered(trips_year2$day_of_week, levels=c("Sunday", "Monday",
                                            "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))

#Total Rides By Day of Week
rides_by_day <- trips_year2 %>%
  group_by(day_of_week, member_casual) %>%
  summarize(total_rides = n(), avg_ride_length = mean(ride_length, na.rm=TRUE))

View(rides_by_day)

#Plot Number of Rides By Day of Week By Member Type
ggplot(rides_by_day, aes(x=day_of_week, y=total_rides, fill=member_casual, color=member_casual)) +
  geom_bar(stat = "identity", position="dodge") +
  theme_bw()
  labs(
    title = "Total Rides by Day of the Week",
    x = "Day of the Week",
    y = "Total Rides"
  )

#Arrange Months in Order
trips_year2$month <- ordered(trips_year2$month,
                             levels=c("01","02","03",
                                      "04", "05","06","07",
                                      "08","09","10","11","12"))

#Rides By Month
rides_month <- trips_year2 %>%
  group_by(month, member_casual) %>%
  summarize(total_rides=n(), avg_ride_length=mean(ride_length, na.rm=TRUE))

View(rides_month)

#Plot Number of Rides By Month By Member Type
ggplot(rides_month, aes(x=month, y=total_rides, fill=member_casual, color=member_casual)) +
  geom_bar(stat='identity', position='dodge') +
  theme_bw() +
  labs(title="Number of Rides per Month", x="Month", y+"Number of Trips")

#Identify Popular Start Stations By Member Type
top_start_stations <- trips_year2 %>%
  group_by(start_station_name, member_casual) %>%
  summarize(total_rides=n()) %>%
  arrange(desc(total_rides)) %>%
  
View(top_start_stations)




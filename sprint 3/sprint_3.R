# Load necessary libraries
library(jsonlite)
library(dplyr)

# Load the data
flights <- fromJSON("https://github.com/byuidatascience/data4missing/raw/master/data-raw/flights_missing/flights_missing.json")

# Replace varied missing data types with NaN
flights_cleaned <- flights %>%
  mutate(across(everything(), ~ifelse(. %in% c(-999, "", "NA", "null", "nil"), "NaN", .)))

# Print one record example
record_example <- flights_cleaned[1, ]
record_example_json <- toJSON(record_example, pretty=TRUE)
cat(record_example_json)

# Clean and convert relevant columns to numeric
flights_cleaned <- flights_cleaned %>%
  mutate(across(c("num_of_delays_total", "num_of_flights_total", "minutes_delayed_total"), as.numeric))

# Calculate metrics for each airport
airport_summary <- flights_cleaned %>%
  group_by(airport_code) %>%
  summarise(
    total_flights = sum(num_of_flights_total, na.rm = TRUE),
    total_delayed_flights = sum(num_of_delays_total, na.rm = TRUE),
    proportion_delayed = total_delayed_flights / total_flights,
    avg_delay_hours = sum(minutes_delayed_total, na.rm = TRUE) / 60 / total_delayed_flights
  )

# Sort by the highest proportion of delays
worst_airport <- airport_summary %>%
  arrange(desc(proportion_delayed)) %>%
  slice(1)

# Display summary
print(airport_summary)
print(worst_airport)



# Remove rows with missing Month data
flights_no_missing_month <- flights_cleaned %>%
  filter(!is.na(month))

# Group by month and calculate total and proportion of delayed flights
monthly_summary <- flights_no_missing_month %>%
  group_by(month) %>%
  summarise(
    total_flights = sum(num_of_flights_total, na.rm = TRUE),
    total_delayed_flights = sum(num_of_delays_total, na.rm = TRUE),
    proportion_delayed = total_delayed_flights / total_flights
  )

# Plot to visualize the best month
library(ggplot2)
ggplot(monthly_summary, aes(x = month, y = proportion_delayed)) +
  geom_bar(stat = "identity") +
  labs(title = "Proportion of Delayed Flights by Month", x = "Month", y = "Proportion of Delays")



# Replace missing values in the Late Aircraft variable with the mean
flights_cleaned <- flights_cleaned %>%
  mutate(num_of_delays_late_aircraft = ifelse(is.na(num_of_delays_late_aircraft), 
                                              mean(num_of_delays_late_aircraft, na.rm = TRUE), 
                                              num_of_delays_late_aircraft))

# Calculate total weather delays
flights_cleaned <- flights_cleaned %>%
  mutate(weather_delays_total = num_of_delays_weather +
           0.30 * num_of_delays_late_aircraft +
           ifelse(month %in% c("April", "May", "June", "July", "August"), 
                  0.40 * num_of_delays_nas, 
                  0.65 * num_of_delays_nas))

# Show the first 5 rows with the new column
head(flights_cleaned, 5)



# Group by airport and calculate the proportion of flights delayed by weather
weather_delays_summary <- flights_cleaned %>%
  group_by(airport_code) %>%
  summarise(
    total_flights = sum(num_of_flights_total, na.rm = TRUE),
    weather_delays = sum(weather_delays_total, na.rm = TRUE),
    proportion_weather_delays = weather_delays / total_flights
  )

# Create a bar plot
ggplot(weather_delays_summary, aes(x = reorder(airport_code, proportion_weather_delays), y = proportion_weather_delays)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Proportion of Flights Delayed by Weather at Each Airport", x = "Airport", y = "Proportion of Weather Delays")


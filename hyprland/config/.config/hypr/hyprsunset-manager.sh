#!/usr/bin/env bash
#
# This script automatically sets your display’s color temperature via the
# `hyprsunset` command based on local sunrise and sunset times.
#
# Requirements: curl, jq, awk, GNU date.
#
# Configuration:
LAT="51.93855"            # Latitude (e.g., New York City)
LNG="8.87318"           # Longitude
MAX_TEMP=6500            # Color temperature during daytime (in Kelvin)
MIN_TEMP=2700            # Color temperature during night (in Kelvin)
# Duration (in seconds) for the transition (e.g. 3600 = 1 hour)
TRANSITION_DURATION=3600
# How often (in seconds) to update the temperature.
SLEEP_INTERVAL=1

# The API URL (formatted=0 returns ISO8601 times in UTC)
API_URL="https://api.sunrise-sunset.org/json?lat=${LAT}&lng=${LNG}&formatted=0"

# Get today's date (used for the API query)
current_day=$(date +%Y-%m-%d)

# Function to fetch sunrise and sunset times for $current_day.
fetch_sun_times() {
  # Query the API; note we add "&date=$current_day" to force today's times.
  data=$(curl -s "${API_URL}&date=${current_day}")
  # Parse out sunrise and sunset in ISO8601 UTC using jq.
  sunrise_utc=$(echo "$data" | jq -r '.results.sunrise')
  sunset_utc=$(echo "$data" | jq -r '.results.sunset')
  # Convert to local epoch seconds.
  sunrise=$(date -d "$sunrise_utc" +%s)
  sunset=$(date -d "$sunset_utc" +%s)
}

# Get the sunrise/sunset times for the current day.
fetch_sun_times

while true; do
  # If the day has changed, re-fetch sunrise and sunset times.
  new_day=$(date +%Y-%m-%d)
  if [ "$new_day" != "$current_day" ]; then
    current_day="$new_day"
    fetch_sun_times
  fi

  now=$(date +%s)

  # Determine which temperature to set:
  # 1. Before sunrise: night temperature.
  # 2. During sunrise transition: interpolate from MIN_TEMP to MAX_TEMP.
  # 3. Daytime (after sunrise transition and before sunset transition): MAX_TEMP.
  # 4. During sunset transition: interpolate from MAX_TEMP down to MIN_TEMP.
  # 5. After sunset: night temperature.
  if [ "$now" -lt "$sunrise" ]; then
    temp=$MIN_TEMP
  elif [ "$now" -lt $((sunrise + TRANSITION_DURATION)) ]; then
    # Sunrise transition: fraction goes from 0 at sunrise to 1 after TRANSITION_DURATION.
    delta=$(( now - sunrise ))
    frac=$(echo "scale=4; $delta / $TRANSITION_DURATION" | bc -l)
    # Compute temperature and round by adding 0.5 then truncating the decimal.
    temp_calc=$(echo "scale=4; $MIN_TEMP + ($MAX_TEMP - $MIN_TEMP) * $frac" | bc -l)
    temp=$(echo "$temp_calc + 0.5" | bc -l | cut -d'.' -f1)
  elif [ "$now" -lt $((sunset - TRANSITION_DURATION)) ]; then
    # Daytime.
    temp=$MAX_TEMP
  elif [ "$now" -lt "$sunset" ]; then
    # Sunset transition: fraction goes from 0 at (sunset - TRANSITION_DURATION) to 1 at sunset.
    delta=$(( now - (sunset - TRANSITION_DURATION) ))
    frac=$(echo "scale=4; $delta / $TRANSITION_DURATION" | bc -l)
    temp_calc=$(echo "scale=4; $MAX_TEMP - ($MAX_TEMP - $MIN_TEMP) * $frac" | bc -l)
    temp=$(echo "$temp_calc + 0.5" | bc -l | cut -d'.' -f1)
  else
    temp=$MIN_TEMP
  fi

  # Set the color temperature using hyprsunset.
  hyprsunset --temperature "$temp"

  # Sleep before next update.
  sleep "$SLEEP_INTERVAL"
done

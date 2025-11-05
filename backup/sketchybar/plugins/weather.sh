sketchybar --set $NAME \
  label="Loading..." \
  icon.color=0xff5edaff

# fetch weather data
# TODO: Make this dynamic to the current location
LOCATION="Odense"

# Line below replaces spaces with +
WEATHER=$(curl -s "https://wttr.in/Odense?0pq&format=3")

# Fallback if empty
if [ -z $WEATHER ]; then
  sketchybar --set $NAME label="$LOCATION"
  return
fi

sketchybar --set $NAME \
  label="$WEATHER"

#!/bin/sh

# TODO: separate files for each item

battery=(
  click_script="osascript -e 'tell application \"System Events\" to tell process \"Control Center\" to perform action \"AXPress\" of menu bar item 4 of menu bar 1'"
  width=35
)

bento=(
  click_script="osascript -e 'tell application \"System Events\" to tell process \"Control Center\" to perform action \"AXPress\" of menu bar item 2 of menu bar 1'"
  width=35
)

focus=(
  click_script="osascript -e 'tell application \"System Events\" to tell process \"Control Center\" to perform action \"AXPress\" of menu bar item 5 of menu bar 1'"
  width=35
)

wifi=(
  click_script="osascript -e 'tell application \"System Events\" to tell process \"Control Center\" to perform action \"AXPress\" of menu bar item 3 of menu bar 1'"
  width=35
)

playing=(
  click_script="osascript -e 'tell application \"System Events\" to tell process \"Control Center\" to perform action \"AXPress\" of menu bar item 6 of menu bar 1'"
  width=30
)

sound=(
  click_script="osascript -e 'tell application \"System Events\" to tell process \"Control Center\" to perform action \"AXPress\" of menu bar item 7 of menu bar 1'"
  width=35
)


input=(
  width=100
)
sketchybar --add alias "Control Center,Battery" right \
           --set "Control Center,Battery" "${battery[@]}" \
sketchybar --add alias "Control Center,BentoBox" right \
           --set "Control Center,BentoBox" "${bento[@]}" \
sketchybar --add alias "TextInputMenuAgent,Item-0" right \
           --set "TextInputMenuAgent,Item-0" "${input[@]}" \
sketchybar --add alias "Control Center,FocusModes" right \
           --set "Control Center,FocusModes" "${focus[@]}" \
sketchybar --add alias "Control Center,WiFi" right \
           --set "Control Center,WiFi" "${wifi[@]}" \
sketchybar --add alias "Control Center,NowPlaying" right \
           --set "Control Center,NowPlaying" "${playing[@]}" \
sketchybar --add alias "Control Center,Sound" right \
           --set "Control Center,Sound" "${sound[@]}" \

#!/bin/bash

echo "Creating attractive screenshots with logo..."

# Screenshot 1: Main screen with logo
convert -size 1080x1920 xc:#1E1B4B \
  logo.png -resize 300x300 -gravity center -geometry +0-400 -composite \
  -fill white -gravity center -pointsize 60 -annotate +0-100 "WORKPHONY" \
  -fill #E0E7FF -gravity center -pointsize 30 -annotate +0-50 "Focus & Productivity" \
  -fill white -gravity center -pointsize 24 -annotate +0+100 "🎵 White Noise Sounds" \
  -fill white -gravity center -pointsize 24 -annotate +0+150 "⏲️ Pomodoro Timer" \
  -fill white -gravity center -pointsize 24 -annotate +0+200 "⭐ Favorites" \
  -fill white -gravity center -pointsize 24 -annotate +0+250 "🔔 Smart Notifications" \
  screenshot1_main_screen.png

# Screenshot 2: Timer screen
convert -size 1080x1920 xc:#1E1B4B \
  logo.png -resize 200x200 -gravity center -geometry +0-500 -composite \
  -fill white -gravity center -pointsize 60 -annotate +0-200 "POMODORO" \
  -fill #E0E7FF -gravity center -pointsize 30 -annotate +0-100 "Focus Timer" \
  -fill white -gravity center -pointsize 80 -annotate +0+50 "25:00" \
  -fill #F59E0B -gravity center -pointsize 24 -annotate +0+200 "Work Session" \
  -fill white -gravity center -pointsize 20 -annotate +0+300 "Session 1 of 4" \
  screenshot2_timer_screen.png

# Screenshot 3: Sounds screen
convert -size 1080x1920 xc:#1E1B4B \
  logo.png -resize 200x200 -gravity center -geometry +0-500 -composite \
  -fill white -gravity center -pointsize 60 -annotate +0-200 "SOUNDS" \
  -fill #E0E7FF -gravity center -pointsize 30 -annotate +0-100 "White Noise Library" \
  -fill white -gravity center -pointsize 24 -annotate +0+50 "🌧️ Rain Sounds" \
  -fill white -gravity center -pointsize 24 -annotate +0+100 "⛲ Fountain Sounds" \
  -fill white -gravity center -pointsize 24 -annotate +0+150 "🎵 High Quality Audio" \
  -fill white -gravity center -pointsize 24 -annotate +0+200 "🔊 Customizable Volume" \
  -fill white -gravity center -pointsize 24 -annotate +0+250 "⭐ Save Favorites" \
  screenshot3_sounds_screen.png

# Screenshot 4: Settings screen
convert -size 1080x1920 xc:#1E1B4B \
  logo.png -resize 200x200 -gravity center -geometry +0-500 -composite \
  -fill white -gravity center -pointsize 60 -annotate +0-200 "SETTINGS" \
  -fill #E0E7FF -gravity center -pointsize 30 -annotate +0-100 "Customize Your Experience" \
  -fill white -gravity center -pointsize 24 -annotate +0+50 "⏰ Work Duration: 25 min" \
  -fill white -gravity center -pointsize 24 -annotate +0+100 "☕ Break Duration: 5 min" \
  -fill white -gravity center -pointsize 24 -annotate +0+150 "🔔 Notifications: ON" \
  -fill white -gravity center -pointsize 24 -annotate +0+200 "📳 Vibration: ON" \
  -fill white -gravity center -pointsize 24 -annotate +0+250 "🔒 Privacy-First Design" \
  screenshot4_settings_screen.png

echo "Screenshots created successfully!" 
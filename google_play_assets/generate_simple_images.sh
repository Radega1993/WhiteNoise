#!/bin/bash

# Create simple colored backgrounds for screenshots
echo "Generating simple screenshots..."

# Screenshot 1: Main screen
convert -size 1080x1920 xc:#1E1B4B \
  -fill white -gravity center -pointsize 60 -annotate +0-400 "WORKPHONY" \
  -fill #E0E7FF -gravity center -pointsize 30 -annotate +0-300 "Focus & Productivity" \
  screenshot1_main_screen.png

# Screenshot 2: Timer screen  
convert -size 1080x1920 xc:#1E1B4B \
  -fill white -gravity center -pointsize 60 -annotate +0-400 "POMODORO" \
  -fill #E0E7FF -gravity center -pointsize 30 -annotate +0-300 "Focus Timer" \
  -fill white -gravity center -pointsize 80 -annotate +0-100 "25:00" \
  screenshot2_timer_screen.png

# Screenshot 3: Sounds screen
convert -size 1080x1920 xc:#1E1B4B \
  -fill white -gravity center -pointsize 60 -annotate +0-400 "SOUNDS" \
  -fill #E0E7FF -gravity center -pointsize 30 -annotate +0-300 "White Noise Library" \
  -fill white -gravity center -pointsize 24 -annotate +0-100 "Rain Sounds" \
  -fill white -gravity center -pointsize 24 -annotate +0-50 "Fountain Sounds" \
  screenshot3_sounds_screen.png

# Screenshot 4: Settings screen
convert -size 1080x1920 xc:#1E1B4B \
  -fill white -gravity center -pointsize 60 -annotate +0-400 "SETTINGS" \
  -fill #E0E7FF -gravity center -pointsize 30 -annotate +0-300 "Customize Your Experience" \
  -fill white -gravity center -pointsize 24 -annotate +0-100 "Work Duration: 25 min" \
  -fill white -gravity center -pointsize 24 -annotate +0-50 "Break Duration: 5 min" \
  screenshot4_settings_screen.png

# Create simple app icon
convert -size 512x512 xc:#1E1B4B \
  -fill #3730A3 -draw "circle 256,256 256,100" \
  -fill white -draw "circle 256,256 256,80" \
  -fill #1E1B4B -draw "polygon 240,240 240,272 272,256" \
  app_icon.png

# Create simple feature graphic
convert -size 1024x500 xc:#1E1B4B \
  -fill #3730A3 -draw "rectangle 50,50 974,450" \
  -fill white -gravity center -pointsize 48 -annotate +0-100 "WORKPHONY" \
  -fill #E0E7FF -gravity center -pointsize 24 -annotate +0-50 "Focus & Productivity" \
  -fill white -gravity center -pointsize 18 -annotate +0+50 "White Noise + Pomodoro Timer" \
  feature_graphic.png

echo "Simple images generated successfully!" 
#!/bin/bash

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "ImageMagick is not installed. Installing..."
    sudo apt-get update
    sudo apt-get install -y imagemagick
fi

# Create app icon (512x512)
echo "Generating app icon..."
convert app_icon.svg -resize 512x512 app_icon.png

# Create feature graphic (1024x500)
echo "Generating feature graphic..."
convert feature_graphic.svg -resize 1024x500 feature_graphic.png

# Create phone screenshots (1080x1920 - 9:16 aspect ratio)
echo "Generating phone screenshots..."

# Screenshot 1: Main screen
convert -size 1080x1920 xc:#1E1B4B \
  -fill white -font Arial -pointsize 60 -gravity center -annotate +0-400 "WORKPHONY" \
  -fill #E0E7FF -font Arial -pointsize 30 -gravity center -annotate +0-300 "Focus & Productivity" \
  -fill white -font Arial -pointsize 24 -gravity center -annotate +0-100 "🎵 White Noise Sounds" \
  -fill white -font Arial -pointsize 24 -gravity center -annotate +0+50 "⏲️ Pomodoro Timer" \
  -fill white -font Arial -pointsize 24 -gravity center -annotate +0+100 "⭐ Favorites" \
  -fill white -font Arial -pointsize 24 -gravity center -annotate +0+150 "🔔 Smart Notifications" \
  screenshot1_main_screen.png

# Screenshot 2: Timer screen
convert -size 1080x1920 xc:#1E1B4B \
  -fill white -font Arial -pointsize 60 -gravity center -annotate +0-400 "POMODORO" \
  -fill #E0E7FF -font Arial -pointsize 30 -gravity center -annotate +0-300 "Focus Timer" \
  -fill white -font Arial -pointsize 80 -gravity center -annotate +0-100 "25:00" \
  -fill #F59E0B -font Arial -pointsize 24 -gravity center -annotate +0+100 "Work Session" \
  -fill white -font Arial -pointsize 20 -gravity center -annotate +0+200 "Session 1 of 4" \
  screenshot2_timer_screen.png

# Screenshot 3: Sounds screen
convert -size 1080x1920 xc:#1E1B4B \
  -fill white -font Arial -pointsize 60 -gravity center -annotate +0-400 "SOUNDS" \
  -fill #E0E7FF -font Arial -pointsize 30 -gravity center -annotate +0-300 "White Noise Library" \
  -fill white -font Arial -pointsize 24 -gravity center -annotate +0-100 "🌧️ Rain Sounds" \
  -fill white -font Arial -pointsize 24 -gravity center -annotate +0-50 "⛲ Fountain Sounds" \
  -fill white -font Arial -pointsize 24 -gravity center -annotate +0+0 "🎵 High Quality Audio" \
  -fill white -font Arial -pointsize 24 -gravity center -annotate +0+50 "🔊 Customizable Volume" \
  -fill white -font Arial -pointsize 24 -gravity center -annotate +0+100 "⭐ Save Favorites" \
  screenshot3_sounds_screen.png

# Screenshot 4: Settings screen
convert -size 1080x1920 xc:#1E1B4B \
  -fill white -font Arial -pointsize 60 -gravity center -annotate +0-400 "SETTINGS" \
  -fill #E0E7FF -font Arial -pointsize 30 -gravity center -annotate +0-300 "Customize Your Experience" \
  -fill white -font Arial -pointsize 24 -gravity center -annotate +0-100 "⏰ Work Duration: 25 min" \
  -fill white -font Arial -pointsize 24 -gravity center -annotate +0-50 "☕ Break Duration: 5 min" \
  -fill white -font Arial -pointsize 24 -gravity center -annotate +0+0 "🔔 Notifications: ON" \
  -fill white -font Arial -pointsize 24 -gravity center -annotate +0+50 "📳 Vibration: ON" \
  -fill white -font Arial -pointsize 24 -gravity center -annotate +0+100 "🔒 Privacy-First Design" \
  screenshot4_settings_screen.png

echo "All images generated successfully!"
echo "Files created:"
echo "- app_icon.png (512x512)"
echo "- feature_graphic.png (1024x500)"
echo "- screenshot1_main_screen.png (1080x1920)"
echo "- screenshot2_timer_screen.png (1080x1920)"
echo "- screenshot3_sounds_screen.png (1080x1920)"
echo "- screenshot4_settings_screen.png (1080x1920)" 
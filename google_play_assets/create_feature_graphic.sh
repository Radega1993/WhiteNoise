#!/bin/bash

echo "Creating professional feature graphic..."

# Create base image with correct size
convert -size 1024x500 xc:#1E1B4B temp_bg.png

# Add logo
convert temp_bg.png logo.png -resize 120x120 -gravity center -geometry +0-120 -composite temp_with_logo.png

# Add text using a simpler approach
convert temp_with_logo.png \
  -fill white -gravity center -pointsize 48 -annotate +0+20 "WORKPHONY" \
  -fill #E0E7FF -gravity center -pointsize 24 -annotate +0+80 "Focus & Productivity" \
  -fill white -gravity center -pointsize 18 -annotate +0+120 "White Noise + Pomodoro Timer" \
  feature_graphic.png

# Clean up temp files
rm temp_bg.png temp_with_logo.png

echo "Feature graphic created successfully!"
identify feature_graphic.png 
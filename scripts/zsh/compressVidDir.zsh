for file in *; do
    if [ -f "$file" ]; then
        new_location=$(echo "$file" | sed -r 's/.*VID_([0-9]{4})([0-9]{2})([0-9]{2})_([0-9]{6})\.mp4.*/\1_\2_\3_\4.mp4/')
        ffmpeg -i "$file" -vcodec libx264 -crf 24 "$new_location"
    fi
done

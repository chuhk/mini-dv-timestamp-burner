#!/bin/bash

# ==============================================================================
# Mini DV Timestamp Burner
# Description: Extracts creation time from .dv files, bypasses local timezone
#              offsets (e.g., HKT UTC+8) using UTC Unix epoch, and burns the
#              timestamp onto the output video using FFmpeg.
# ==============================================================================

# Target directory (defaults to current directory if not provided)
TARGET_DIR="${1:-.}"

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    echo "Error: ffmpeg is not installed. Please install ffmpeg first."
    exit 1
fi

echo "Scanning for Mini DV files in: $TARGET_DIR"

# Loop through all .dv files (case-insensitive)
for file in "$TARGET_DIR"/*.dv "$TARGET_DIR"/*.DV; do
    # Check if file exists to prevent running on empty glob
    [ -e "$file" ] || continue
    
    filename=$(basename "$file")
    filename_noext="${filename%.*}"
    output_file="$TARGET_DIR/${filename_noext}_timestamped.mp4"

    echo "----------------------------------------"
    echo "Processing: $file"

    # 1. Extract metadata creation_time using ffprobe
    dt=$(ffprobe -v error -show_entries format_tags=creation_time -of default=noprint_wrappers=1:nokey=1 "$file")

    if [ -z "$dt" ]; then
        echo "Warning: Could not extract creation_time metadata for $file. Skipping..."
        continue
    fi

    # 2. Convert ISO date string to UTC Unix epoch timestamp to bypass system timezone offset
    epoch=$(date -u -d "$dt" +%s 2>/dev/null || date -j -u -f "%Y-%m-%dT%H:%M:%SZ" "$dt" +%s 2>/dev/null)

    if [ -z "$epoch" ]; then
        echo "Warning: Failed to parse date string ($dt). Skipping..."
        continue
    fi

    # 3. Burn timestamp onto video using FFmpeg drawtext with gmtime
    ffmpeg -i "$file" \
        -vf "drawtext=text='%{gmtime\\:$epoch\\:%Y-%m-%d %H\\\\\\: %M\\\\\\: %S}':x=w-tw-20:y=h-th-20:fontsize=24:fontcolor=white:box=1:boxcolor=black@0.6" \
        -c:a copy "$output_file" -y

    echo "Successfully generated: $output_file"
done

echo "----------------------------------------"
echo "All Mini DV files processed successfully!"

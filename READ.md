# Mini DV Timestamp Burner

A lightweight, automated Shell script that extracts recording timestamps from captured Mini DV video files and burns them directly onto the video frames using FFmpeg.

## 🌟 Key Features

* **Timezone Offset Fix:** Solves the common issue where system local timezones (e.g., HKT / UTC+8) introduce unwanted time offsets during FFmpeg timestamp calculation. Utilizes Unix epoch timestamps (`date -u`) to guarantee 100% accurate recording dates.
* **Batch Processing:** Automatically scans and processes all `.dv` files in a given directory.
* **Cross-Platform:** Works seamlessly on macOS and Linux (Pop!_OS, Ubuntu, Rocky Linux, etc.).
* **Preserves Video Quality:** Uses high-quality FFmpeg `drawtext` overlays while re-encoding into easily shareable format (`.mp4`).

## 📋 Prerequisites

Make sure you have **FFmpeg** installed on your system.

* **macOS (via Homebrew):**
  ```bash
  brew install ffmpeg

  Ubuntu / Pop!_OS (Debian-based):

  sudo apt install ffmpeg

  Rocky Linux / RHEL / Fedora:

  sudo dnf install ffmpeg

  🚀 Usage
1. Clone this repository or download the script:

git clone [https://github.com/chuhk/mini-dv-timestamp-burner.git](https://github.com/chuhk/mini-dv-timestamp-burner.git)
cd mini-dv-timestamp-burner

2. Make the script executable:

chmod +x burn_timestamp.sh

3. Run the script on your folder containing .dv files:

./burn_timestamp.sh /path/to/your/dv_files

💡 How It Works
1. Extracts the DV metadata creation time from the file header.

2. Converts the ISO date string to a UTC Unix timestamp to bypass system local timezone logic.

3. Passes the normalized timestamp into FFmpeg's drawtext filter with gmtime formatting to overlay the exact original recording date and time onto the video.

📄 License
MIT License

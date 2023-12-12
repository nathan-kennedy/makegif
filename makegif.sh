# #!/bin/bash

# # Function to clean up temporary files
# cleanup() {
#     rm -f "$temp_gif" "$palette"
# }

# # Function to check dependencies
# check_dependencies() {
#     local missing_deps=0
#     for dep in ffmpeg gifsicle; do
#         if ! command -v $dep &> /dev/null; then
#             echo "Error: $dep is not installed."
#             missing_deps=$((missing_deps+1))
#         fi
#     done
#     return $missing_deps
# }

# create_gif() {
#     local source_video=$1
#     local start_time=$2
#     local duration=$3
#     local output_gif=$4
#     local quality=$5
#     local width=$6
#     local fps=$7
#     local num_colors=$8

#     trap cleanup EXIT

#     if [[ "$source_video" == "~/"* ]]; then
#         source_video="$HOME/${source_video:2}"
#     fi

#     if [ ! -f "$source_video" ]; then
#         echo "Error: Source video does not exist."
#         return 1
#     fi

#     # Validate start_time and duration format if necessary...

#     local temp_gif="temp_$output_gif"
#     local palette="/tmp/palette.png"

#     if [ "$quality" = "high" ]; then
#         ffmpeg -ss "$start_time" -t "$duration" -i "$source_video" -vf "fps=$fps,scale=$width:-1:flags=lanczos,palettegen" "$palette" &&
#         ffmpeg -ss "$start_time" -t "$duration" -i "$source_video" -i "$palette" -filter_complex "fps=$fps,scale=$width:-1[x];[x][1:v]paletteuse" -an "$temp_gif" &&
#         rm "$palette"
#     else
#         ffmpeg -ss "$start_time" -t "$duration" -i "$source_video" -filter_complex "fps=$fps,scale=$width:-1" -an "$temp_gif"
#     fi

#     if [ $? -ne 0 ]; then
#         echo "Error during GIF creation."
#         return 1
#     fi

#     echo "Optimizing GIF for smaller file size with $num_colors colors..."
#     gifsicle -O3 --colors $num_colors "$temp_gif" -o "$output_gif" &&
#     rm "$temp_gif" &&
#     echo "Optimized GIF created: $output_gif"
# }

# makegif() {

#     # Check for required dependencies
#     if ! check_dependencies; then
#         return 1
#     fi

#     #local source_video start_time duration output_gif quality width fps num_colors

#     if [ $# -eq 0 ]; then
#         # Interactive Mode
#         echo "Enter the source video path:"
#         read source_video

#         echo "Enter the start time (hh:mm:ss):"
#         read start_time

#         echo "Enter the duration (hh:mm:ss):"
#         read duration

#         echo "Enter the output GIF file name:"
#         read output_gif

#         echo "Enter the quality (high/low, default: low). Press Enter to skip:"
#         read quality
#         quality=${quality:-low}

#         echo "Enter the width (default: 640). Press Enter to skip:"
#         read width
#         width=${width:-640}

#         echo "Enter the frames per second (FPS, default: 10). Press Enter to skip:"
#         read fps
#         fps=${fps:-10}

#         echo "Enter the number of colors for optimization (default: 256). Reducing the number of colors can significantly reduce file size. Try using 128 to see if the results are satisfactory. Press Enter to use the default:"
#         read num_colors
#         num_colors=${num_colors:-256}

#         create_gif "$source_video" "$start_time" "$duration" "$output_gif" "$quality" "$width" "$fps" "$num_colors"
#     elif [ $# -ge 5 ]; then
#         # Argument Mode
#         source_video=$1
#         start_time=$2
#         duration=$3
#         output_gif=$4
#         quality=${5:-low}
#         width=${6:-640}
#         fps=${7:-10}
#         num_colors=${8:-256}

#         create_gif "$source_video" "$start_time" "$duration" "$output_gif" "$quality" "$width" "$fps" "$num_colors"
#     else
#         # Insufficient Arguments
#         echo "Usage: makegif <source_video> <start_time> <duration> <output_gif> <quality> [width] [fps] [num_colors]"
#         echo "Run the function without arguments to use interactive mode."
#         return 1
#     fi
# }

#!/bin/bash

# Function to clean up temporary files
cleanup() {
    rm -f "$temp_gif" "$palette"
}

# Function to check dependencies
check_dependencies() {
    local missing_deps=0
    for dep in ffmpeg gifsicle; do
        if ! command -v $dep &> /dev/null; then
            echo "Error: $dep is not installed."
            missing_deps=$((missing_deps+1))
        fi
    done
    return $missing_deps
}

# Function to get crop parameters
get_crop_params() {
    local source_video=$1
    local crop_params=$(ffmpeg -ss 00:05:00 -t 10 -i "$source_video" -vf "cropdetect" -f null - 2>&1 | grep -oE 'crop=[0-9]+:[0-9]+:[0-9]+:[0-9]+' | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}' | sed 's/crop=//')
    echo $crop_params
}

create_gif() {
    local source_video=$1
    local start_time=$2
    local duration=$3
    local output_gif=$4
    local quality=$5
    local width=$6
    local fps=$7
    local num_colors=$8
    local remove_black_bars=$9
    #local square_aspect=${10}

    trap cleanup EXIT

    if [[ "$source_video" == "~/"* ]]; then
        source_video="$HOME/${source_video:2}"
    fi

    if [ ! -f "$source_video" ]; then
        echo "Error: Source video does not exist."
        return 1
    fi

    # Validate start_time and duration format if necessary...

local filters="fps=$fps"
if [ "$remove_black_bars" = "yes" ]; then
    local crop_params=$(get_crop_params "$source_video")
    if [ -n "$crop_params" ]; then
        filters="$filters,crop=$crop_params"
    else
        echo "No valid crop parameters detected."
        return 1
    fi
fi

if [ "$square_aspect" = "yes" ]; then
    local square_size="min(iw,ih)"
    filters="$filters,scale=${square_size}:${square_size}"
else
    filters="$filters,scale=${width}:-1"
fi

local temp_gif="temp_$output_gif"
local palette="/tmp/palette.png"

echo "Running ffmpeg with filters: $filters"
echo "Executing ffmpeg command: ffmpeg -ss \"$start_time\" -t \"$duration\" -i \"$source_video\" -filter_complex \"$filters,palettegen=stats_mode=full\" -y \"$palette\""


if [ "$quality" = "high" ]; then
    ffmpeg -ss "$start_time" -t "$duration" -i "$source_video" -filter_complex "$filters,palettegen=stats_mode=full" -y "$palette" &&
    ffmpeg -ss "$start_time" -t "$duration" -i "$source_video" -i "$palette" -filter_complex "$filters,paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle" -an "$temp_gif"
else
    ffmpeg -ss "$start_time" -t "$duration" -i "$source_video" -vf "$filters" -an "$temp_gif"
fi



    if [ $? -ne 0 ]; then
        echo "Error during GIF creation."
        return 1
    fi

    echo "Optimizing GIF for smaller file size with $num_colors colors..."
    gifsicle -O3 --colors $num_colors "$temp_gif" -o "$output_gif" &&
    rm "$temp_gif" &&
    echo "Optimized GIF created: $output_gif"
}

makegif() {

    # Check for required dependencies
    if ! check_dependencies; then
        return 1
    fi

    if [ $# -eq 0 ]; then
        # Interactive Mode
        echo "Enter the source video path:"
        read source_video

        echo "Enter the start time (hh:mm:ss):"
        read start_time

        echo "Enter the duration (hh:mm:ss):"
        read duration

        echo "Enter the output GIF file name:"
        read output_gif

        echo "Enter the quality (high/low, default: low). Press Enter to skip:"
        read quality
        quality=${quality:-low}

        echo "Enter the width (default: 640). Press Enter to skip:"
        read width
        width=${width:-640}

        echo "Enter the frames per second (FPS, default: 10). Press Enter to skip:"
        read fps
        fps=${fps:-10}

        echo "Enter the number of colors for optimization (default: 256). Press Enter to skip:"
        read num_colors
        num_colors=${num_colors:-256}

        echo "Remove black bars? (yes/no, default: no). Press Enter to skip:"
        read remove_black_bars
        remove_black_bars=${remove_black_bars:-no}

        #echo "Make aspect ratio square? (yes/no, default: no). Press Enter to #skip:"
        #read square_aspect
        square_aspect=${square_aspect:-no}

        create_gif "$source_video" "$start_time" "$duration" "$output_gif" "$quality" "$width" "$fps" "$num_colors" "$remove_black_bars" "$square_aspect"
    elif [ $# -ge 5 ]; then
        # Argument Mode
        source_video=$1
        start_time=$2
        duration=$3
        output_gif=$4
        quality=${5:-low}
        width=${6:-640}
        fps=${7:-10}
        num_colors=${8:-256}
        remove_black_bars=${9:-no}
        square_aspect=${10:-no}

        create_gif "$source_video" "$start_time" "$duration" "$output_gif" "$quality" "$width" "$fps" "$num_colors" "$remove_black_bars" "$square_aspect"
    else
        # Insufficient Arguments
        echo "Usage: makegif <source_video> <start_time> <duration> <output_gif (be sure to end in '.gif')> <quality (high or low)> [width (in pixels)] [fps] [num_colors (2 - 255)] [remove_black_bars (yes or no)]"
        echo "Run the function without arguments to use interactive mode."
        return 1
    fi
}

# Uncomment the following line to enable the script to be run directly
# makegif "$@"

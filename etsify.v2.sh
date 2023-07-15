#!/bin/bash

# Function to rename "AR-11x14" to "11x14in" and replace "AR-23x30" with "ISO-Format"
# function upscale_images() {
#     local directory="$1"
#     local outfile_prefix="300dpi_"

#     for file in "$directory"/*.png; do
#         local infile="$file"
#         local outfile="$directory/${outfile_prefix}$(basename "$infile")"
#         pngcrush -res 300 "$infile" "$outfile"
#         mv "$outfile" "${outfile/300dpi_/}"
#     done
# }


function rename_files() {
    local directory="$1"
    for file in "$directory"/*; do
        if [[ $(basename "$file") == *"AR-24x36.jpg" ]]; then
            new_filename="${file%"AR-24x36.jpg"}AR-2x3.jpg"
            mv "$file" "$new_filename"
            echo "Renamed file '$file' to '$new_filename'."
        elif [[ $(basename "$file") == *"AR-11x14.jpg" ]]; then
            new_filename="${file%"AR-11x14.jpg"}11x14in.jpg"
            mv "$file" "$new_filename"
            echo "Renamed file '$file' to '$new_filename'."
        elif [[ $(basename "$file") == *"AR-23x30.jpg" ]]; then
            new_filename="${file%"AR-23x30.jpg"}ISO-Format.jpg"
            mv "$file" "$new_filename"
            echo "Renamed file '$file' to '$new_filename'."
        elif [[ $(basename "$file") == *"AR-16x20.jpg" ]]; then
            new_filename="${file%"AR-16x20.jpg"}AR-4x5.jpg"
            mv "$file" "$new_filename"
            echo "Renamed file '$file' to '$new_filename'."
        elif [[ $(basename "$file") == *"AR-24x32.jpg" ]]; then
            new_filename="${file%"AR-24x32.jpg"}AR-3x4.jpg"
            mv "$file" "$new_filename"
            echo "Renamed file '$file' to '$new_filename'."
        else
            echo "Skipping file '$file'. No renaming required."
        fi
    done
}

# # Create function - Resize images using ImageMagick
# function resize_images() {
#     local input_directory="$1"
#     local output_directory="$2"
#     local width="$3"
#     local height="$4"
#     local dpi="$5"

#     # Calculate the physical dimensions in inches based on the DPI
#     width_inch=$(awk -v w="$width" -v d="$dpi" 'BEGIN { printf "%.0f", w/d }')
#     height_inch=$(awk -v h="$height" -v d="$dpi" 'BEGIN { printf "%.0f", h/d }')

#     # Create the aspect ratio in inches (e.g., "4x6")
#     aspect_ratio="${width_inch}x${height_inch}"

#     for file in "$input_directory"/*.png; do
#         filename_base=$(basename "$file")
#         filename="${filename_base%.png}" 

#         if [ ! -d "$output_directory/$filename" ]; then
#             mkdir "$output_directory/$filename"
#             echo "Directory '$filename' created successfully."
#         fi

#         # Set the output file path with aspect ratio in the filename
#         output_file="$output_directory/$filename/${filename}-AR-${aspect_ratio}.jpg"

#         # Resize the image using ImageMagick with specified DPI
#         convert "$file" -resize "${width}x${height}!" -density "$dpi" "$output_file"
        
#         echo "Resized $file to $output_file"
#     done
# }
function resize_images() {
    local input_directory="$1"
    local output_directory="$2"
    local width="$3"
    local height="$4"
    local dpi="$5"

    # Calculate the physical dimensions in inches based on the DPI
    width_inch=$(awk -v w="$width" -v d="$dpi" 'BEGIN { printf "%.0f", w/d }')
    height_inch=$(awk -v h="$height" -v d="$dpi" 'BEGIN { printf "%.0f", h/d }')

    # Create the aspect ratio in inches (e.g., "4x6")
    aspect_ratio="${width_inch}x${height_inch}"

    for file in "$input_directory"/*.png; do
        filename_base=$(basename "$file")
        filename="${filename_base%.png}" 

        if [ ! -d "$output_directory/$filename" ]; then
            mkdir "$output_directory/$filename"
            echo "Directory '$filename' created successfully."
        fi

        # Set the output file path with aspect ratio in the filename
        output_file="$output_directory/$filename/${filename}-AR-${aspect_ratio}.jpg"

        # 

        # Resize the image using ImageMagick to the exact dimensions
        convert "$file" -resize "${width}x${height}!" "$output_file"

        echo "Resized $file to $output_file"

        # Remove the "300dpi_" prefix from the filename
    done
}

# Usage: resize_images input_directory output_directory width height dpi

# upscale_images "./src"

# 2x3 - 24 x 36" / 7200px x 10800px / 300 DPI
resize_images "./src" "./output" 7200 10800 300

# 3x4 - 24 x 32" / 7200px x 9600px / 300 DPI
resize_images "./src" "./output" 7200 9600 300

# 4x5 - 16 x 20" / 4800px x 6000px / 300 DPI
resize_images "./src" "./output" 4800 6000 300

# 11”x14” - 3300 px x 4200 px / 300 DPI
resize_images "./src" "./output" 3300 4200 300

# ISO format  - 7016px x 9033px / 300 DPI
resize_images "./src" "./output" 7016 9033 300

# Call the function to rename files
for filename in "./output"/*; do
    if [ -d "$filename" ]; then
    rename_files "$filename"
    fi
done
# Create a zip file for each resized image
for filename in "./output"/*; do
    if [ -d "$filename" ]; then
        echo "Creating zip file for $filename..."
        zip -j "./zip/$(basename "$filename").zip" "$filename"/*
    fi
done

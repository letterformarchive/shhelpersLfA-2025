#!/bin/bash -x

echo "Greetings $USER 🦋"

BASE_DIR="/Users/ellis/Downloads/veloz"  ### Set to folder containing images to process

echo "This script allows you to do multiple shell tasks in one! 
Working directly in: $BASE_DIR

Press 'j' to convert .tif files to .jpg
Press 'c' to autocrop .jpg files
Press 'm' to add 40px margin to .jpg files
Press 'r' to resize .jpg files and make mids
Press 'q' to quit
"

while [[ ! $REPLY =~ ^[Qq]$ ]]; do
    read -p "Please make a selection: " -n 1 -r
    echo

    case $REPLY in
        [Jj])
            files="$BASE_DIR"/*.tif
            total_files=$(ls -1 $files 2>/dev/null | wc -l)
            current_file=0 

            for file in $files; do
                printf "\r🔁 Converting %d of %d TIFFs to JPGs\033[K" "$((++current_file))" "$total_files"
                convert "$file" -flatten "${file%.tif}.jpg" 2>/dev/null
                [[ $? -ne 0 ]] && printf "\n❗ Error converting $file\n"
            done
            echo -e "\n✅ TIFF to JPG conversion complete."
            ;;

        [Cc])
            # Normalize file extensions
            for file in "$BASE_DIR"/*.jpeg; do
                mv "$file" "${file%.jpeg}.jpg" 2>/dev/null
            done
            echo 🦩 Extensions renamed to .jpg if needed.

            files="$BASE_DIR"/*.jpg
            total_files=$(ls -1 $files 2>/dev/null | wc -l)
            current_file=0

            for file in $files; do
                printf "\r🔁 Cropping %d of %d JPGs\033[K" "$((++current_file))" "$total_files"
                mogrify -bordercolor white -fuzz 3% -trim +repage -border 8x8 "$file" 2>/dev/null
                [[ $? -ne 0 ]] && printf "\n❗ Error cropping $file\n"
            done 
            echo -e "\n🌻 JPG cropping complete."
            ;;

        [Mm])
            files="$BASE_DIR"/*.jpg
            total_files=$(ls -1 $files 2>/dev/null | wc -l)
            current_file=0

            for file in $files; do
                printf "\r🔁 Adding margin to %d of %d JPGs\033[K" "$((++current_file))" "$total_files"
                convert "$file" -bordercolor white -border 40x40 "$file" 2>/dev/null
                [[ $? -ne 0 ]] && printf "\n❗ Error adding margin to $file\n"
            done        
            echo -e "\n🌲 Margin added to JPGs."
            ;;

        [Rr])
            files="$BASE_DIR"/*.jpg
            total_files=$(ls -1 $files 2>/dev/null | wc -l)
            current_file=0

            for file in $files; do
                printf "\r🔁 Resizing %d of %d JPGs\033[K" "$((++current_file))" "$total_files"

                # Create a mid-size version (800px max) next to original
                cp -n "$file" "${file%.*}_mid.jpg"
                mogrify -resize 800x800\> "${file%.*}_mid.jpg" 2>/dev/null

                # Resize original to max 3000px
                mogrify -resize 3000x3000\> "$file" 2>/dev/null

                [[ $? -ne 0 ]] && printf "\n❗ Error resizing $file\n"
            done        
            echo -e "\n🌲 Resizing complete: 3000px fulls & 800px mids created."
            ;;

        [Qq])
            echo 🦩 Quitting now.
            ;;
        *)
            echo -e "Invalid selection.
            \nPress 'j' to convert .tif to .jpg
            \nPress 'c' to autocrop .jpg files
            \nPress 'm' to add 40px margin to .jpg files
            \nPress 'r' to resize .jpg files and create mids
            \nPress 'q' to quit"
            ;;
    esac
done
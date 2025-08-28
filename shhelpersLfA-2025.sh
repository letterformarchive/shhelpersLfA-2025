#!/bin/bash -x

echo "Greetings $USER 🦋"

### Set to folder containing images to process
BASE_DIR="/PATH/TO/IMAGES"

echo "This script allows you to do multiple shell tasks in one! 
Press 'j' to make jps from tifs in tiff-process folder 
Press 'c' to autocrop jpgs in jpg-process folder
Press 'm' to add 40px margin to fullsize jpgs
Press 'r' to resize jpgs and make mids in cropped folder
Press 'q' to quit"

while [[ ! $REPLY =~ ^[Qq]$ ]]; do
    read -p "Please make a selection: " -n 1 -r
    echo

    case $REPLY in
        [Jj])
            mkdir -p "$BASE_DIR/tiff-process"
            files="$BASE_DIR/tiff-process/*.tif"
            total_files=$(ls -1 $files 2>/dev/null | wc -l)
            current_file=0 

            for file in $files; do
                printf "\r🔁🔁 Converting %d of %d TIFFs to JPGs\033[K" "$((++current_file))" "$total_files"
                convert "$file" -flatten "${file%.tif}.jpg" 2>/dev/null
                [[ $? -ne 0 ]] && printf "\n❗❗Error converting $file\n"
            done

            if [[ -n $(ls "$BASE_DIR/tiff-process"/*.jpg 2>/dev/null) ]]; then
                mkdir -p "$BASE_DIR/jpg-process" && mv "$BASE_DIR/tiff-process"/*.jpg "$BASE_DIR/jpg-process/"
                echo    
                echo ⭐ Jpgs created, see jpg-process folder.
            else
                echo ❌ No JPGs were created.
            fi
            ;;

        [Cc])
            for file in "$BASE_DIR/jpg-process"/*; do
                mv "$file" "${file/.jpeg/.jpg}" 2>/dev/null
            done
            echo 🦩 Extensions renamed to .jpg.
            mkdir -p "$BASE_DIR/cropped" && cp -R "$BASE_DIR/jpg-process"/*.jpg "$BASE_DIR/cropped/"
            echo 📁 Files copied and moved to cropped folder. 
            echo 🪨🔨 Now on to cropping! hold please ☺ 
            
            files="$BASE_DIR/cropped/*.jpg"
            total_files=$(ls -1 $files 2>/dev/null | wc -l)
            current_file=0

            for file in $files; do
                printf "\r🔁🔁 Cropping %d of %d jpgs\033[K" "$((++current_file))" "$total_files"
                mogrify -bordercolor white -fuzz 3% -trim +repage -border 8x8 "$file" 2>/dev/null
                [[ $? -ne 0 ]] && printf "\n❗❗Error cropping $file\n"
            done 
            echo
            echo 🌻 Cropping complete! 
            echo
            ;;

        [Mm])
            mkdir -p "$BASE_DIR/cropped-margin" && cp -R "$BASE_DIR/cropped"/*.jpg "$BASE_DIR/cropped-margin/"
            echo 🪟🔖 Now to add 40px margin, hold please 🌅 

            files="$BASE_DIR/cropped-margin/*.jpg"
            total_files=$(ls -1 $files 2>/dev/null | wc -l)
            current_file=0

            for file in $files; do
                printf "\r🔁🔁 Adjusting %d of %d jpgs\033[K" "$((++current_file))" "$total_files"
                convert "$file" -bordercolor white -border 40x40 "$file" 2>/dev/null
                [[ $? -ne 0 ]] && printf "\n❗❗Error adjusting margins on $file\n"
            done        
            echo -e "\n🌲 Images now include 40px margin. See cropped-margin folder for files\n"  
            ;;

        [Rr])
            mkdir -p "$BASE_DIR/oa" && cp -R "$BASE_DIR/cropped"/*.jpg "$BASE_DIR/oa/"
            echo 🪚🪵 Now on to downsizing, hold please 🐗

            files="$BASE_DIR/oa/*.jpg"
            total_files=$(ls -1 $files 2>/dev/null | wc -l)
            current_file=0

            for file in $files; do
                printf "\r🔁🔁 Resizing %d of %d jpgs\033[K" "$((++current_file))" "$total_files"
                mogrify -resize 3000x3000\> "$file" 2>/dev/null
                [[ $? -ne 0 ]] && printf "\n❗❗Error resizing $file\n"
            done        
            echo
            echo 🌲 All images resized at 3000px. See oa folder for files 
            echo 
            ;;
        [Qq])
            echo 🦩 Quitting now 
            ;;
        *)
            echo -e "Invalid selection. 
            \nPress 'j' to make jps from tifs in tiff-process folder 
            \nPress 'c' to autocrop jps in jpg-process folder
            \nPress 'm' to add 40px margin to fullsize jpgs
            \nPress 'r' to resize jpgs
            \nPress 'q' to quit"
            ;;
    esac
done

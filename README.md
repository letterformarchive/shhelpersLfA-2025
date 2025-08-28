# shhelpersLfA-2025
 Updated shell helpers for image processing tasks around Letterform Archive

# How It Works

This script uses bash to execute various image processing tasks using command line user input to customize each task. 

After run, the script continues to prompt the user until "q" character is pressed: 

    $ while [[ ! $REPLY =~ ^[Qq]$ ]] 

Each letter corresponds to a different process that is further documented below: 

* `j`: **Make Jpgs** 
    * Tifs in crop folder are turned into jpgs.
* `c`: **Autocrop** 
    * Jpgs in crop folder are copied to qc folder and then background is cropped out
* `m`: **Margins**
    * Add 40 px margins around the outside of cropped fullsize jpgs.  
* `r`: **Resize & Mids** 
    * Jpgs in qc folder resized to 3000px on longest side, 800px mid copies created, and files moved to processed folder.   
* `q`: **Quit** 
    * Breaks while loop and quits the script

For example, if `j` is pressed: 

```
if [[ $REPLY =~ ^[Jj]$ ]]
then
    # make tiff-process folder if does not already exist
    mkdir -p ~/Desktop/helpers/tiff-process
    cd ~/Desktop/helpers/tiff-process/

    echo 🪄creating jpgs, hold please 🚀

    # create flattened jpgs from tiffs
    mogrify -flatten -format jpg *.tif

    # copy files from source to destination, make jpg-process folder if it doesn't exist
    mkdir -p ~/Desktop/helpers/jpg-process && mv ~/Desktop/helpers/tiff-process/*.jpg ~/Desktop/helpers/jpg-process/

    echo ⭐jpgs created, see jpg-process folder. 
```

## Make Jpgs

This script utilizes ImageMagick's mogrify command to create jpg copies of tif files. 

    $ mogrify -flatten -format jpg *.tif

## Autocrop

This script also uses mogrify to crop a jpg file and overwrite it. Since the masked background can be visually distinguished from the object, this became the way to custom crop each image based on color difference rather than size.

    $ mogrify -bordercolor white -fuzz 3% -trim +repage *.jpg

Various aspects of the code will be highlighted below.

`-bordercolor white:` Sets the border color to be trimmed to white.

`-fuzz 3%:` Adjusts what is considered white based on a percentage.

`-trim:` Crop function.

`+repage:` Resets the image virtual canvas to the actual image.

`*.jpg:` Sets the file format as jpg

`-resize 3000x3000\>:` Resizes image to 3000 pixels on longest size, does not change aspect ratio, does not upscale. 

Additional mogrify arguments to consider: 

`-deskew 10%:` Deskews the image.

`-type TrueColor:` Forces image to be saved as a full color RGB.

`-strip:` Removes xmp file in instances where thumbnail is not adjusting to cropped image.  

Depending on which program is used to convert from tiff to jpg, some produce a file extension of '.jpg' and others '.jpeg'. The for loop below changes all .jpeg extensions to .jpg so they can be ingested into LfA's [Online Archive](oa.letterformarchive.org). 

    for file in ~/Desktop/helpers/jpg-process/*
        do
    mv "$file" "${file/.jpeg/.jpg}"
    done

## Margins
Create margins around cropped images for better edge visibility and increase usefulness in other Archive domains such as Publishing. 

## Resize 

This script also uses bash to prepare jpg files for the Online Archive. To do this, it performs a couple tasks:

1. Resize existing jpgs to 3000 pixels on the longest side. 

       $ mogrify -resize 3000x3000\> *.jpg  
   
2. Moves files to the `oa` folder when editing complete. 

# Usage (Mac Only)

## Script Setup

* Copy repository to local machine using Terminal.

       $ cd /PATH/TO/WHERE/YOU/STORE/SCRIPTS

       $ git clone https://github.com/letterformarchive/shhelpersLfA-2025

* OR, if repository was previously downloaded, navigate to repo folder and pull updated repo using Terminal.  

       $ cd /PATH/TO/THIS/REPO 
    
       $ git pull

## Run Script

1. Change `BASE_DIR` path in script to match the folder with images you would like to process. 

2. Open Terminal and run `helpersLfA-2025.sh`: 

        $ sh /PATH/TO/SCRIPT/helpersLfA-2025.sh 

3. When prompted, enter a character in Terminal based on the process you would first like to run:

* `j`: **Make Jpgs** 
* `c`: **Autocrop** 
* `r`: **Resize & Mids**
* `q`: **Quit** 

4. Continue to select a process until you would like to quit.  
    
# Background 
UPDATE (2025): Unlike the previous shhelpersLfA script, which created a pipeline to process images via a nested folder structure, this script reflects different needs at the Archive to process batches of images in various ways in the same folder. Please note that ALL images that match the filetype of the requested action will be processed. Please move previously-processed files to avoid duplicate work. 


I developed this scripts while working at Letterform Archive in San Francisco, CA to assist with automating small tasks and streamline existing workflows. It is an extension of a script from a previous project at Oakland Museum of California. 

#!/bin/bash
# ------------------------------------------------------------------
#   [Author]    Matthias De Vriendt
#               https://github.com/matthiasdv
#
#               This script prepares .jpeg files for archiving.
#                   * First files are resized using ImageMagick
#                   * Then files are compressed using jpegoptim 
#                   * Lastly a comparison of filesize is made
#   Dependency:
#       https://github.com/ImageMagick/ImageMagick
#       https://github.com/tjko/jpegoptim
# ------------------------------------------------------------------

# ------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------
function printSize {
    # print the size of a dir 
    size=$(du -h -d 0 $1)
    size=${size%%/*}

    echo $size
}


# Target directory
targetDir=$1

# maximum width in pixels
maxWidth=$2

# print initial directory size 
echo Inital size is $(printSize $targetDir)...

# scale down 
echo Resizing images...
mogrify -resize $2 "$targetDir/*"  # no trailing slash on targetDir!
echo Resizing done. 

# print directory size after scaling
echo Directory size after resizing is $(printSize $targetDir)...

# compress files
echo compressing images
find $targetDir -iname "*.jpg" -exec jpegoptim -m$3 -o -p   {} \;
echo compressing done.

# print directory size after compressing
echo Final directory size is $(printSize $targetDir)

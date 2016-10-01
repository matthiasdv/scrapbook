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


# ------------------------------------------------------------------
# Options
# ------------------------------------------------------------------
while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -s|--SOURCE)
    SOURCE="$2"
    shift # past argument
    ;;
    -t|--target)
    TARGET="$2"
    shift # past argument
    ;;
    -q|--quality)
    QUALITY="$2"
    shift # past argument
    ;;
    -r|--resolution)
    SIZE="$2"
    shift # past argument
    ;;
    --default)
    DEFAULT=YES
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

QUALITY="${QUALITY}"
SIZE="${SIZE}"
SOURCE="${SOURCE}"
TARGET="${TARGET}"

# expand file paths
mkdir $TARGET
ORG_DIR=$(cd $SOURCE; pwd)
TRG_DIR=$(cd $TARGET; pwd)

# copy files
echo copying files to $TRG_DIR...
cp -R $ORG_DIR/* $TRG_DIR

# maximum width in pixels
maxWidth=$2

# print initial directory size 
echo Inital size is $(printSize $ORG_DIR)...
echo $ORG_DIR

# scale down 
echo Resizing images...
mogrify -strip -interlace Plane -resize  $SIZE "$TRG_DIR/*"  -quality 100 # no trailing slash on SOURCE!
echo Resizing done. 

# print directory size after scaling
echo Directory size after resizing is $(printSize $ORG_DIR)...

# compress files
echo compressing images...
find $TRG_DIR -iname "*.jpg" -exec jpegoptim -m$QUALITY -o -p   {} \;
echo compressing done.

# print directory size after compressing
echo Final directory size is $(printSize $TRG_DIR)

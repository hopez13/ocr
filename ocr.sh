#!/bin/bash

# Set logging level and format
LOG_LEVEL="INFO"
LOG_FORMAT="%(asctime)s - %(levelname)s - %(message)s"

# Define a function to log messages
log() {
  local level="$1"
  local message="$2"
  if [ "$level" = "$LOG_LEVEL" ] || [ "$level" = "ERROR" ]; then
    printf "$LOG_FORMAT\n" "$(date)" "$level" "$message"
  fi
}

# Define the URL of the PDF file
URL="https://archive.org/download/the-srimad-devi-bhagawatam-swami-vijnanananda/The%20Srimad%20Devi%20Bhagawatam%20-%20Swami%20Vijnanananda.pdf"

# Download the PDF file using curl
curl -o ocr.pdf "$URL"

# Check the status code of the download
status=$?
if [ $status -eq 0 ]; then
  log "INFO" "Successfully downloaded the PDF file from $URL"
else
  log "ERROR" "Could not download the PDF file from $URL. Status code: $status"
  exit 1
fi

# Convert the PDF file into images using ImageMagick
convert -density 300 ocr.pdf -depth 8 -strip -background white -alpha off ocr.png

# Check the status code of the conversion
status=$?
if [ $status -eq 0 ]; then
  log "INFO" "Successfully converted the PDF file into images"
else
  log "ERROR" "Could not convert the PDF file into images. Status code: $status"
  exit 1
fi

# Create an empty output PDF file
touch output.pdf

# Loop through the images and preprocess them for OCR using ImageMagick
for image in ocr*.png; do
  # Get the page number from the image name
  page=${image#ocr-}
  page=${page%.png}

  # Log the processing of the page
  log "INFO" "Processing page $page"

  # Preprocess the image for OCR using ImageMagick
  convert "$image" -colorspace gray -threshold 50% -morphology open diamond:1 -deskew 40% -density 300 "$image"

  # Check the status code of the preprocessing
  status=$?
  if [ $status -eq 0 ]; then
    log "INFO" "Finished preprocessing page $page"
  else
    log "ERROR" "Could not preprocess page $page. Status code: $status"
    exit 1
  fi

  # Convert the image to PDF using tesseract-ocr
  tesseract "$image" "$image" -l eng pdf

  # Check the status code of the conversion
  status=$?
  if [ $status -eq 0 ]; then
    log "INFO" "Finished converting page $page to PDF"
  else
    log "ERROR" "Could not convert page $page to PDF. Status code: $status"
    exit 1
  fi

  # Append the PDF file to the output PDF file
  pdftk output.pdf "$image".pdf cat output output.pdf
done

# Log the saving of the output PDF file
log "INFO" "Saved the output PDF file as output.pdf"
#!/bin/bash

# Set logging level and format
LOG_LEVEL="INFO"
LOG_FORMAT="%(asctime)s - %(levelname)s - %(message)s"

# Define a function to log messages
log() {
  local level="$1"
  local message="$2"
  if [ "$level" = "$LOG_LEVEL" ] || [ "$level" = "ERROR" ]; then
    printf "$LOG_FORMAT\n" "$(date)" "$level" "$message"
  fi
}

# Define the URL of the PDF file
URL="https://archive.org/download/the-srimad-devi-bhagawatam-swami-vijnanananda/The%20Srimad%20Devi%20Bhagawatam%20-%20Swami%20Vijnanananda.pdf"

# Download the PDF file using curl
curl -o ocr.pdf "$URL"

# Check the status code of the download
status=$?
if [ $status -eq 0 ]; then
  log "INFO" "Successfully downloaded the PDF file from $URL"
else
  log "ERROR" "Could not download the PDF file from $URL. Status code: $status"
  exit 1
fi

# Convert the PDF file into images using ImageMagick
convert -density 300 ocr.pdf -depth 8 -strip -background white -alpha off ocr.png

# Check the status code of the conversion
status=$?
if [ $status -eq 0 ]; then
  log "INFO" "Successfully converted the PDF file into images"
else
  log "ERROR" "Could not convert the PDF file into images. Status code: $status"
  exit 1
fi

# Create an empty output PDF file
touch output.pdf

# Loop through the images and preprocess them for OCR using ImageMagick
for image in ocr*.png; do
  # Get the page number from the image name
  page=${image#ocr-}
  page=${page%.png}

  # Log the processing of the page
  log "INFO" "Processing page $page"

  # Preprocess the image for OCR using ImageMagick
  convert "$image" -colorspace gray -threshold 50% -morphology open diamond:1 -deskew 40% -density 300 "$image"

  # Check the status code of the preprocessing
  status=$?
  if [ $status -eq 0 ]; then
    log "INFO" "Finished preprocessing page $page"
  else
    log "ERROR" "Could not preprocess page $page. Status code: $status"
    exit 1
  fi

  # Convert the image to PDF using tesseract-ocr
  tesseract "$image" "$image" -l eng pdf

  # Check the status code of the conversion
  status=$?
  if [ $status -eq 0 ]; then
    log "INFO" "Finished converting page $page to PDF"
  else
    log "ERROR" "Could not convert page $page to PDF. Status code: $status"
    exit 1
  fi

  # Append the PDF file to the output PDF file
  pdftk output.pdf "$image".pdf cat output output.pdf
done

# Log the saving of the output PDF file
log "INFO" "Saved the output PDF file as output.pdf"

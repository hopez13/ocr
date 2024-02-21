#!/bin/bash

log() {
  local level="$1"
  local message="$2"
  echo -e "$level: $message\n"
}

URL="https://archive.org/download/the-srimad-devi-bhagawatam-swami-vijnanananda/The%20Srimad%20Devi%20Bhagawatam%20-%20Swami%20Vijnanananda.pdf"

wget -O ocr.pdf "$URL"
if [ $? -eq 0 ]; then
  log "INFO" "Successfully downloaded the PDF file from $URL"
else
  log "ERROR" "Could not download the PDF file from $URL. Status code: $?"
  exit 1
fi

pdfimages -png -f 1 -l 10 ocr.pdf ocr
if [ $? -eq 0 ]; then
  log "INFO" "Successfully extracted images from the PDF file"
else
  log "ERROR" "Could not extract images from the PDF file. Status code: $?"
  exit 1
fi

# Initialize an empty array to store the converted PDF files
converted=()

# Loop through the extracted images and convert them to PDF using tesseract
for image in ocr*.png; do
  page=${image#ocr-}
  page=${page%.png}

  log "INFO" "Processing page $page"

  tesseract "$image" "$image" -l eng pdf

  if [ $? -eq 0 ]; then
    log "INFO" "Finished converting page $page to PDF"
    # Append the converted PDF file to the array
    converted+=("$image".pdf)
  else
    log "ERROR" "Could not convert page $page to PDF. Status code: $?"
    exit 1
  fi
done

# Make a single PDF file from the converted PDF files using pdftk
pdftk "${converted[@]}" cat output output.pdf
if [ $? -eq 0 ]; then
  log "INFO" "Saved the output PDF file as output.pdf"
else
  log "ERROR" "Could not make a single PDF file from the converted PDF files. Status code: $?"
  exit 1
fi

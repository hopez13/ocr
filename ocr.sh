#!/bin/bash

log() {
  local level="$1"
  local message="$2"
  printf "$level" "$message"
}

URL="https://archive.org/download/the-srimad-devi-bhagawatam-swami-vijnanananda/The%20Srimad%20Devi%20Bhagawatam%20-%20Swami%20Vijnanananda.pdf"

wget -O ocr.pdf "$URL"
if [ $? -eq 0 ]; then
  log "INFO" "Successfully downloaded the PDF file from $URL\n"
else
  log "ERROR" "Could not download the PDF file from $URL. Status code: $?\n"
  exit 1
fi

pdfimages -png -f 1 -l 10 ocr.pdf ocr
if [ $? -eq 0 ]; then
  log "INFO" "Successfully extracted images from the PDF file\n"
else
  log "ERROR" "Could not extract images from the PDF file. Status code: $?\n"
  exit 1
fi

touch output.pdf

for image in ocr*.png; do
  page=${image#ocr-}
  page=${page%.png}

  log "INFO" "Processing page $page\n"

  tesseract "$image" "$image" -l eng pdf

  if [ $? -eq 0 ]; then
    log "INFO" "Finished converting page $page to PDF\n"
  else
    log "ERROR" "Could not convert page $page to PDF. Status code: $?\n"
    exit 1
  fi

  pdftk output.pdf "$image".pdf cat output output.pdf
done

log "INFO" "Saved the output PDF file as output.pdf\n"

#!/bin/bash

log() {
  local level="$1"
  local message="$2"
  printf "$level" "$message"
}

URL="https://archive.org/download/the-srimad-devi-bhagawatam-swami-vijnanananda/The%20Srimad%20Devi%20Bhagawatam%20-%20Swami%20Vijnanananda.pdf"

curl -o ocr.pdf "$URL" && log "INFO" "Successfully downloaded the PDF file from $URL" || { log "ERROR" "Could not download the PDF file from $URL. Status code: $?" ; exit 1 ; }

pdfimages -png -f 1 -l 10 ocr.pdf ocr && log "INFO" "Successfully extracted images from the PDF file" || { log "ERROR" "Could not extract images from the PDF file. Status code: $?" ; exit 1 ; }


touch output.pdf

for image in ocr*.png; do
  page=${image#ocr-}
  page=${page%.png}

  log "INFO" "Processing page $page"

  tesseract "$image" "$image" -l eng pdf

  status=$?
  if [ $status -eq 0 ]; then
    log "INFO" "Finished converting page $page to PDF"
  else
    log "ERROR" "Could not convert page $page to PDF. Status code: $status"
    exit 1
  fi

  pdftk output.pdf "$image".pdf cat output output.pdf
done

log "INFO" "Saved the output PDF file as output.pdf"

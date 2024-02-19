import pytesseract, os, requests
from pdf2image import convert_from_path
import logging
logging.basicConfig(level=logging.INFO,format="%(asctime)s - %(levelname)s - %(message)s")
URL="https://archive.org/download/the-srimad-devi-bhagawatam-swami-vijnanananda/The%20Srimad%20Devi%20Bhagawatam%20-%20Swami%20Vijnanananda.pdf"
response=requests.get(URL)
if response.status_code==200:
    logging.info("Successfully downloaded the PDF file from %s",URL)
    open("ocr.pdf","wb").write(response.content)
    logging.info("Successfully opened the file ocr.pdf")
    images=convert_from_path("ocr.pdf", first_page=1, last_page=13)
    logging.info("Successfully converted the PDF file into images")
    with open("output.pdf", "wb") as f: # open a binary file for writing
        for i,image in enumerate(images):
            logging.info("Processing page %d",i+1)
            pdf = pytesseract.image_to_pdf_or_hocr(image, extension='pdf') # get the PDF output
            f.write(pdf) # write the PDF output to the file
            logging.info("Finished processing page %d",i+1)
    logging.info("Saved the output PDF file as output.pdf")
else:
    logging.error("Could not download the PDF file from %s. Status code: %d",URL,response.status_code)
                         

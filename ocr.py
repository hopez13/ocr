import pytesseract
from pdf2image import convert_from_path
from reportlab.pdfgen import canvas
import os
import requests
import logging 

logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

def print_progress(progress):
    print(f"Progress: {progress}%")

URL = os.environ["URL"]
response = requests.get(URL)

if response.status_code == 200:
    logging.info("Successfully downloaded the PDF file from %s", URL) # Log the successful download
    open("ocr.pdf", "wb").write(response.content)
    images = convert_from_path("ocr.pdf")
    c = canvas.Canvas("output.pdf")

    for i, image in enumerate(images):
        logging.info("Processing page %d", i+1) # Log the start of processing each page
        text = pytesseract.image_to_string(image, progress_callback=print_progress)
        c.drawString(10, 800, f"Page {i+1}:")
        c.drawCentredString(300, 750, text)
        c.showPage()
        logging.info("Finished processing page %d", i+1) # Log the end of processing each page

    c.save()
    logging.info("Saved the output PDF file as output.pdf") # Log the successful saving
else:
    logging.error("Could not download the PDF file from %s. Status code: %d", URL, response.status_code) # Log the error message

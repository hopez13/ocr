import pytesseract,os,requests
from pdf2image import convert_from_path
from reportlab.pdfgen import canvas
import logging
logging.basicConfig(level=logging.INFO,format="%(asctime)s - %(levelname)s - %(message)s")
def print_progress(progress):print(f"Progress: {progress}%")
URL=os.environ["URL"]
response=requests.get(URL)
if response.status_code==200:
    logging.info("Successfully downloaded the PDF file from %s",URL)
    open("ocr.pdf","wb").write(response.content)
    logging.info("Successfully opened the file ocr.pdf")
    images=convert_from_path("ocr.pdf")
    logging.info("Successfully converted the PDF file into images")
    c=canvas.Canvas("output.pdf")
    for i,image in enumerate(images):
        logging.info("Processing page %d",i+1)
        text=pytesseract.image_to_string(image,progress_callback=print_progress)
        c.drawString(10,800,f"Page {i+1}:")
        c.drawCentredString(300,750,text)
        c.showPage()
        logging.info("Finished processing page %d",i+1)
    c.save()
    logging.info("Saved the output PDF file as output.pdf")
else:
    logging.error("Could not download the PDF file from %s. Status code: %d",URL,response.status_code)

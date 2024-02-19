import pytesseract,os,requests
from pdf2image import convert_from_path
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4 # import A4 constant
from reportlab.platypus import Paragraph # import Paragraph class
from reportlab.lib.styles import getSampleStyleSheet # import style sheet
import logging
logging.basicConfig(level=logging.INFO,format="%(asctime)s - %(levelname)s - %(message)s")
URL="https://archive.org/download/the-srimad-devi-bhagawatam-swami-vijnanananda/The%20Srimad%20Devi%20Bhagawatam%20-%20Swami%20Vijnanananda.pdf"
response=requests.get(URL)
if response.status_code==200:
    logging.info("Successfully downloaded the PDF file from %s",URL)
    open("ocr.pdf","wb").write(response.content)
    logging.info("Successfully opened the file ocr.pdf")
    images=convert_from_path("ocr.pdf", first_page=1, last_page=101)
    logging.info("Successfully converted the PDF file into images")
    c=canvas.Canvas("output.pdf", pagesize=A4) # pass pagesize argument
    styles = getSampleStyleSheet() # get a sample style sheet
    for i,image in enumerate(images):
        logging.info("Processing page %d",i+1)
        text=pytesseract.image_to_string(image)
        p = Paragraph(f"Page {i+1}:<br/>{text}", styles["Normal"]) # create a paragraph object with text and style
        p.wrapOn(c, A4[0]-20, A4[1]-20) # wrap the paragraph to fit the page size
        p.drawOn(c, 10, 10) # draw the paragraph on the canvas at a position
        c.showPage()
        logging.info("Finished processing page %d",i+1)
    c.save()
    logging.info("Saved the output PDF file as output.pdf")
else:
    logging.error("Could not download the PDF file from %s. Status code: %d",URL,response.status_code)
    

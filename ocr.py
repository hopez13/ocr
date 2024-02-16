import pytesseract
from pdf2image import convert_from_path
from reportlab.pdfgen import canvas
import os
import requests

def print_progress(progress):
    print(f"Progress: {progress}%")

URL = os.environ["URL"]
response = requests.get(URL)

if response.status_code == 200:
    open("ocr.pdf", "wb").write(response.content)
    images = convert_from_path("ocr.pdf")
    c = canvas.Canvas("output.pdf")

    for i, image in enumerate(images):
        text = pytesseract.image_to_string(image, progress_callback=print_progress)
        c.drawString(10, 800, f"Page {i+1}:")
        c.drawCentredString(300, 750, text)
        c.showPage()

    c.save()
else:
    print(f"Error: Could not download the PDF file from {URL}. Status code: {response.status_code}")
    

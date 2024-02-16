import requests
from pdf2image import convert_from_path
from reportlab.pdfgen import canvas
import os

# Get the URL of the PDF file from the environment variable
URL = os.environ["URL"]

# Download the PDF file and save it as ocr.pdf in the current directory
response = requests.get(URL)
open("ocr.pdf", "wb").write(response.content)

# Convert the PDF file into images, one for each page
images = convert_from_path("ocr.pdf")

# Initialize a PDF canvas object
c = canvas.Canvas("output.pdf")

# Loop through the images and extract the text using pytesseract
for i, image in enumerate(images):
    # Get the text from the image
    text = pytesseract.image_to_string(image)
    
    # Draw the text on the PDF canvas
    c.drawString(10, 800, f"Page {i+1}:")
    c.drawCentredString(300, 750, text)
    
    # Add a new page for the next image
    c.showPage()

# Save the PDF file
c.save()
  

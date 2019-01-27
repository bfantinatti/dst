#!/home/fabio/anaconda3/bin/python3.6
from PIL import Image
import pytesseract as pyt
import sys

# pip install pytesseract


def image2txt(In, Out):

    # Open image object using PIL
    image = Image.open(In)

    # f = open(Out, "x")
    f = open(Out, "w+")
    f.write(pyt.image_to_string(image, "eng"))
    f.writelines("\n" * 5)
    f.writelines("Made with image2text by Fábio Patroni")
    f.close()

    print("Done!\n\nYour file is saved in '%s'" % (Out))


if __name__ == "__main__":
    # check flags order
    if ((str(sys.argv[1]) == '-i') or (str(sys.argv[1]) == '--input')):
        Input = str(sys.argv[2])
        Output = str(sys.argv[4])
    elif ((str(sys.argv[1]) == '-o') or (str(sys.argv[1]) == '--output')):
        Input = str(sys.argv[4])
        Output = str(sys.argv[2])
    elif len(sys.argv) != 3:
        sys.exit("Usage: python3 image2text.py -i [INPUT] -o [OUTPUT]")
    else:
        print("\nError!!!")
        sys.exit("Use '-i' or '--input' and '-o' or '--output' as flags!\n")

    image2txt(In=Input, Out=Output)

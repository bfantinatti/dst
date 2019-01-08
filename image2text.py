#!/home/fabio/anaconda3/bin/python3.6
from PIL import Image
import pytesseract as pyt
import sys

# pip install pytesseract


def image2txt(Inp, Out):

    # Open image object using PIL
    image = Image.open(Inp)

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
    else:
        print("\nError!!!")
        sys.exit("Use '-i' or '--input' and '-o' or '--out' as flags!\n")

    image2txt(Inp=Input, Out=Output)

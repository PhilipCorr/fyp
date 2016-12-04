import os 
from PIL import Image 
import numpy as np 
  
#Convert png files to binary files  
#Images are in greyscale format 
image_dir  = "/home/phil/Repos/cnn-gesture-recognition/db/images/"
 
label_bytes = [] 
stream = []
listOfFiles = os.listdir(image_dir)
print(listOfFiles)
for i in range(len(listOfFiles)):
    im = Image.open(image_dir + 'image'+ str(i).zfill(4) + '.png')
    npImage = (np.array(im,dtype=np.uint8)) 
    stream.extend(npImage) 
 
out = np.array(stream,dtype=np.uint8) 
out.tofile('/home/phil/Repos/cnn-gesture-recognition/db/bin/generated/data.bin') 

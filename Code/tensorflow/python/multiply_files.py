import os 
from PIL import Image 
import numpy as np 
 
# Convert png files to binary files 
# Images are in greyscale format 
# duplicate image 100 times and append to binary file 
image_directory = "/home/phil/Repos/cnn-gesture-recognition/db/100image/" 
 
label_bytes = [] 
stream = [] 
im = Image.open(image_directory + 'image0000.png')  # 'image'+ str(i).zfill(4) + '.png' 
npImage = (np.array(im, dtype=np.uint8)) 
 
for i in range(0, 100): 
    stream.extend(npImage) 
 
out = np.array(stream, dtype=np.uint8) 
out.tofile('/home/phil/Repos/cnn-gesture-recognition/db/bin/generated/data.bin') 

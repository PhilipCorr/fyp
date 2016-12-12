import os 
from PIL import Image 
import numpy as np
import matplotlib.pyplot as plt


#Convert png files to binary files  
#Images are in greyscale format 
image_dir  = "/home/phil/Repos/cnn-gesture-recognition/db/images/"
 
label_bytes = [] 
stream = []
listOfFiles = os.listdir(image_dir)
print(listOfFiles)

before_im_file = Image.open(image_dir + listOfFiles[0])

before_im = (np.array(before_im_file, dtype=np.uint8))
#beforefig = plt.figure(1)
plt.imshow(before_im)
plt.show()

for i in range(len(listOfFiles)):
    im = Image.open(image_dir + 'image'+ str(i).zfill(4) + '.png')
    bw_im = im.convert('1') # convert image to black and white
    npImage = (np.array(bw_im,dtype=np.uint8))
    stream.extend(npImage) 

#afterfig = plt.figure(2)
plt.imshow(npImage)
plt.show()

out = np.array(stream,dtype=np.uint8) 
out.tofile('/home/phil/Repos/cnn-gesture-recognition/db/bin/generated/data.bin') 

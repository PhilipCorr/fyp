import os
from PIL import Image
import numpy as np
 
#Binary Files in Fixed Length bytes of Left,Right,Label 
#Images are in QVGA format (320*240*3)
#Binary output 76800 bits or 9600 bytes for each channel
left_image_indexes = "/home/kevin/Datasets/Office/leftcam/"
right_image_indexes = "/home/kevin/Datasets/Office/rightcam/"
label_image_indexes  = "/home/kevin/Datasets/Office/depth_map/"

label_bytes = []
stream = []
counter = 1
for i in range(1,1001):
	
	#Left Images
	left_im = Image.open(left_image_indexes + 'Image-'+ str(i).zfill(4) + '.png')
	left_im = (np.array(left_im,dtype=np.uint8))

	r_left = left_im[:,:,0].flatten()
	g_left = left_im[:,:,1].flatten()
	b_left = left_im[:,:,2].flatten()
	stream.extend(r_left)
	stream.extend(g_left)
	stream.extend(b_left)

    #Right Images
	right_im = Image.open(right_image_indexes + 'Image-'+ str(i).zfill(4) + '.png')
	right_im = (np.array(right_im,dtype=np.uint8))

	r_right = right_im[:,:,0].flatten()
	g_right = right_im[:,:,1].flatten()
	b_right = right_im[:,:,2].flatten()
	stream.extend(r_right)
	stream.extend(g_right)
	stream.extend(b_right)

    #Depth Images
	labels = Image.open(label_image_indexes + 'Image-'+ str(i).zfill(4) + '.png')
	labels = (np.array(labels,dtype=np.uint8))

	labels = labels.flatten()
	stream.extend(labels)

	if (i)%50==0:
		out = np.array(stream,dtype=np.uint8)
		print(counter)
		out.tofile('/home/kevin/MvScene/Bin_Files/Office/data_batch_'+ str(counter).zfill(2)+'.bin')
		stream = []	#clear stream
		counter +=1
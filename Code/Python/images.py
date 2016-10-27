import os, struct
from array import array as pyarray
import matplotlib.pyplot as plt
import numpy as np
import utilities

if __name__ == '__main__':
    image_array = utilities.load_mnist('training', None, None, False, None, True, False)

    # label
    image_labels = image_array[1]
    label = image_labels[0] # 5

    # image
    image_data = image_array[0]
    sample_set = image_data[0:4]
    sample = image_data[0]

    # logic
    concatenated = utilities.concatenate_images(sample_set, 1) # 0 = vertical, 1 = horizontal
    image_xy = utilities.image_to_xy(sample)

    # Plot
    plt.figure()
    plt.imshow(concatenated, cmap='Greys_r')

    # plt.figure()
    # plt.gca().invert_yaxis()
    # plt.plot(x, y, 'ob')
    #
    # plt.figure()
    # plt.gca().invert_yaxis()
    # plt.imshow(sample, cmap='Greys_r')
    # plt.plot(x, y, 'ob')


    plt.show()


    #smaller_sample = sample[::4,::4]
    #pyplot.imshow(sample)
    #pyplot.show()
    #print('start of sleep')
    #sleep(5)
    #print('end of sleep')

    #x = array([228, 122, 185, 120, 120, 196, 118, 118, 168, 212, 260, 168, 132])
    #y = array([129, 144, 140, 213, 233, 137, 298, 300, 285, 464, 312, 285, 440])

    #x_scaled = x*0.01
    #y_scaled = y*(-0.01)
    #
    #
    #fig = plt.figure(figsize=(2.8, 2.8))
    #
    #ax = fig.add_subplot(111)
    #ax.set_title('iPhone Screen')
    #plt.plot(sample, 'ro')

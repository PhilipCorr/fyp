import numpy as np
import matplotlib.pyplot as plt
import os, struct
from array import array as pyarray
from numpy import append, array, int8, uint8, zeros


if __name__ == '__main__':


    x = np.arange(35).reshape(5, 7)
    y = np.array([[5,0,1], [0,8,2], [1,2,0], [3,0,5], [0,1,0], [1,3,0], [0,5,6], [0,0,0]])
    z = np.array([
        [[1,2,3,4],[3,4,5,6]],
        [[5,6,7,8],[7,8,9,0]],
        [[9,0,1,2],[1,2,7,8]]
    ])
    zero = [1, 0, 2, 0, 4, 5, 6]

    print('data of x:\n %s\nshape of x: %s\n' % (x, x.shape))
    print('data of y:\n %s\nshape of y: %s\n' % (y, y.shape))
    print('data of z:\n %s\nshape of z: %s\n' % (z, z.shape))

    #print(x[0::4]) # start at 0th, end at end if blank, prints every 4th
    #print(y[0::2])
    print(x[1:5:2,::3])
    print(np.nonzero(y))
    # fig = plt.figure(figsize=(6, 5))
    # ax = fig.add_subplot(111)
    # ax.set_title('iPhone Screen')
    # plt.plot(x, 'ro')
    # plt.show()
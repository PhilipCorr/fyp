import numpy as np
import matplotlib.pyplot as plt

x = np.array([228, 122, 185, 120, 120, 196, 118, 118, 168, 212, 260, 168, 132])
y = np.array([129, 144, 140, 213, 233, 137, 298, 300, 285, 464, 312, 285, 440])

x_scaled = x*0.01 
y_scaled = y*0.01


fig = plt.figure(figsize=(6, 5))

#ax = fig.add_subplot(111)
#ax.set_title('iPhone Screen')
plt.plot(x_scaled,y_scaled, 'ro')
plt.show()
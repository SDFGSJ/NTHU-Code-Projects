#draw result on colab.
%matplotlib inline

import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.axes3d import Axes3D
import numpy as np
import math
from matplotlib.animation import FuncAnimation, PillowWriter 
import random


def set_object(R, T):
    # drawing
    for oo, mat in zip(objs, data):
        n = len(mat[0])
        # rotation 
        mat = np.dot(R, mat) + np.dot(T, np.ones((1,n)))
        # set the object    
        oo.set_data(mat[0], mat[1])
        oo.set_3d_properties(mat[2])
    return objs

def roll(i):
    phi = 2*i*math.pi/N
    #define the rotation matrix
    R = np.array([[1,       0,        0],
            [0, math.cos(phi), -math.sin(phi)], 
            [0, math.sin(phi), math.cos(phi)]]);
    
    m = len(data)
    T = np.zeros((m,1))     #an m*1 matrix with all numbers=0
    return set_object(R, T)

def yaw(i):
    phi = 2*i*math.pi/N
    # define the rotation matrix
    R = np.array([[math.cos(phi), -math.sin(phi), 0], 
            [math.sin(phi),  math.cos(phi), 0], 
            [0      ,        0, 1]]);
    
    m = len(data)
    T = np.zeros((m,1))     #an m*1 matrix with all numbers=0
    return set_object(R, T)

def pitch(i):
    phi = 2*i*math.pi/N
    #define the rotation matrix
    R = np.array([[math.cos(phi), 0, -math.sin(phi)], 
            [0      , 1,       0],
            [math.sin(phi), 0, math.cos(phi)]]);
    
    m = len(data)
    T = np.zeros((m,1))     #an m*1 matrix with all numbers=0
    ax.text(10, 10, 10, str(phi))
    return set_object(R, T)


def myMovie_basic(i):
    T = np.array([[xdata[i]], [ydata[i]], [xdata[i]]])
    R = np.eye(3) #3*3 identity matrix
    return set_object(R, T)

#myMovie1() is the code of (2)
def myMovie1(i): #this is the original version(yaw->pitch->roll)
    T = np.array([[xdata[i]], [ydata[i]], [xdata[i]]])
    
    # slip a circle into N equal angles
    phi = -2*math.pi*i/N
    theta = 2*math.pi*xdata[int(i+N/4)%N]/r/12
    
    
    # yaw
    R = np.array([[ math.cos(phi), -math.sin(phi), 0], 
            [ math.sin(phi),  math.cos(phi), 0], 
            [ 0,              0, 1]])
    
    # pitch
    R = np.dot(R, np.array([[math.cos(theta), 0, -math.sin(theta)], 
                 [0,         1,        0],
                 [math.sin(theta), 0, math.cos(theta)]]))
    
    # roll
    R = np.dot(R, np.array([ [1,       0,         0],
                  [0, math.cos(-phi), -math.sin(-phi)], 
                  [0, math.sin(-phi),  math.cos(-phi)]]))
    return set_object(R, T)



#myMovie2() is the code of (3)
def myMovie2(i): #change the multiplication order
    T = np.array([[xdata[i]], [ydata[i]], [xdata[i]]])

    # slip a circle into N equal angles
    phi = -2*math.pi*i/N
    theta = 2*math.pi*xdata[int(i+N/4)%N]/r/12
    
    
    # roll
    R = np.array([ [1,       0,         0],
             [0, math.cos(-phi), -math.sin(-phi)], 
             [0, math.sin(-phi),  math.cos(-phi)]])
    # pitch
    R = np.dot(R, np.array([[math.cos(theta), 0, -math.sin(theta)], 
                 [0,         1,        0],
                 [math.sin(theta), 0, math.cos(theta)]]))

    # yaw
    R = np.dot(R, np.array([[ math.cos(phi), -math.sin(phi), 0], 
                  [ math.sin(phi),  math.cos(phi), 0], 
                  [ 0,              0, 1]]))
    
    return set_object(R, T)


# -------------- main program starts here ----------------#
N = 100
fig = plt.gcf()
ax = Axes3D(fig, xlim=(-15, 15), ylim=(-15, 15), zlim=(-15, 15))


# data matrix
'''plane
M1 = np.array([[-3, -3, -2, -2, 2, 3, 2, -3], 
        [0, 0, 0, 0, 0, 0, 0, 0], 
        [-.5, .5, .5, 0, .5, 0, -.5, -.5]])
M2 = np.array([[-2.5, -2.5, -1.5, -1.5, -2.5], 
        [1, -1, -1, 1, 1], 
        [0, 0, 0, 0, 0]])
M3 = np.array([[-.5, -.5, 1, 1, -.5], 
        [3, -3, -3, 3, 3],
        [0, 0, 0, 0, 0]])'''

'''四面皆為三角形的三角錐'''
M1 = 3*np.array([[1,3,0,1],
        [0,0,1,0],
        [2,0,0,2]])
M2 = 3*np.array([[1,0,0,1], 
        [0,1,-1,0],
        [2,0,0,2]])
M3 = 3*np.array([[1,3,0,1],
        [0,0,-1,0],
        [2,0,0,2]])
M4 = 3*np.array([[3,0,0,3],
        [0,1,-1,0],
        [0,0,0,0]])

data = [M1, M2, M3, M4]

# create 3D objects list
O1, = ax.plot3D(M1[0], M1[1], M1[2])
O2, = ax.plot3D(M2[0], M2[1], M2[2])
O3, = ax.plot3D(M3[0], M3[1], M3[2])
O4, = ax.plot3D(M4[0], M4[1], M4[2])
objs = [O1, O2, O3, O4]


# trajectory data
t = np.arange(0,1,0.01) #[0, 0.01, 0.02, 0.03, ... , 0.98, 0.99]
r = 10
#xdata = r*np.sin(2*math.pi*t) #xdata has length of 100
#ydata = r*np.cos(2*math.pi*t)

#my own trajectory path
xdata = np.concatenate( (r*np.arange(0,2,0.02), r*np.arange(2,0,-0.02)) )
ydata = np.concatenate( (r*np.arange(-2,0,0.02), r*np.arange(0,-2,-0.02)) )

# basic rotations
#ani = FuncAnimation(fig, roll, frames=N, interval=10)
#ani = FuncAnimation(fig, yaw, frames=N, interval=10)
#ani = FuncAnimation(fig, pitch, frames=N, interval=10)

#original order,the code of (2)
#ani = FuncAnimation(fig, myMovie1, frames=len(xdata), interval=50)

#change multiplication order,the code of (3)
ani = FuncAnimation(fig, myMovie2, frames=len(xdata), interval=50)

# ani.save('/content/drive/My Drive/your_file_name', writer='imagemagick', fps=30)
#ani.save('/content/drive/My Drive/C2_change_order.gif', writer='imagemagick', fps=30)

# ---------------- for google colab user ----------------#
# If you didn't use colab, you can delete below 2 lines of code.
from IPython.display import HTML
HTML(ani.to_html5_video())
# ---------------- for google colab user ----------------#
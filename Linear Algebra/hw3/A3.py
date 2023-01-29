"""I use google colab to do this hw"""
import numpy as np
import matplotlib.image as img
import matplotlib.pyplot as plt
import math

# For question (4)
# you cannot use x to compute the center and the radius inside this function.
def dataSampling(x):
  #best=17~20
  tmp = [x[i*19] for i in range(len(x)//19)]
  return tmp

def circle(sp) :
    n=len(sp)
    A = np.zeros((n, 3))  #nx3 matrix with all 0
    b = np.zeros((n))
    for i in range(n):
        pt = sp[i]
        A[i, :] = [2.*pt[0], 2.*pt[1], 1]
        b[i] = pt[0]*pt[0]+pt[1]*pt[1]
    
    return A, b

def draw_circle(x, h, w) :
    center = [x[0], x[1]]
    radius = math.sqrt(x[2]+x[0]*x[0]+x[1]*x[1])  #r**2 = c3 + c1**2 + c2**2

    x_axis = np.linspace(0, w, 700) #Return evenly spaced numbers over a specified interval
    y_axis = np.linspace(0, h, 700)

    a, b = np.meshgrid(x_axis, y_axis)  #Return coordinate matrices from coordinate vectors.

    C = (a - x[0])*(a - x[0]) + (b - x[1])*(b - x[1]) - radius*radius
    return a, b, C

def eclipse(sp) :
    n=len(sp)
    # TODO: How many variable should use?
    A = np.zeros((n, 5))
    b = np.ones((n))
    for i in range(n):
        pt = sp[i]
        x = pt[0]
        y = pt[1]
        # TODO: eclipse formula here.
        A[i, :] = [x**2, x*y, y**2, x, y]

    return A, b

def draw_eclipse(x, h, w) :
    # plot the drawing and the fitted circle
    x_axis = np.linspace(0, w, 700)
    y_axis = np.linspace(0, h, 700)

    a, b = np.meshgrid(x_axis, y_axis)

    # TODO: eclipse formula here.
    C = x[0]*a*a + x[1]*a*b + x[2]*b*b + x[3]*a + x[4]*b - 1
    return a, b, C

"""# DO NOT MODIFY THE JUDGE CODE!!!"""

def judge_overlapping(points) :
    # calculate all sample point circle.
    A, b = circle(points)
    sol1 = np.linalg.lstsq(A, b, rcond=None)[0]
    x1 = sol1[0]
    y1 = sol1[1]
    r1 = math.sqrt(sol1[2]+x1**2+y1**2)

    sp = dataSampling(points)
    A, b = circle(sp)
    sol2 = np.linalg.lstsq(A, b, rcond=None)[0]
    x2 = sol2[0]
    y2 = sol2[1]
    r2 = math.sqrt(sol2[2]+x2**2+y2**2)

    d = math.sqrt((x1-x2)**2 + (y1-y2)**2)

    if r1+r2 <= d :
        # 1 point or no point
        return 0
    elif min(r1, r2) + d <= max(r1, r2) :
        # inner circle
        return (min(r1, r2)**2) / (max(r1, r2)**2)
   
    alpha = math.acos((r1**2 + d**2 - r2**2) / (2 * r1 * d))
    beta = math.acos((r2**2 + d**2 - r1**2) / (2 * r2 * d))

    overlapping = alpha * (r1**2) + beta * (r2**2) - (r1**2) * math.cos(alpha) * math.sin(alpha) - (r2**2) * math.cos(beta) * math.sin(beta)

    return overlapping / (max(r1**2, r2**2) * np.pi)

def judge_sampling(points) :
    old_points = list(points)
    all_point = len(points)
    sp = dataSampling(points)
    sp_len = 0
    for p in sp :
        for ss in old_points :
            if ss[0] == p[0] and ss[1] == p[1] :
                sp_len += 1
    
    if (old_points != points) :
        return 0

    return (all_point - sp_len) / all_point


def judge(points) :
    sample = judge_sampling(points)
    overlap = judge_overlapping(points)

    print("The score of this question is : ")
    print("20 * (0.3 * ? (Efficiency, need your report) + 0.3 * {:f} (correctness) + 0.4 * {:f} (sampling) ) =  ? + {:f}".format(overlap, sample, 20 * (0.3 * overlap + 0.4 * sample)))

def main(file, mode="circle") :
    # read image and get circle points
    im1 = img.imread(file)
    [h, w, c] = np.array(im1).shape

    points = [];
    for i in range(h):
        for j in range(w):
            if (all(im1[i,j,:])==0):
                points.append([i, j])

    # sampling data
    sp = points if len(points)<50 else dataSampling(points)

    if mode == "circle":
        # create matrix for fitting
        A, b = circle(sp)

        #Question(2): Normal equation implementation
        #x = np.linalg.solve((A.T)@A, (A.T)@b) #Solution to the normal equation

        #solve the least square problem
        [x, r, rank] = np.linalg.lstsq(A, b, rcond=None)[0:3] #Least-squares solution, residuals, rank

        a, b, C = draw_circle(x, h, w)
    elif mode == "eclipse":
        # create matrix for fitting
        A, b = eclipse(sp)

        # solve the least square problem
        [x, r, rank] = np.linalg.lstsq(A, b, rcond=None)[0:3]

        a, b, C = draw_eclipse(x, h, w)

    figure, axes = plt.subplots(1)
    plt.imshow(im1) 
    axes.contour(b, a, C, [0])
    axes.set_aspect(1)
    plt.savefig(file+'.output.png')
    plt.show()
    points = [];
    for i in range(h):
        for j in range(w):
            if (all(im1[i,j,:])==0):
                points.append([i, j])
    judge(points)
    print("="*50)


"""testcases here"""
files = ['case1.png', 'case2.png', 'case3.png']
#for f in files :
#    main('/content/drive/My Drive/' + f, mode="circle")
#    main('/content/drive/My Drive/' + f, mode="eclipse")

#main('/content/drive/My Drive/puddle.png', mode="circle") #residual=1138715
main('/content/drive/My Drive/test1.png', mode="circle")  #residual=26219
#main('/content/drive/My Drive/test2.png', mode="circle")
#main('/content/drive/My Drive/test3.png', mode="circle")
#main('/content/drive/My Drive/1dot.png', mode="circle")


#main('/content/drive/My Drive/eclipse.png', mode="eclipse")
#main('/content/drive/My Drive/eclipse1.png', mode="eclipse")
#main('/content/drive/My Drive/eclipse2.png', mode="eclipse")
#main('/content/drive/My Drive/eclipse3.png', mode="eclipse")

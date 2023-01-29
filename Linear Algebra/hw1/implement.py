import numpy as np
import itertools

#ax=b
equation = [[1,1,1,1]  ,
            [0,1,-1,0] ,
            [1,-1,-1,1],
            [-3,0,0,1] ,
            [5,3,2,3]  ]
const = [5,0,0,0,100]
target = [1,2,3,4]  #the target function


#(3)the algorithm to enumerate all intersection points
def EnumerateAll(eq,con,m,n):
    mylist=[]
    for com, cons in zip(itertools.combinations(eq,n), itertools.combinations(con,n)):
        print(np.linalg.solve(com,cons))
        mylist.append(np.linalg.solve(com,cons))
    return mylist


[m, n] = np.array(equation).shape
inter_point=EnumerateAll(equation,const,m,n)


#filter the valid points
valid_point=[]
for point in inter_point:
    sum=0   #the inner product of point and equation
    good=True   #whether this point should be appended or not

    for i in range(len(equation)):
        sum=np.inner(point,equation[i])
        if sum<const[i] and abs(sum-const[i])>1e-6: #sum should > const[i] and 1e-6 to prevent floating errors
            good=False
            break

    if good:
        valid_point.append(point)

#calculate the taget value
num=0   #record inner product
ans=-1
optimal=[]  #record the optimal point(solution)
for p in valid_point:
    num=np.inner(p,target)
    print('num=',num)
    if num>ans:
        ans=num
        optimal=p

print('the optimal target value is:',ans)
print('and this happens at point:\n',optimal)
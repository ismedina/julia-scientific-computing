import numpy as np
from time import time
import pandas as pd
def game_it(A):
    M, N = A.shape
    B = np.zeros((M, N), dtype=np.int64)
    for i in range(M):
        i_u = M-1 if i == 0   else i-1
        i_d = 0   if i == M-1 else i+1
        for j in range(N):
            j_l = N-1 if j == 0   else j-1
            j_r = 0   if j == N-1 else j+1
            
            sum_neigh = A[i_u,j_l] + A[i_u,j] + A[i_u,j_r] + A[i,j_l] + A[i,j_r] + A[i_d,j_l] + A[i_d,j] + A[i_d,j_r]
            
            if sum_neigh == 3 or (sum_neigh == 2 and A[i,j] == 1):
                B[i,j] = 1
    return B

n0 = 2
nf = 10

results = np.zeros((nf-n0+1,2))
ns = range(n0,nf+1)
print("N = ",end="")
for i,n in enumerate(ns):
    N = 2**n
    print(N,end=" ")
    A = np.random.randint(0,2,(N,N))
    ttotal = 0
    N_it = 0
    while ttotal < 5 and N_it < 10000:
        N_it += 1
        t0 = time()
        game_it(A)
        ttotal += time()-t0
    results[i,:] = (N, ttotal/N_it)
print("")
df = pd.DataFrame(results, columns=["N","seconds"])
df.to_csv("results_python.csv",index=False)

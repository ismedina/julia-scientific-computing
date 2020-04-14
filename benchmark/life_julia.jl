using BenchmarkTools: @benchmark
using Statistics: mean
using DataFrames
using CSV
include("../GameOfLife.jl")

n0 = 2
nf = 10
ns = n0:nf
results = zeros(nf-n0+1,2)
print("N = ")
for (i, n) in enumerate(ns)
    N = 2^n
    print("$N ")
    A = rand([0,1], N, N)
    bench = @benchmark game_it($A) # here A has to wear a `$` because something related to the @benchmark macro which gets discussed a lot in very unintelligile terms
    results[i,:] = [N, mean(bench.times)/1e9] # transform results from nanoseconds to seconds
end

df = DataFrame(N = results[:,1]) # we can set the Dataframe columns by giving them names...
df.seconds = results[:,2]        # ...or later by setting attributes. Cool!

# If you want to overwrite the results change the name for "results_julia.csv"
filename = "results_julia_own.csv"
CSV.write(filename,df)

using CSV

""" Game of Life iteration for the periodic boundary condition case"""
function game_it(A)
    M, N = size(A)
    j_l = j_r = 1
    i_u = i_d = 1
    B = zeros(Int64, M, N)
    for j in 1:N
        j == 1 ? j_l = N : j_l = j-1
        j == N ? j_r = 1 : j_r = j+1

        for i in 1:M
            i == 1 ? i_u = M : i_u = i-1
            i == M ? i_d = 1 : i_d = i+1

            sum_neigh = A[i_u,j_l] + A[i_u,j] + A[i_u,j_r] + A[i,j_l] + A[i,j_r] + A[i_d,j_l] + A[i_d,j] + A[i_d,j_r]
            if sum_neigh == 3 || (sum_neigh == 2 && A[i,j] == 1)
                B[i,j] = 1
            end
        end
    end
    return B
end

""" Game of Life iteration for the zero boundary condition case"""
function game_it_zero_bdry(A)
    M, N = size(A)
    B = zeros(Int64, M, N)
    for j in 2:N-1
        for i in 2:M-1
            sum_neigh = A[i-1,j-1] + A[i-1,j] + A[i-1,j+1] + A[i,j-1] + A[i,j+1] + A[i+1,j-1] + A[i+1,j] + A[i+1,j+1]
            if sum_neigh == 3 || (sum_neigh == 2 && A[i,j] == 1)
                B[i,j] = 1
            end
        end
    end
    return B
end


""" An auxiliary function for plotting the status of the game of life """
function plot_it(A)
    current_plot = heatmap(A,aspect_ratio=:equal,size = (400,400),grid=:none,axis = false,legend=nothing,color=:greys_r)

    # Plot a grid on top
    M, N = size(A)
    x1 = hcat([[0,N] for i in 0:M]...).+0.5
    y1 = hcat([[i,i] for i in 0:M]...).+0.5
    x2 = hcat([[i,i] for i in 0:N]...).+0.5
    y2 = hcat([[0,M] for i in 0:N]...).+0.5
    plot!(x1, y1,color=:lightgrey,linewidth=10/max(M,N))
    plot!(x2, y2,color=:lightgrey,linewidth=10/max(M,N))
    return current_plot
end


function gen_examples()

    # Check if the directory exists
    if !isdir("game_examples")
        mkdir("game_examples")
    end

    # Intro
    N = 35
    A = zeros(Int64, N, N)
    c = N ÷ 2+1
    A[[c-3,c+3],c-1:c+1] .= 1
    A[[c-2,c-1,c+1,c+2],[c-1,c+1]] .= 1
    CSV.write("game_examples/intro.csv", DataFrame(A))

    # Block
    A = zeros(Int64, 4, 4)
    A[2:3,2:3] .= 1
    CSV.write("game_examples/still_block.csv", DataFrame(A))

    # Hive
    A = zeros(Int64, 5, 6)
    A[[2,4],3:4] .= 1
    A[3,[2,5]] .= 1
    CSV.write("game_examples/still_hive.csv", DataFrame(A))

    # Tub
    A = zeros(Int64, 5, 5)
    A[[2,4],3] .= 1
    A[3,[2,4]] .= 1
    CSV.write("game_examples/still_tub.csv", DataFrame(A))

    # Blinker
    A = zeros(Int64, 5, 5)
    A[2:4,3] .= 1
    CSV.write("game_examples/osc_blinker.csv", DataFrame(A))

    # Beacon
    A = zeros(Int64, 6, 6)
    A[2:3,2:3] .= 1
    A[4:5,4:5] .= 1
    CSV.write("game_examples/osc_beacon.csv", DataFrame(A))

    # Ducks

    A = zeros(Int64, 7, 7)
    A[2,3:4] .= 1
    A[3,2:5] .= 1
    A[4,2:3] .= 1; A[4,5:6] .= 1;
    A[5,4:5] .= 1;

    function rotate(A)
        m, n = size(A)
        A = [A[n+1-i,j] for j in 1:m, i in 1:n]
        return A
    end

    N = 18
    B = zeros(Int64,N,N)
    B[1:7,1:7] .= A

    A = rotate(A); B[1:7,N-6:N] .= A[:,:];
    A = rotate(A); B[N-6:N,N-6:N] .= A[:,:]
    A = rotate(A); B[N-6:N,1:7] .= A[:,:]

    C = zeros(Int64, N+4, N+4)
    C[3:N+2,3:N+2] = B
    CSV.write("game_examples/final.csv", DataFrame(C))
end

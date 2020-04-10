import LinearAlgebra: norm

""" Gradient descent for multidimensional functions Stops when the gradient is smaller than `TOL`,
    or when the maximum number of iterations `maxiter` has been reached"""
function gradient_descent(f, Df, x; α = 0.1, TOL = 1e-10, maxiter = 1000, verbose = false)
    N_iter = 0
    grad = Df(x)

    xn = x
    fn = [f(x)]
    while (N_iter < maxiter) & (norm(grad) > TOL)
        x = x - α*grad

        xn = [xn x]
        fn = [fn f(x)]

        grad = Df(x)
        N_iter += 1

        if (N_iter % 100 == 0) & (verbose == true)# print progress
            fx = fn[end]
            println("Iter. $N_iter,\tx = $x,\tf(x) = $fx")
        end
    end

    return (xn', reshape(fn,:)) # to have the components in the columns
end

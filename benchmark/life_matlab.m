
n0 = 2;
nf = 10;
results = zeros(nf-n0+1,2);
ns = n0:nf;
for k= 1:(nf-n0+1)
    n = ns(k)
    N = 2^n;
    A = randi([0 1],N,N);
    ttotal = 0;
    N_it = 0;
    while ttotal <= 5 && N_it < 10000
        N_it = N_it + 1;
        tic
        game_it(A);
        ttotal = ttotal + toc;
    results(k,1:2) = [N, ttotal/N_it];
    end
end

writematrix(results,"results_matlab.csv")


%%
function B = game_it(A)
    [M, N] = size(A);
    B = zeros(M, N);
    for n = 1:N
        if n == 1
            n_l = N;
        else
            n_l = n-1;
        end
        if n == N
            n_r = 1;
        else
            n_r = n+1;
        end
        
        for m = 1:M
            if m == 1
                m_u = N;
            else
                m_u = m-1;
            end
            if m == N
                m_d = 1;
            else
                m_d = m+1;
            end
        
            sum_neigh = A(m_u,n_l) + A(m_u,n) + A(m_u,n_r) + A(m,n_l) + A(m,n_r) + A(m_d,n_l) + A(m_d,n) + A(m_d,n_r);
            if sum_neigh == 3 || (sum_neigh == 2 && A(m,n) == 1)
                B(m,n) = 1;
            end
        end
    end
end 
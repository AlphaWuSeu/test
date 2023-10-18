function D = resize_correct_flows(D1,N,M)

% resize correct flows D1 to desired size [N,M]

[N M];
[N_d1,M_d1] = size(D1);
N_f = floor(N_d1/N);
M_f = floor(M_d1/M);

D = zeros(N,M);

for n = 1:N
    for m = 1:M
        
        n_s = (n-1)*N_f+1;
        n_e = min(n*N_f,N_d1);
        m_s = (m-1)*M_f+1;
        m_e = min(m*M_f,M_d1);  
        
        D(n,m) = mean(mean(D1(n_s:n_e,m_s:m_e)));            
        
    end;
end;
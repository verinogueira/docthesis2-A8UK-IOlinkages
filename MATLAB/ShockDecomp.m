% This function calculates each order of the shock decomposition
% it is used in the decomposition of all shocks
% zeroth order corresponds to the shock vector
function Shock = ShockDecomp(n, N, gamma, shares)
    if n==0
    Shock = eye(N)*shares;
    end
     
        part=0;
    for i = 1:n
        part = part + gamma'^i;
    end
     Shock = (eye(N) + part) * shares;
end
function k = ukrivljenost(P1, P2)
    % Izračuna ukrivljenost krivulje.
    % P1 in P2 sta prvi in drugi odvod.
    k = (P1(1) * P2(2) - P1(2) * P2(1)) / norm(P1)^3;
end
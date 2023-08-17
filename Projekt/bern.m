function b=bern(n,j,t)
    % BERN je Bernsteinov polinom
    % b=BERN(n,j,t)
    % n-stopnja, j-zaporedni polinom, t parameter (lahko vektor vrstica)
    b=nchoosek(n,j).*t.^j.*(1-t).^(n-j);
end
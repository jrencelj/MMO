function b = bezierOdvod(B, n)
% n predstavlja red odvoda
% kontrolne tocke so kontrolne tocke prvotne Bezierjeve krivulje
% vrne kontrolne točke odvajane Bezierjeve krivulje
    m = size(B,1)-1;
    kontrolne_tocke = B;
    b = kontrolne_tocke;
    for i=1:n
        b = zeros(m,2);
        for j=1:m
            c = m*(kontrolne_tocke(j+1,:)-kontrolne_tocke(j,:));
            b(j,:) = c;
        end
        m = m-1;
        kontrolne_tocke = b;
    end
end

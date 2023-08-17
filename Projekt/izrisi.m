function koordinate = izrisi(steviloTock, korakParametra, jePoligon)
    koordinate = zeros(steviloTock, 2);
    vnosTock = uifigure('Name','Beziereva krivulja','NumberTitle','off', 'HandleVisibility', "callback", "Position", [700, 700, 700, 700]);
    ax = uiaxes(vnosTock,"XLim",[-10, 10], "YLim",[-10, 10], Position=[70, 70, 600, 600]);
    zapri = uibutton(vnosTock, "push", ...
    "Text","Zapri", ...
    "BackgroundColor", [0.96, 0.76, 0.76], ...
    Position=[300, 30, 60, 30], ButtonPushedFcn=@(src, event) zapriOkno());
    % set(0, 'CurrentFigure', vnosTock);
    for i=1:steviloTock 
        % axis([-10 10 -10 10])
        try
            [x, y] = ginput(1);
            koordinate(i,:) = [x, y];
            plot(ax, koordinate(1:i, 1), koordinate(1:i, 2), ".", "MarkerSize", 20, "Color", "b");
        catch
            close all;
            break;
        end
    end

    % Izračun točk Bezierjeve krivulje
    tocke = bezier(koordinate', linspace(0, 1, 1000));
    P1 = bezierOdvod(koordinate, 1); % Kontrolne točke 1. odvoda.
    P2 = bezierOdvod(koordinate, 2); % Kontrolne točke 2. odvoda.
    tocke_P1 = bezier(P1', linspace(0, 1, 1000)); % Točke prvega odvoda.
    tocke_P2 = bezier(P2', linspace(0, 1, 1000)); % Točke drugega odvoda.
    T = zeros(1000, 2); % Tangentni vektor
    tocke_P1 = tocke_P1';
    tocke_P2 = tocke_P2';
    for i = 1:1000
        b = tocke_P1(i, :) ./ norm(tocke_P1(i, :));
        T(i, 1) = b(1);
        T(i, 2) = b(2);
    end
    % Izračun ukrivljenosti
    kapa = [];
    R = []; % polmeri pritisnjene krožnice
    for i = 1:1000
        p1 = [tocke_P1(i, 1); tocke_P1(i, 2)];
        p2 = [tocke_P2(i, 1); tocke_P2(i, 2)];
        % Izračun polmera.
        kapa(end + 1) = ukrivljenost(p1, p2);
        R(end + 1) = abs(1 / kapa(i)); 
    end
    
    if ishandle(ax)
        cla(ax);
    end
    for i=1:korakParametra:1000
        if ishandle(ax)
            hold on
        end
        if jePoligon == 1 && ishandle(ax)
            for j = 1:steviloTock - 1
                plot(ax, [koordinate(j, 1), koordinate(j + 1, 1)], [koordinate(j, 2), koordinate(j + 1, 2)], "-", "Color", "b");
            end
        end
        if ishandle(ax)
            plot(ax, tocke(1,:),tocke(2,:),'-','MarkerSize',5, "Color", "r")
        else
            break;
        end
        
        polmer = R(i);
        if ishandle(ax)
            plot(ax, tocke(1, i), tocke(2, i), ".", "MarkerSize", 20, "Color", "g")
        else
            break;
        end
        % plot(ax, [tocke(1, i) tocke(1, i) + T(i, 1)], [tocke(2, i) tocke(2, i) + T(i, 2)], '-', 'MarkerSize',5, "Color", "b")
        if ishandle(ax)
            plot(ax, [tocke(1, i) tocke(1, i) - polmer * sign(kapa(i)) * T(i, 2)], ...
                [tocke(2, i) tocke(2, i) + polmer * sign(kapa(i)) * T(i, 1)], '-', 'MarkerSize',5, "Color", "b")
        else
            break;
        end
        % SREDIŠČE KROGA
        sredisce = [tocke(1, i) - polmer * sign(kapa(i)) * T(i, 2), tocke(2, i) + polmer * sign(kapa(i)) * T(i, 1)];
        
        % disp(dot(sredisce, [tocke(1, i) + 3 * T(i, 1), tocke(2, i) + 3 * T(i, 2)]./norm([tocke(1, i) + 3 * T(i, 1), tocke(2, i) + 3 * T(i, 2)])))
        if ishandle(ax)
            plot(ax, sredisce(1), sredisce(2), ".", "MarkerSize", 20, "Color", "r")
        else
            break
        end
        % Risanje pritisnjene krožnice
        theta = 0:pi/50:2*pi;
        x_krog = polmer * cos(theta) + sredisce(1);
        y_krog = polmer * sin(theta) + sredisce(2);
        if ishandle(ax)
            plot(ax, x_krog, y_krog);
        else
            break;
        end
        hold off
        % axis([-10 10 -10 10])
        zaustavi(0.1);
        drawnow
        if i + korakParametra < 1000 && ishandle(ax)
            cla(ax);
        end
        % drawnow
    end
    function zapriOkno()
        cla(ax);
        close all;
    end
end
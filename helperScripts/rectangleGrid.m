function rectangles = rectangleGrid()
    % Creating the small rectangles. 
    % The rectangles are marked from bottom to top; and then left to right

    axis off;
    hold on;

    rectangles = cell(16);

    count = 1;
    for i = 1:16
        for j = 16-i+1:16
            rectangles{count} = rectangle('Position', [i ,j ,1, 1]);    
            count = count+1;
        end
    end

    % Marking the legends on the top and the right
    for i = 1:16
        text(i, 17.5, ['c_{', int2str(i), '}']);
        text(17.2, 17.5 - i, ['c_{', int2str(i), '}']);
    end

end

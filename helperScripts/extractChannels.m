function pixelChannels = extractChannels(image)

    [rows, cols, ~] = size(image);
    pixelChannels = zeros(rows*cols, 16);
    
    % R, G and B color channels
    R = double(image(:, :, 1));
    pixelChannels(:, 1) = R(:);
    
    G = double(image(:, :, 2));
    pixelChannels(:, 2) = G(:);
    
    B = double(image(:, :, 3));
    pixelChannels(:, 3) = B(:);
    
    % H, S, V color channels
    HSV = rgb2hsv(image);
    
    H = HSV(:, :, 1);
    pixelChannels(:, 4) = H(:);
    
    S = HSV(:, :, 2);
    pixelChannels(:, 5) = S(:);
    
    V = HSV(:, :, 3);
    pixelChannels(:, 6) = V(:);
    
    % Y, I, Q color channels
    YIQ = rgb2ntsc(image);
    
    Y=YIQ(:, :, 1);
    pixelChannels(:, 7) = Y(:);
    
    I=YIQ(:, :, 2);
    pixelChannels(:, 8) = I(:);
    
    Q=YIQ(:, :, 3);
    pixelChannels(:, 9) = Q(:);
    
    % L, a, b color channels
    lab = lab2double(applycform(image, makecform('srgb2lab')));
  
    L = lab(:, :, 1);
    pixelChannels(:, 10) = L(:);
    
    a = lab(:, :, 2);  % Extract the A image.
    pixelChannels(:, 11) = a(:);
    
    b = lab(:, :, 3);  % Extract the B image.
    pixelChannels(:, 12) = b(:);

    % R/B color channel
    pixelChannels(:, 13) = R(:) ./ B(:);
    
    % R-B color channel
    pixelChannels(:, 14) = R(:) - B(:);
    
    % (B-R)/(B+R)
    pixelChannels(:, 15) = (B(:) - R(:)) ./ (B(:) + R(:));
       
    % C color channel
    pixelChannels(:, 16) = max([R(:), G(:), B(:)], [], 2) - min([R(:), G(:), B(:)], [], 2);

end
function [red,green,blue] = RGBPlane(TestImage)
% This function inputs the test image and outputs the red, green, blue
% plane.
% Please refer the following link for details: https://github.com/Soumyabrata/color-channels
% -----------------------------------------------------

% Extract out the individual color channels
red = TestImage(:, :, 1);
green = TestImage(:, :, 2);
blue = TestImage(:, :, 3);
% ===============================================
%  Course: Computer Vision (BM40A901)	        |
%  Practical Assignment: Collecting Cubes		|
%  Author: Aditya Hosamani (0585939)	        |
% ===============================================

% Capture images
% TBD

% Perform camera calibration
% Find the projection matrix using the list of images (imgs).
% squareSize (in mm) and boardSize (#corners) are optional, and can either
% be detected automatically from the images or provided explicitly by user

%imgs = 
%[projMatrix, camParams] = calibrate(imgs, squareSize, boardSize);

img = imread("test_images\images\img1.png");
blocks = {"green","blue","red"};
x=move_block(blocks,img,0,0);

% Object detection

% Move the robot


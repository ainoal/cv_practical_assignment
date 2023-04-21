%clear all; close all; clc;
 
%img = imread("..\test_images\new_robot_cover\img5.png");
%x = find_obj(img, "green");

function coords = find_objects(img, cube_color)
% FIND_OBJ Find the location of the cubes and targets,
% and the pose of the robot using color tresholding
%
%    Inputs:
%        img: an image containing the current arrangement of robot and blocks.
%        calib: calibration results from function calibrate.
%
%    Output:
%        coords: matrix containing the coordinates of cube and target
%        centroids and the centroids of the cyan and magenta dots on
%        top of the robot

    [cyan, magenta] = locate_robot(img);

    [rcube, rtarget] = locate_red(img);
    [gcube, gtarget] = locate_green(img);
    [bcube, btarget] = locate_blue(img);


    coords = [transpose(cyan) transpose(magenta) ...
        transpose(rcube) transpose(gcube) transpose(bcube) ...
        transpose(rtarget) transpose(gtarget) transpose(btarget)]
end

function [rcube, rtarget] = locate_red(img)
    % Locate red in RGB color space
    % Specify minimum and maximum values for color channels
    rmin = 50;  
    rmax = 255;
    gmin = 0;
    gmax = 50;
    bmin = 0;
    bmax = 55;

    [rcube, rtarget] = locate_cube_and_target(img, rmin, rmax, gmin, gmax, bmin, bmax);
end

function [gcube, gtarget] = locate_green(img)
    % Locate green in RGB color space
    rmin = 0;  
    rmax = 50;
    gmin = 50;
    gmax = 255;
    bmin = 0;
    bmax = 50;

    [gcube, gtarget] = locate_cube_and_target(img, rmin, rmax, gmin, gmax, bmin, bmax);
end

function [bcube, btarget] = locate_blue(img)
    % Locate blue in RGB color space
    rmin = 0;  
    rmax = 60;
    gmin = 0;
    gmax = 60;
    bmin = 30;
    bmax = 255;

    [bcube, btarget] = locate_cube_and_target(img, rmin, rmax, gmin, gmax, bmin, bmax);
end

function [cube_centroid, target_centroid] =locate_cube_and_target(img, rmin, rmax, gmin, gmax, bmin, bmax)

    filter = (img(:, :, 1) >= rmin) & (img(:, :, 1) <= rmax) & ...
      (img(:, :, 2) >= gmin) & (img(:, :, 2) <= gmax) & ...
      (img(:, :, 3) >= bmin) & (img(:, :, 3) <= bmax);

    %colored_area = filter      % This line is for testing

    % Remove small areas from the binary image and fill holes in areas
    colored_area = bwareaopen(filter, 300);
    colored_area = imfill(colored_area, "holes");

    props = regionprops('table', colored_area, 'Centroid', 'Circularity', ...
        'MajorAxisLength','MinorAxisLength', 'Area', 'Eccentricity');

    max_val = max(props.Circularity);
    target_idx = find(props.Circularity == max_val);
    target_centroid = [props.Centroid(target_idx, :) 1];

    cube_idx = find(min([props.MajorAxisLength] / [props.MinorAxisLength]));
    cube_centroid = [props.Centroid(cube_idx, :) 1];

    % Plotting for testing, to be deleted later
    figure;
    imshow(colored_area);
    hold on;
    plot(target_centroid(1,1), target_centroid(1,2), "diamond", 'MarkerSize', 8, 'markerFaceColor', "red");
    plot(cube_centroid(1,1), cube_centroid(1,2), "o", 'MarkerSize', 8, 'markerFaceColor', "red");
    hold off;
end

function [cyan_centroid, magenta_centroid] = locate_robot(img)
    % Locate cyan in RGB color space
    rmin_c = 0;  
    rmax_c = 100;
    gmin_c = 50;
    gmax_c = 150;
    bmin_c = 100;
    bmax_c = 255;

    cyan_centroid = locate_dot(img, rmin_c, rmax_c, gmin_c, gmax_c, bmin_c, bmax_c);
    cyan_centroid = [cyan_centroid 1];

    % Locate magenta
    rmin_m = 70;  
    rmax_m = 255;
    gmin_m = 0;
    gmax_m = 70;
    bmin_m = 60;
    bmax_m = 255;

    magenta_centroid = locate_dot(img, rmin_m, rmax_m, gmin_m, gmax_m, bmin_m, bmax_m);
    magenta_centroid = [magenta_centroid 1];
    %magenta_centroid = cyan_centroid;
end

function dot_centroid = locate_dot(img, rmin, rmax, gmin, gmax, bmin, bmax)
    filter = (img(:, :, 1) >= rmin) & (img(:, :, 1) <= rmax) & ...
      (img(:, :, 2) >= gmin) & (img(:, :, 2) <= gmax) & ...
      (img(:, :, 3) >= bmin) & (img(:, :, 3) <= bmax);

    colored_area = bwareaopen(filter, 50);
    colored_area = imfill(colored_area, "holes");

    props = regionprops('table', colored_area, 'Centroid', 'Circularity', ...
        'MajorAxisLength','MinorAxisLength', 'Area', 'Eccentricity');

    max_val = max(props.Circularity);
    dot_idx = find(props.Circularity == max_val);
    dot_centroid = props.Centroid(dot_idx, :);

    % For the arrow on top of the robot, delete if we will not use the arrow
    %display(size(props))
    %arrow = [];
    %for i = 1:size(props)
    %    if (props.Circularity(i, :) > 0.85)
    %        arrow = [arrow, props.Centroid(i, :)];
    %    end
    %end

    %figure;
    %imshow(colored_area);
    %hold on;
    %plot(dot_centroid(1,1), dot_centroid(1,2), "diamond", 'MarkerSize', 3, 'markerFaceColor', "red");
    %hold off;
end

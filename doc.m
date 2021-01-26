%% danielson
%
% Algorithm to compute the discrete distance map on a binary image.
%
% Author and support : nicolas.douillet (at) free.fr, 2005-2021.
% 
%% Syntax
%
% - danielson(img_flnm);
%
% - danielson(img_flnm, option_display);
%
% - danielson(img_flnm, option_display, threshold);
%
% - D = danielson(img_flnm, option_display, threshold);
%
%% Description
%
% - danielson(img_flnm) reads the image img_flnm, thresholds it at level
% 0.5 by default if it is not already a binary image, computes the distance map,
% and displays it.
%
% - danielson(img_flnm, option_display) displays it when option_display is
% either logical *true or numeric *1, and doesn't when it is either logical false
% or numeric 0.
%
% - danielson(img_flnm, option_display, threshold) uses the threshold value
% to binarize the image.
%
% - D = danielson(img_flnm, option_display, threshold) stores the resulting
% distance map in D. 
%
%% See also
%
% <https://fr.mathworks.com/help/matlab/ref/voronoi.html?s_tid=srchtitle voronoi>
%
%% Input arguments
%
% - img_flnm : characters string, the name -and the path if needed- of the
%              image file.
%
% - option_display : either logical *true/false or numeric *1/0.
%
% - threshold : double numeric scalar, 0 <= threshold <= 1.
%
%% Output argument
%
% - D : numeric array, the resulting distance map in the meaning of v4 neighborhood,
%       size(D) = [H,W] with H the height of the image, and W the width, in pixels unit.
%
%% Example
I = imread('disks_cloud.jpg');
image(I);   
axis equal, axis tight, axis off;
danielson('disks_cloud.jpg',true);
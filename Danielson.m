function [D] = danielson(img_flnm, option_display, threshold)
%% danielson : algorithm to compute the discrete distance map on a binary image.
%
% Author and support : nicolas.douillet (at) free.fr, 2005-2021.
% 
% Syntax
%
% - danielson(img_flnm);
% - danielson(img_flnm, option_display);
% - danielson(img_flnm, option_display, threshold);
% - D = danielson(img_flnm, option_display, threshold);
%
% Description
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
% See also VORONOI
%
% Input arguments
%
% - img_flnm : characters string, the name -and the path if needed- of the
%              image file.
%
% - option_display : either logical *true/false or numeric *1/0.
%
% - threshold : double numeric scalar, 0 <= threshold <= 1.
%
% Output argument
%
% - D : numeric array, the resulting distance map in the meaning of v4 neighborhood,
%       size(D) = [H,W] with H the height of the image, and W the width, in pixels unit.
%
% Example
%
% I = imread('disks_cloud.jpg');
% image(I);   
% axis equal, axis tight, axis off;
% danielson('disks_cloud.jpg',true);


%% Input parsing
assert(nargin > 0, 'Not enough input argument.');
assert(nargin < 4, 'Too many input arguments.');
assert(ischar(img_flnm), 'img_flnm must be a characters string.');

if nargin < 3
    
    threshold = 0.5;
    
    if nargin < 2
        
        option_display = true;
        
    else
        
        assert(islogical(option_display) || isnumeric(option_display), 'option_display must be of class either numeric or logical.');
        
    end
    
else
    
    assert(isnumeric(threshold) && threshold >= 0 && threshold <= 1, 'threshold must be a positive number and such that 0<= threshold <= 1.');
    
end


%% Body
% Reading image
I = imread(img_flnm);
H = size(I,1);  % height
W = size(I,2); % width


% RGB to gray and binary conversion
if numel(size(I)) > 2
    I = rgb2gray(I);
end

if ~islogical(I)
    I = imbinarize(I,threshold); 
end


% Distance vectors array
T = inf(H+2,W+2,3);  % T(:,:,1) : i coordinate
                     % T(:,:,2) : j coordinate
                     % T(:,:,3) = sqrt(T(:,:,1)^2+T(:,:,2)^2) : norm

                     
% Initialization: distance is null if (i,j) pixel belongs to an island.
Tf = inf(H,W);
f = I ~= 0;
Tf(f) = 0;
T(2:end-1,2:end-1,:) = cat(3,Tf,Tf,Tf);


% danielson vector definition (move) :
e = [0,0];  % distance vector of (i,j) pixel to itself

              %                  Mask :
              %                   _ _
ei1 = [1,0];  % i = ordinate     |_|_|
ej1 = [0,1];  % j = abscissa     |_| 
              %                   _ _
ei2 = [1,0];  %                  |_|_|
ej2 = [0,-1]; %                    |_|
              %                   _
ei3 = [-1,0]; %                  |_|_
ej3 = [0,1];  %                  |_|_|
              %                     _ 
ei4 = [-1,0]; %                   _|_|
ej4 = [0,-1]; %                  |_|_|


% Go through #1 : north-west
for j = W:-1:1
    for i = H:-1:1
       
        % Vectors definition
        v  = [T(i+1,j+1,1),T(i+1,j+1,2)] + e;
        v1 = [T(i+2,j+1,1),T(i+2,j+1,2)] + ei1;
        v2 = [T(i+1,j+2,1),T(i+1,j+2,2)] + ej1;       

        % Compute the minimum
        [a,idx] = min([norm(v),norm(v1),norm(v2)]);

        % Update vectors in the array
        if idx == 2
            T(i+1,j+1,1) = v1(1);
            T(i+1,j+1,2) = v1(2);
        elseif idx == 3
            T(i+1,j+1,1) = v2(1);
            T(i+1,j+1,2) = v2(2);
        end
        % Update v norm
        T(i+1,j+1,3) = a;       
    end
end


% Go through #2 : north-east
for i = H:-1:1
    for j = 1:W        
        % Vectors definition
        v  = [T(i+1,j+1,1),T(i+1,j+1,2)] + e;
        v1 = [T(i+2,j+1,1),T(i+2,j+1,2)] + ei2;
        v2 = [T(i+1,j,1),T(i+1,j,2)]     + ej2;

        % Compute the minimum
        [a,idx] = min([norm(v),norm(v1),norm(v2)]);

        % Update vectors in the array
        if idx == 2
            T(i+1,j+1,1) = v1(1);
            T(i+1,j+1,2) = v1(2);
        elseif idx == 3
            T(i+1,j+1,1) = v2(1);
            T(i+1,j+1,2) = v2(2);
        end
        % Update v norm
        T(i+1,j+1,3) = a;        
    end
end


% Go through #3 : south-west
for i = 1:H
    for j = W:-1:1        
        % Vectors definition
        v  = [T(i+1,j+1,1),T(i+1,j+1,2)] + e;
        v1 = [T(i,j+1,1),T(i,j+1,2)]     + ei3;
        v2 = [T(i+1,j+2,1),T(i+1,j+2,2)] + ej3;

        % Compute the minimum
        [a,idx] = min([norm(v),norm(v1),norm(v2)]);

        % Update vectors in the array
        if idx == 2
            T(i+1,j+1,1) = v1(1);
            T(i+1,j+1,2) = v1(2);
        elseif idx == 3
            T(i+1,j+1,1) = v2(1);
            T(i+1,j+1,2) = v2(2);
        end
        % Update v norm
        T(i+1,j+1,3) = a;        
    end
end


% Go through #4 : south-east
for j = 1:W              
    for i = 1:H          
        % Vectors definition
        v  = [T(i+1,j+1,1),T(i+1,j+1,2)] + e;
        v1 = [T(i,j+1,1),T(i,j+1,2)]     + ei4;
        v2 = [T(i+1,j,1),T(i+1,j,2)]     + ej4;

        % Compute the minimum
        [a,idx] = min([norm(v),norm(v1),norm(v2)]);

        % Update vectors in the array
        if idx == 2
            T(i+1,j+1,1) = v1(1);
            T(i+1,j+1,2) = v1(2);
        elseif idx == 3
            T(i+1,j+1,1) = v2(1);
            T(i+1,j+1,2) = v2(2);
        end
        % Update v norm
        T(i+1,j+1,3) = a;        
    end
end


% Distance map only
D = T(:,:,3);


%% Display
if option_display
    figure;    
    image(D);   
    axis equal, axis tight, axis off;
end


end % danielson
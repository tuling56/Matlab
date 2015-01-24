function matlab_canny()
clear all; close all; clc;
img=imread('IMG_1292.JPG_1.JPG');
grayimg=rgb2gray(img);
[cannyimg,thresh]=edge(grayimg,'canny');
disp(thresh);
imshow(cannyimg);
end

function [eout,thresh,gv_45,gh_135] = edge(varargin)
%EDGE Find edges in intensity image.
%   EDGE takes an intensity or a binary image I as its input, and returns a
%   binary image BW of the same size as I, with 1's where the function
%   finds edges in I and 0's elsewhere.
%
%   EDGE supports six different edge-finding methods:
%
%      The Sobel method finds edges using the Sobel approximation to the
%      derivative. It returns edges at those points where the gradient of
%      I is maximum.
%
%      The Prewitt method finds edges using the Prewitt approximation to
%      the derivative. It returns edges at those points where the gradient
%      of I is maximum.
%
%      The Roberts method finds edges using the Roberts approximation to
%      the derivative. It returns edges at those points where the gradient
%      of I is maximum.
%
%      The Laplacian of Gaussian method finds edges by looking for zero
%      crossings after filtering I with a Laplacian of Gaussian filter.
%
%      The zero-cross method finds edges by looking for zero crossings
%      after filtering I with a filter you specify.
%
%      The Canny method finds edges by looking for local maxima of the
%      gradient of I. The gradient is calculated using the derivative of a
%      Gaussian filter. The method uses two thresholds, to detect strong
%      and weak edges, and includes the weak edges in the output only if
%      they are connected to strong edges. This method is therefore less
%      likely than the others to be "fooled" by noise, and more likely to
%      detect true weak edges.
%
%   The parameters you can supply differ depending on the method you
%   specify. If you do not specify a method, EDGE uses the Sobel method.
%
%   Sobel Method
%   ------------
%   BW = EDGE(I,'sobel') specifies the Sobel method.
%
%   BW = EDGE(I,'sobel',THRESH) specifies the sensitivity threshold for
%   the Sobel method. EDGE ignores all edges that are not stronger than
%   THRESH.  If you do not specify THRESH, or if THRESH is empty ([]),
%   EDGE chooses the value automatically.
%
%   BW = EDGE(I,'sobel',THRESH,DIRECTION) specifies directionality for the
%   Sobel method. DIRECTION is a string specifying whether to look for
%   'horizontal' or 'vertical' edges, or 'both' (the default).
%
%   BW = EDGE(I,'sobel',...,OPTIONS) provides an optional string
%   input. String 'nothinning' speeds up the operation of the algorithm by
%   skipping the additional edge thinning stage. By default, or when
%   'thinning' string is specified, the algorithm applies edge thinning.
%
%   [BW,thresh] = EDGE(I,'sobel',...) returns the threshold value.
%
%   Prewitt Method
%   --------------
%   BW = EDGE(I,'prewitt') specifies the Prewitt method.
%
%   BW = EDGE(I,'prewitt',THRESH) specifies the sensitivity threshold for
%   the Prewitt method. EDGE ignores all edges that are not stronger than
%   THRESH. If you do not specify THRESH, or if THRESH is empty ([]),
%   EDGE chooses the value automatically.
%
%   BW = EDGE(I,'prewitt',THRESH,DIRECTION) specifies directionality for
%   the Prewitt method. DIRECTION is a string specifying whether to look
%   for 'horizontal' or 'vertical' edges, or 'both' (the default).
%
%   BW = EDGE(I,'prewitt',...,OPTIONS) provides an optional string
%   input. String 'nothinning' speeds up the operation of the algorithm by
%   skipping the additional edge thinning stage. By default, or when
%   'thinning' string is specified, the algorithm applies edge thinning.
%
%   [BW,thresh] = EDGE(I,'prewitt',...) returns the threshold value.
%
%   Roberts Method
%   --------------
%   BW = EDGE(I,'roberts') specifies the Roberts method.
%
%   BW = EDGE(I,'roberts',THRESH) specifies the sensitivity threshold for
%   the Roberts method. EDGE ignores all edges that are not stronger than
%   THRESH. If you do not specify THRESH, or if THRESH is empty ([]),
%   EDGE chooses the value automatically.
%
%   BW = EDGE(I,'roberts',...,OPTIONS) provides an optional string
%   input. String 'nothinning' speeds up the operation of the algorithm by
%   skipping the additional edge thinning stage. By default, or when
%   'thinning' string is specified, the algorithm applies edge thinning.
%
%   [BW,thresh] = EDGE(I,'roberts',...) returns the threshold value.
%
%   Laplacian of Gaussian Method
%   ----------------------------
%   BW = EDGE(I,'log') specifies the Laplacian of Gaussian method.
%
%   BW = EDGE(I,'log',THRESH) specifies the sensitivity threshold for the
%   Laplacian of Gaussian method. EDGE ignores all edges that are not
%   stronger than THRESH. If you do not specify THRESH, or if THRESH is
%   empty ([]), EDGE chooses the value automatically.
%
%   BW = EDGE(I,'log',THRESH,SIGMA) specifies the Laplacian of Gaussian
%   method, using SIGMA as the standard deviation of the LoG filter. The
%   default SIGMA is 2; the size of the filter is N-by-N, where
%   N=CEIL(SIGMA*3)*2+1.
%
%   [BW,thresh] = EDGE(I,'log',...) returns the threshold value.
%
%   Zero-cross Method
%   -----------------
%   BW = EDGE(I,'zerocross',THRESH,H) specifies the zero-cross method,
%   using the specified filter H. If THRESH is empty ([]), EDGE chooses
%   the sensitivity threshold automatically.
%
%   [BW,THRESH] = EDGE(I,'zerocross',...) returns the threshold value.
%
%   Canny Method
%   ----------------------------
%   BW = EDGE(I,'canny') specifies the Canny method.
%
%   BW = EDGE(I,'canny',THRESH) specifies sensitivity thresholds for the
%   Canny method. THRESH is a two-element vector in which the first element
%   is the low threshold, and the second element is the high threshold. If
%   you specify a scalar for THRESH, this value is used for the high
%   threshold and 0.4*THRESH is used for the low threshold. If you do not
%   specify THRESH, or if THRESH is empty ([]), EDGE chooses low and high
%   values automatically.
%
%   BW = EDGE(I,'canny',THRESH,SIGMA) specifies the Canny method, using
%   SIGMA as the standard deviation of the Gaussian filter. The default
%   SIGMA is sqrt(2); the size of the filter is chosen automatically, based
%   on SIGMA.
%
%   [BW,thresh] = EDGE(I,'canny',...) returns the threshold values as a
%   two-element vector.
%
%   Class Support
%   -------------
%   I is a nonsparse numeric array. BW is of class logical.
%
%   Remarks
%   -------
%   For the 'log' and 'zerocross' methods, if you specify a
%   threshold of 0, the output image has closed contours because
%   it includes all of the zero crossings in the input image.
%
%   The function EDGE changed in version 7.2 (R2011a). Previous versions
%   of the Image Processing Toolbox used a different algorithm for
%   computing the Canny method. If you need the same results produced
%   by the previous implementation, use BW = EDGE(I,'canny_old',...).
%
%   Example
%   -------
%   Find the edges of the circuit.tif image using the Prewitt and Canny
%   methods:
%
%       I = imread('circuit.tif');
%       BW1 = edge(I,'prewitt');
%       BW2 = edge(I,'canny');
%       figure, imshow(BW1)
%       figure, imshow(BW2)
%
%   See also FSPECIAL, IMGRADIENT, IMGRADIENTXY.

%   Copyright 1992-2012 The MathWorks, Inc.
%   $Revision: 5.26.4.17 $  $Date: 2012/03/01 02:21:56 $

%   [BW,thresh,gv,gh] = EDGE(I,'sobel',...) returns vertical and
%   horizontal edge responses to Sobel gradient operators. You can
%   also use these expressions to obtain gradient responses:
%   if ~(isa(I,'double') || isa(I,'single')); I = im2single(I); end
%   gh = imfilter(I,fspecial('sobel') /8,'replicate'); and
%   gv = imfilter(I,fspecial('sobel')'/8,'replicate');
% 
%   [BW,thresh,gv,gh] = EDGE(I,'prewitt',...) returns vertical and
%   horizontal edge responses to Prewitt gradient operators. You can
%   also use these expressions to obtain gradient responses:
%   if ~(isa(I,'double') || isa(I,'single')); I = im2single(I); end
%   gh = imfilter(I,fspecial('prewitt') /6,'replicate'); and
%   gv = imfilter(I,fspecial('prewitt')'/6,'replicate');
%
%   [BW,thresh,g45,g135] = EDGE(I,'roberts',...) returns 45 degree and
%   135 degree edge responses to Roberts gradient operators. You can
%   also use these expressions to obtain gradient responses:
%   if ~(isa(I,'double') || isa(I,'single')); I = im2single(I); end
%   g45  = imfilter(I,[1 0; 0 -1]/2,'replicate'); and
%   g135 = imfilter(I,[0 1;-1  0]/2,'replicate');

[a,method,thresh,sigma,thinning,H,kx,ky] = parse_inputs(varargin{:});

% Check that the user specified a valid number of output arguments
if ~any(strcmp(method,{'sobel','roberts','prewitt'})) && (nargout>2)
    error(message('images:edge:tooManyOutputs'))
end

% Transform to a double precision intensity image if necessary
if ~isa(a,'double') && ~isa(a,'single')
    a = im2single(a);
end

[m,n] = size(a);

% The output edge map:
e = false(m,n);

if strcmp(method,'canny')
    % Magic numbers
    PercentOfPixelsNotEdges = .7; % Used for selecting thresholds
    ThresholdRatio = .4;          % Low thresh is this fraction of the high.
    
    % Calculate gradients using a derivative of Gaussian filter
    [dx, dy] = smoothGradient(a, sigma);
    
    % Calculate Magnitude of Gradient
    magGrad = hypot(dx, dy);
    
    % Normalize for threshold selection
    magmax = max(magGrad(:));
    if magmax > 0
        magGrad = magGrad / magmax;
    end
    
    % Determine Hysteresis Thresholds
    [lowThresh, highThresh] = selectThresholds(thresh, magGrad, PercentOfPixelsNotEdges, ThresholdRatio, mfilename);
    
    % Perform Non-Maximum Suppression Thining and Hysteresis Thresholding of Edge
    % Strength
    e = thinAndThreshold(e, dx, dy, magGrad, lowThresh, highThresh);
    thresh = [lowThresh highThresh];
    
elseif strcmp(method,'canny_old')
    % Magic numbers
    GaussianDieOff = .0001;
    PercentOfPixelsNotEdges = .7; % Used for selecting thresholds
    ThresholdRatio = .4;          % Low thresh is this fraction of the high.
    
    % Design the filters - a gaussian and its derivative
    
    pw = 1:30; % possible widths
    ssq = sigma^2;
    width = find(exp(-(pw.*pw)/(2*ssq))>GaussianDieOff,1,'last');
    if isempty(width)
        width = 1;  % the user entered a really small sigma
    end
    
    t = (-width:width);
    gau = exp(-(t.*t)/(2*ssq))/(2*pi*ssq);     % the gaussian 1D filter
    
    % Find the directional derivative of 2D Gaussian (along X-axis)
    % Since the result is symmetric along X, we can get the derivative along
    % Y-axis simply by transposing the result for X direction.
    [x,y]=meshgrid(-width:width,-width:width);
    dgau2D=-x.*exp(-(x.*x+y.*y)/(2*ssq))/(pi*ssq);
    
    % Convolve the filters with the image in each direction
    % The canny edge detector first requires convolution with
    % 2D Gaussian, and then with the derivative of a Gaussian.
    % Since Gaussian filter is separable, for smoothing, we can use
    % two 1D convolutions in order to achieve the effect of convolving
    % with 2D Gaussian.  We convolve along rows and then columns.
    
    %smooth the image out
    aSmooth=imfilter(a,gau,'conv','replicate');   % run the filter across rows
    aSmooth=imfilter(aSmooth,gau','conv','replicate'); % and then across columns
    
    %apply directional derivatives
    ax = imfilter(aSmooth, dgau2D, 'conv','replicate');
    ay = imfilter(aSmooth, dgau2D', 'conv','replicate');
    
    mag = sqrt((ax.*ax) + (ay.*ay));
    magmax = max(mag(:));
    if magmax>0
        mag = mag / magmax;   % normalize
    end
    
    % Select the thresholds
    if isempty(thresh)
        counts=imhist(mag, 64);
        highThresh = find(cumsum(counts) > PercentOfPixelsNotEdges*m*n,...
            1,'first') / 64;
        lowThresh = ThresholdRatio*highThresh;
        thresh = [lowThresh highThresh];
    elseif length(thresh)==1
        highThresh = thresh;
        if thresh>=1
            error(message('images:edge:thresholdMustBeLessThanOne'))
        end
        lowThresh = ThresholdRatio*thresh;
        thresh = [lowThresh highThresh];
    elseif length(thresh)==2
        lowThresh = thresh(1);
        highThresh = thresh(2);
        if (lowThresh >= highThresh) || (highThresh >= 1)
            error(message('images:edge:thresholdOutOfRange'))
        end
    end
    
    % The next step is to do the non-maximum suppression.
    % We will accrue indices which specify ON pixels in strong edgemap
    % The array e will become the weak edge map.
    idxStrong = [];
    for dir = 1:4
        idxLocalMax = cannyFindLocalMaxima(dir,ax,ay,mag);
        idxWeak = idxLocalMax(mag(idxLocalMax) > lowThresh);
        e(idxWeak)=1;
        idxStrong = [idxStrong; idxWeak(mag(idxWeak) > highThresh)]; %#ok<AGROW>
    end
    
    if ~isempty(idxStrong) % result is all zeros if idxStrong is empty
        rstrong = rem(idxStrong-1, m)+1;
        cstrong = floor((idxStrong-1)/m)+1;
        e = bwselect(e, cstrong, rstrong, 8);
        e = bwmorph(e, 'thin', 1);  % Thin double (or triple) pixel wide contours
    end
    
elseif any(strcmp(method, {'log','marr-hildreth','zerocross'}))
    rr = 2:m-1; cc=2:n-1;
    
    % We don't use image blocks here
    if isempty(H),
        fsize = ceil(sigma*3) * 2 + 1;  % choose an odd fsize > 6*sigma;
        op = fspecial('log',fsize,sigma);
    else
        op = H;
    end
    
    op = op - sum(op(:))/numel(op); % make the op to sum to zero
    b = imfilter(a,op,'replicate');
    
    if isempty(thresh)
        thresh = .75*mean2(abs(b));
    end
    
    % Look for the zero crossings:  +-, -+ and their transposes
    % We arbitrarily choose the edge to be the negative point
    [rx,cx] = find( b(rr,cc) < 0 & b(rr,cc+1) > 0 ...
        & abs( b(rr,cc)-b(rr,cc+1) ) > thresh );   % [- +]
    e((rx+1) + cx*m) = 1;
    [rx,cx] = find( b(rr,cc-1) > 0 & b(rr,cc) < 0 ...
        & abs( b(rr,cc-1)-b(rr,cc) ) > thresh );   % [+ -]
    e((rx+1) + cx*m) = 1;
    [rx,cx] = find( b(rr,cc) < 0 & b(rr+1,cc) > 0 ...
        & abs( b(rr,cc)-b(rr+1,cc) ) > thresh);   % [- +]'
    e((rx+1) + cx*m) = 1;
    [rx,cx] = find( b(rr-1,cc) > 0 & b(rr,cc) < 0 ...
        & abs( b(rr-1,cc)-b(rr,cc) ) > thresh);   % [+ -]'
    e((rx+1) + cx*m) = 1;
    
    % Most likely this covers all of the cases.   Just check to see if there
    % are any points where the LoG was precisely zero:
    [rz,cz] = find( b(rr,cc)==0 );
    if ~isempty(rz)
        % Look for the zero crossings: +0-, -0+ and their transposes
        % The edge lies on the Zero point
        zero = (rz+1) + cz*m;   % Linear index for zero points
        zz = (b(zero-1) < 0 & b(zero+1) > 0 ...
            & abs( b(zero-1)-b(zero+1) ) > 2*thresh);     % [- 0 +]'
        e(zero(zz)) = 1;
        zz = (b(zero-1) > 0 & b(zero+1) < 0 ...
            & abs( b(zero-1)-b(zero+1) ) > 2*thresh);     % [+ 0 -]'
        e(zero(zz)) = 1;
        zz = (b(zero-m) < 0 & b(zero+m) > 0 ...
            & abs( b(zero-m)-b(zero+m) ) > 2*thresh);     % [- 0 +]
        e(zero(zz)) = 1;
        zz = (b(zero-m) > 0 & b(zero+m) < 0 ...
            & abs( b(zero-m)-b(zero+m) ) > 2*thresh);     % [+ 0 -]
        e(zero(zz)) = 1;
    end
    
else  % one of the easy methods (roberts,sobel,prewitt)
    
    if strcmp(method,'sobel')
        op = fspecial('sobel')/8; % Sobel approximation to derivative
        x_mask = op'; % gradient in the X direction
        y_mask = op;
        
        scale = 4; % for calculating the automatic threshold
        offset = [0 0 0 0]; % offsets used in the computation of the threshold
        
    elseif strcmp(method,'prewitt')
        op = fspecial('prewitt')/6; % Prewitt approximation to derivative
        x_mask = op';
        y_mask = op;
        
        scale = 4;
        offset = [0 0 0 0];
        
    elseif strcmp(method, 'roberts')
        x_mask = [1 0; 0 -1]/2; % Roberts approximation to diagonal derivative
        y_mask = [0 1;-1  0]/2;
        
        scale = 6;
        offset = [-1 1 1 -1];
        
    else
        error(message('images:edge:invalidEdgeDetectionMethod', method))
    end
    
    % compute the gradient in x and y direction
    bx = imfilter(a,x_mask,'replicate');
    by = imfilter(a,y_mask,'replicate');
    
    if (nargout > 2) % if gradients are requested
        gv_45  = bx;
        gh_135 = by;
    end
    
    % compute the magnitude
    b = kx*bx.*bx + ky*by.*by;
    
    % determine the threshold; see page 514 of "Digital Imaging Processing" by
    % William K. Pratt
    if isempty(thresh), % Determine cutoff based on RMS estimate of noise
        % Mean of the magnitude squared image is a
        % value that's roughly proportional to SNR
        cutoff = scale*mean2(b);
        thresh = sqrt(cutoff);
    else                % Use relative tolerance specified by the user
        cutoff = (thresh).^2;
    end
    
    if thinning
        e = computeEdgesWithThinning(b,bx,by,kx,ky,offset,cutoff);
    else
        e = b > cutoff;
    end
    
end

if nargout==0,
    imshow(e);
else
    eout = e;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Local Function : computeEdgesWithThinning
%
function e = computeEdgesWithThinning(b,bx,by,kx,ky,offset,cutoff)
% This subfunction computes edges using edge thinning.

bx = abs(bx); % necessary for doing local maxima suppression
by = abs(by);

e = computeedge(b,bx,by,kx,ky,int8(offset),100*eps,cutoff);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Local Function : cannyFindLocalMaxima
%
function idxLocalMax = cannyFindLocalMaxima(direction,ix,iy,mag)
%
% This sub-function helps with the non-maximum suppression in the Canny
% edge detector.  The input parameters are:
%
%   direction - the index of which direction the gradient is pointing,
%               read from the diagram below. direction is 1, 2, 3, or 4.
%   ix        - input image filtered by derivative of gaussian along x
%   iy        - input image filtered by derivative of gaussian along y
%   mag       - the gradient magnitude image
%
%    there are 4 cases:
%
%                         The X marks the pixel in question, and each
%         3     2         of the quadrants for the gradient vector
%       O----0----0       fall into two cases, divided by the 45
%     4 |         | 1     degree line.  In one case the gradient
%       |         |       vector is more horizontal, and in the other
%       O    X    O       it is more vertical.  There are eight
%       |         |       divisions, but for the non-maximum suppression
%    (1)|         |(4)    we are only worried about 4 of them since we
%       O----O----O       use symmetric points about the center pixel.
%        (2)   (3)


[m,n] = size(mag);

% Find the indices of all points whose gradient (specified by the
% vector (ix,iy)) is going in the direction we're looking at.

switch direction
    case 1
        idx = find((iy<=0 & ix>-iy)  | (iy>=0 & ix<-iy));
    case 2
        idx = find((ix>0 & -iy>=ix)  | (ix<0 & -iy<=ix));
    case 3
        idx = find((ix<=0 & ix>iy) | (ix>=0 & ix<iy));
    case 4
        idx = find((iy<0 & ix<=iy) | (iy>0 & ix>=iy));
end

% Exclude the exterior pixels
if ~isempty(idx)
    v = mod(idx,m);
    extIdx = (v==1 | v==0 | idx<=m | (idx>(n-1)*m));
    idx(extIdx) = [];
end

ixv = ix(idx);
iyv = iy(idx);
gradmag = mag(idx);

% Do the linear interpolations for the interior pixels
switch direction
    case 1
        d = abs(iyv./ixv);
        gradmag1 = mag(idx+m).*(1-d) + mag(idx+m-1).*d;
        gradmag2 = mag(idx-m).*(1-d) + mag(idx-m+1).*d;
    case 2
        d = abs(ixv./iyv);
        gradmag1 = mag(idx-1).*(1-d) + mag(idx+m-1).*d;
        gradmag2 = mag(idx+1).*(1-d) + mag(idx-m+1).*d;
    case 3
        d = abs(ixv./iyv);
        gradmag1 = mag(idx-1).*(1-d) + mag(idx-m-1).*d;
        gradmag2 = mag(idx+1).*(1-d) + mag(idx+m+1).*d;
    case 4
        d = abs(iyv./ixv);
        gradmag1 = mag(idx-m).*(1-d) + mag(idx-m-1).*d;
        gradmag2 = mag(idx+m).*(1-d) + mag(idx+m+1).*d;
end
idxLocalMax = idx(gradmag>=gradmag1 & gradmag>=gradmag2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Local Function : parse_inputs
%
function [I,Method,Thresh,Sigma,Thinning,H,kx,ky] = parse_inputs(varargin)
% OUTPUTS:
%   I      Image Data
%   Method Edge detection method
%   Thresh Threshold value
%   Sigma  standard deviation of Gaussian
%   H      Filter for Zero-crossing detection
%   kx,ky  From Directionality vector

narginchk(1,5)

I = varargin{1};

validateattributes(I,{'numeric','logical'},{'nonsparse','2d'},mfilename,'I',1);

% Defaults
Method='sobel';
Thresh=[];
Direction='both';
Thinning=true;
Sigma=2;
H=[];
K=[1 1];

methods = {'canny','canny_old','prewitt','sobel','marr-hildreth','log','roberts','zerocross'};
directions = {'both','horizontal','vertical'};
options = {'thinning','nothinning'};

% Now parse the nargin-1 remaining input arguments

% First get the strings - we do this because the interpretation of the
% rest of the arguments will depend on the method.
nonstr = [];   % ordered indices of non-string arguments
for i = 2:nargin
    if ischar(varargin{i})
        str = lower(varargin{i});
        j = find(strcmp(str,methods));
        k = find(strcmp(str,directions));
        l = find(strcmp(str,options));
        if ~isempty(j)
            Method = methods{j(1)};
            if strcmp(Method,'marr-hildreth')
                error(message('images:removed:syntax','EDGE(I,''marr-hildreth'',...)','EDGE(I,''log'',...)')) 
            end
        elseif ~isempty(k)
            Direction = directions{k(1)};
        elseif ~isempty(l)
            if strcmp(options{l(1)},'thinning')
                Thinning = true;
            else
                Thinning = false;
            end
        else
            error(message('images:edge:invalidInputString', varargin{ i }))
        end
    else
        nonstr = [nonstr i]; %#ok<AGROW>
    end
end

% Now get the rest of the arguments

switch Method
    
    case {'prewitt','sobel','roberts'}
        threshSpecified = 0;  % Threshold is not yet specified
        for i = nonstr
            if numel(varargin{i})<=1 && ~threshSpecified % Scalar or empty
                Thresh = varargin{i};
                threshSpecified = 1;
            elseif numel(varargin{i})==2  % The dreaded K vector
                error(message('images:removed:syntax', 'BW = EDGE(... , K)', 'BW = EDGE(... , DIRECTION)'))
            else
                error(message('images:edge:invalidInputArguments'));
            end
        end
        
    case {'canny','canny_old'}
        % Default Std dev of gaussian for canny
        if (strcmp(Method, 'canny'))
            % The canny_old method smooths the input image twice
            % Use sqrt(2) to achieve similar results to the canny_old
            % method
            Sigma = sqrt(2);  
        else
            Sigma = 1.0;
        end
        threshSpecified = 0;  % Threshold is not yet specified
        for i = nonstr
            if numel(varargin{i})==2 && ~threshSpecified
                Thresh = varargin{i};
                threshSpecified = 1;
            elseif numel(varargin{i})==1
                if ~threshSpecified
                    Thresh = varargin{i};
                    threshSpecified = 1;
                else
                    Sigma = varargin{i};
                end
            elseif isempty(varargin{i}) && ~threshSpecified
                threshSpecified = 1;
            else
                error(message('images:edge:invalidInputArguments'));
            end
        end
        
    case 'log'
        threshSpecified = 0;  % Threshold is not yet specified
        for i = nonstr
            if numel(varargin{i})<=1  % Scalar or empty
                if ~threshSpecified
                    Thresh = varargin{i};
                    threshSpecified = 1;
                else
                    Sigma = varargin{i};
                end
            else
                error(message('images:edge:invalidInputArguments'));
            end
        end
        
    case 'zerocross'
        threshSpecified = 0;  % Threshold is not yet specified
        for i = nonstr
            if numel(varargin{i})<=1 && ~threshSpecified % Scalar or empty
                Thresh = varargin{i};
                threshSpecified = 1;
            elseif numel(varargin{i}) > 1 % The filter for zerocross
                H = varargin{i};
            else
                error(message('images:edge:invalidInputArguments'));
            end
        end
                
    otherwise
        error(message('images:edge:invalidInputArguments'));
        
end

if Sigma<=0
    error(message('images:edge:sigmaMustBePositive'))
end

switch Direction
    case 'both',
        kx = K(1); ky = K(2);
    case 'horizontal',
        kx = 0; ky = 1; % Directionality factor
    case 'vertical',
        kx = 1; ky = 0; % Directionality factor
    otherwise
        error(message('images:edge:badDirectionString'))
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Local Function : smoothGradient
%
function [GX, GY] = smoothGradient(I, sigma)

% Create an even-length 1-D separable Derivative of Gaussian filter

% Determine filter length
filterLength = 8*ceil(sigma);
n = (filterLength - 1)/2;
x = -n:n;

% Create 1-D Gaussian Kernel
c = 1/(sqrt(2*pi)*sigma);
gaussKernel = c * exp(-(x.^2)/(2*sigma^2));

% Normalize to ensure kernel sums to one
gaussKernel = gaussKernel/sum(gaussKernel);

% Create 1-D Derivative of Gaussian Kernel
derivGaussKernel = gradient(gaussKernel);

% Normalize to ensure kernel sums to zero
negVals = derivGaussKernel < 0;
posVals = derivGaussKernel > 0;
derivGaussKernel(posVals) = derivGaussKernel(posVals)/sum(derivGaussKernel(posVals));
derivGaussKernel(negVals) = derivGaussKernel(negVals)/abs(sum(derivGaussKernel(negVals)));

% Compute smoothed numerical gradient of image I along x (horizontal)
% direction. GX corresponds to dG/dx, where G is the Gaussian Smoothed
% version of image I.
GX = imfilter(I, gaussKernel', 'conv', 'replicate');
GX = imfilter(GX, derivGaussKernel, 'conv', 'replicate');

% Compute smoothed numerical gradient of image I along y (vertical)
% direction. GY corresponds to dG/dy, where G is the Gaussian Smoothed
% version of image I.
GY = imfilter(I, gaussKernel, 'conv', 'replicate');
GY  = imfilter(GY, derivGaussKernel', 'conv', 'replicate');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Local Function : selectThresholds
%
function [lowThresh, highThresh] = selectThresholds(thresh, magGrad, PercentOfPixelsNotEdges, ThresholdRatio, ~)

[m,n] = size(magGrad);

% Select the thresholds
if isempty(thresh)
    counts=imhist(magGrad, 64);
    highThresh = find(cumsum(counts) > PercentOfPixelsNotEdges*m*n,...
        1,'first') / 64;
    lowThresh = ThresholdRatio*highThresh;
elseif length(thresh)==1
    highThresh = thresh;
    if thresh>=1
        error(message('images:edge:thresholdMustBeLessThanOne'))
    end
    lowThresh = ThresholdRatio*thresh;
elseif length(thresh)==2
    lowThresh = thresh(1);
    highThresh = thresh(2);
    if (lowThresh >= highThresh) || (highThresh >= 1)
        error(message('images:edge:thresholdOutOfRange'))
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Local Function : thinAndThreshold
%
function H = thinAndThreshold(E, dx, dy, magGrad, lowThresh, highThresh)

% Perform Non-Maximum Suppression Thining and Hysteresis Thresholding of Edge
% Strength
    
% We will accrue indices which specify ON pixels in strong edgemap
% The array e will become the weak edge map.
idxStrong = [];
for dir = 1:4
    idxLocalMax = cannyFindLocalMaxima(dir,dx,dy,magGrad);
    idxWeak = idxLocalMax(magGrad(idxLocalMax) > lowThresh);
    E(idxWeak)=1;
    idxStrong = [idxStrong; idxWeak(magGrad(idxWeak) > highThresh)]; %#ok<AGROW>
end

[m,n] = size(E);

if ~isempty(idxStrong) % result is all zeros if idxStrong is empty
    rstrong = rem(idxStrong-1, m)+1;
    cstrong = floor((idxStrong-1)/m)+1;
    H = bwselect(E, cstrong, rstrong, 8);
else
    H = zeros(m, n);
end



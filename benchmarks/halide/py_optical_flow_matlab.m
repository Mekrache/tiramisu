% Code for dense pyramidal lucas-kanade extracted from
% https://www.mathworks.com/matlabcentral/fileexchange/22950-lucas-kanade-pyramidal-refined-optical-flow-implementation

clear all;
echo off;

SYNTHETIC_DATA = 1

if (SYNTHETIC_DATA)
       im1 = [0, 1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121, 144, 169, 196, 225, 0, 33, 68, 105;
              1, 2, 5, 10, 17, 26, 37, 50, 65, 82, 101, 122, 145, 170, 197, 226, 1, 34, 69, 106;
              4, 5, 8, 13, 20, 29, 40, 53, 68, 85, 104, 125, 148, 173, 200, 229, 4, 37, 72, 109;
              9, 10, 13, 18, 25, 34, 45, 58, 73, 90, 109, 130, 153, 178, 205, 234, 9, 42, 77, 114;
              16, 17, 20, 25, 32, 41, 52, 65, 80, 97, 116, 137, 160, 185, 212, 241, 16, 49, 84, 121;
              25, 26, 29, 34, 41, 50, 61, 74, 89, 106, 125, 146, 169, 194, 221, 250, 25, 58, 93, 130;
              36, 37, 40, 45, 52, 61, 72, 85, 100, 117, 136, 157, 180, 205, 232, 5, 36, 69, 104, 141;
              49, 50, 53, 58, 65, 74, 85, 98, 113, 130, 149, 170, 193, 218, 245, 18, 49, 82, 117, 154;
              64, 65, 68, 73, 80, 89, 100, 113, 128, 145, 164, 185, 208, 233, 4, 33, 64, 97, 132, 169;
              81, 82, 85, 90, 97, 106, 117, 130, 145, 162, 181, 202, 225, 250, 21, 50, 81, 114, 149, 186;
              100, 101, 104, 109, 116, 125, 136, 149, 164, 181, 200, 221, 244, 13, 40, 69, 100, 133, 168, 205;
              121, 122, 125, 130, 137, 146, 157, 170, 185, 202, 221, 242, 9, 34, 61, 90, 121, 154, 189, 226;
              144, 145, 148, 153, 160, 169, 180, 193, 208, 225, 244, 9, 32, 57, 84, 113, 144, 177, 212, 249;
              169, 170, 173, 178, 185, 194, 205, 218, 233, 250, 13, 34, 57, 82, 109, 138, 169, 202, 237, 18;
              196, 197, 200, 205, 212, 221, 232, 245, 4, 21, 40, 61, 84, 109, 136, 165, 196, 229, 8, 45;
              225, 226, 229, 234, 241, 250, 5, 18, 33, 50, 69, 90, 113, 138, 165, 194, 225, 2, 37, 74;
              0, 1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121, 144, 169, 196, 225, 0, 33, 68, 105;
              33, 34, 37, 42, 49, 58, 69, 82, 97, 114, 133, 154, 177, 202, 229, 2, 33, 66, 101, 138;
              68, 69, 72, 77, 84, 93, 104, 117, 132, 149, 168, 189, 212, 237, 8, 37, 68, 101, 136, 173;
              105, 106, 109, 114, 121, 130, 141, 154, 169, 186, 205, 226, 249, 18, 45, 74, 105, 138, 173, 210];

       im2 = [0, 1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121, 144, 169, 196, 225, 0, 33, 68, 105;
              1, 2, 5, 10, 17, 26, 37, 50, 65, 82, 101, 122, 145, 170, 197, 226, 1, 34, 69, 106;
              4, 5, 8, 13, 20, 29, 40, 53, 68, 85, 104, 125, 148, 173, 200, 229, 4, 37, 72, 109;
              9, 10, 13, 18, 25, 34, 45, 58, 73, 90, 109, 130, 153, 178, 205, 234, 9, 42, 77, 114;
              16, 17, 20, 25, 32, 41, 52, 65, 80, 97, 116, 137, 160, 185, 212, 241, 16, 49, 84, 121;
              25, 26, 29, 34, 41, 50, 61, 74, 89, 106, 125, 146, 169, 194, 221, 250, 25, 58, 93, 130;
              36, 37, 40, 45, 52, 61, 72, 85, 100, 117, 136, 157, 180, 205, 232, 5, 36, 69, 104, 141;
              49, 50, 53, 58, 65, 74, 85, 98, 113, 130, 149, 170, 193, 218, 245, 18, 49, 82, 117, 154;
              64, 65, 68, 73, 80, 89, 100, 113, 128, 145, 164, 185, 208, 233, 4, 33, 64, 97, 132, 169;
              81, 82, 85, 90, 97, 106, 117, 130, 145, 162, 181, 202, 225, 250, 21, 50, 81, 114, 149, 186;
              100, 101, 104, 109, 116, 125, 136, 149, 164, 181, 200, 221, 244, 13, 40, 69, 100, 133, 168, 205;
              121, 122, 125, 130, 137, 146, 157, 170, 185, 202, 221, 242, 9, 34, 61, 90, 121, 154, 189, 226;
              144, 145, 148, 153, 160, 169, 180, 193, 208, 225, 244, 9, 32, 57, 84, 113, 144, 177, 212, 249;
              169, 170, 173, 178, 185, 194, 205, 218, 233, 250, 13, 34, 57, 82, 109, 138, 169, 202, 237, 18;
              196, 197, 200, 205, 212, 221, 232, 245, 4, 21, 40, 61, 84, 109, 136, 165, 196, 229, 8, 45;
              225, 226, 229, 234, 241, 250, 5, 18, 33, 50, 69, 90, 113, 138, 165, 194, 225, 2, 37, 74;
              0, 1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121, 144, 169, 196, 225, 0, 33, 68, 105;
              33, 34, 37, 42, 49, 58, 69, 82, 97, 114, 133, 154, 177, 202, 229, 2, 33, 66, 101, 138;
              68, 69, 72, 77, 84, 93, 104, 117, 132, 149, 168, 189, 212, 237, 8, 37, 68, 101, 136, 173;
              105, 106, 109, 114, 121, 130, 141, 154, 169, 186, 205, 226, 249, 18, 45, 74, 105, 138, 173, 210];

    numLevels=2    % levels number
    window=4       % window size
    iterations=1   % iterations number
else
    im1=single(rgb2gray(imread('/Users/b/Documents/src/MIT/tiramisu/utils/images/rgb.png')));
    im2=single(rgb2gray(imread('/Users/b/Documents/src/MIT/tiramisu/utils/images/rgb.png')));
    numLevels = 3;   % levels number
    window = 32;     % window size
    iterations = 3;  % iterations number
end

alpha = 0.001;  % regularization
hw = floor(window/2);

tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%pyramids creation
pyramid1 = im1;
pyramid2 = im2;

%init
for i=2:numLevels
    im1 = impyramid(im1, 'reduce');
    im2 = impyramid(im2, 'reduce');
    pyramid1(1:size(im1,1), 1:size(im1,2), i) = im1;
    pyramid2(1:size(im2,1), 1:size(im2,2), i) = im2;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Processing all levels
for p = 1:numLevels
    %current pyramid
    im1 = pyramid1(1:(size(pyramid1,1)/(2^(numLevels - p))), 1:(size(pyramid1,2)/(2^(numLevels - p))), (numLevels - p)+1);
    im2 = pyramid2(1:(size(pyramid2,1)/(2^(numLevels - p))), 1:(size(pyramid2,2)/(2^(numLevels - p))), (numLevels - p)+1);

    %init
    if p==1
        u=zeros(size(im1));
        v=zeros(size(im1));
    else  
        %resizing
        u = 2 * imresize(u,size(u)*2,'bilinear');   
        v = 2 * imresize(v,size(v)*2,'bilinear');
    end

    %refinment loop
    for r = 1:iterations
   
        u=round(u);
        v=round(v);
    
        %every pixel loop
        for i = 1+hw:size(im1,1)-hw
            for j = 1+hw:size(im2,2)-hw
                  patch1 = im1(i-hw:i+hw, j-hw:j+hw);

                  %moved patch
                  lr = i-hw+v(i,j);
                  hr = i+hw+v(i,j);
                  lc = j-hw+u(i,j);
                  hc = j+hw+u(i,j);

                  if (lr < 1)||(hr > size(im1,1))||(lc < 1)||(hc > size(im1,2))  
                  %Regularized least square processing
                  else
                  patch2 = im2(lr:hr, lc:hc);

                  fx = conv2(patch1, 0.25* [-1 1; -1 1]) + conv2(patch2, 0.25*[-1 1; -1 1]);
                  fy = conv2(patch1, 0.25* [-1 -1; 1 1]) + conv2(patch2, 0.25*[-1 -1; 1 1]);
                  ft = conv2(patch1, 0.25*ones(2)) + conv2(patch2, -0.25*ones(2));

                  Fx = fx(2:window-1,2:window-1)';
                  Fy = fy(2:window-1,2:window-1)';
                  Ft = ft(2:window-1,2:window-1)';
                  A = [Fx(:) Fy(:)];      

                  U = pinv(A) * -Ft(:);
                  u(i,j) = u(i,j) + U(1);
                  v(i,j) = v(i,j) + U(2);
                  end
            end
        end
    end
end

toc

u
v

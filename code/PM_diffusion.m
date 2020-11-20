function image = PM_diffusion(image, lambda, sigma, type)

% INPUT ARGUMENTS : 
%          
%           image      -     input image in gray scale (N*N*1)
%           lambda     -     contrast threshold
%           sigma      -     scale parameter
%           T          -     diffusion time
%           type       -     diffusitivity model type
% 
% OUTPUT ARGUMENTS : 
% 
%           smoothedIm -     smoothed image
% 
% 
%           |-----------|-----------|-----------|
%           |           |           |           |
%           |  Ui-1_j-1 |   Ui_j-1  |  Ui+1_j-1 |
%           |           |           |           |
%           |-----------|-----------|-----------|
%           |           |           |           |
%           |   Ui-1_j  |    Ui_j   |  Ui+1_j   |
%           |           |           |           |
%           |-----------|-----------|-----------|
%           |           |           |           |
%           |  Ui-1_j+1 |   Ui_j+1  | Ui+1_j+1  |
%           |           |           |           |
%           |-----------|-----------|-----------|
% 
% 

assert( length(size(image)) == 2, 'Number of image channels must be 1!');

% d_U  - difference of  Ui_j-1 and Ui_j
  d_U = [0  1  0; 
         0 -1  0; 
         0  0  0];
     
% d_D  - difference of  Ui_j+1 and Ui_j
  d_D = [0  0  0; 
         0 -1  0; 
         0  1  0];

% d_R  - difference of  Ui+1_j and Ui_j
  d_R = [0  0  0; 
         0 -1  1; 
         0  0  0];

% d_L  - difference of  Ui-1_j and Ui_j
  d_L = [0  0  0; 
         1 -1  0; 
         0  0  0];

%   take difference of  Ui_j-1 and Ui_j  
  derOfU = conv2(image, d_U, 'same');

%   take difference of  Ui_j+1 and Ui_j   
  derOfD = conv2(image, d_D, 'same');

%   take difference of  Ui+1_j and Ui_j
  derOfR = conv2(image, d_R, 'same');

%   take difference of  Ui-1_j and Ui_j
  derOfL = conv2(image, d_L, 'same');

  switch type
      case 'PM_type_1'
          % g(|x|) = exp(-|x|^2 / lambda^2)
          g_U = exp(-(derOfU/lambda).^2);
          g_D = exp(-(derOfD/lambda).^2);
          g_R = exp(-(derOfR/lambda).^2);
          g_L = exp(-(derOfL/lambda).^2);
      case 'PM_type_2' 
          % g(|x|) = 1/(1 + |x|^2 / lambda^2)
          g_U = 1./(1 + (derOfU/lambda).^2);
          g_D = 1./(1 + (derOfD/lambda).^2);
          g_R = 1./(1 + (derOfR/lambda).^2);
          g_L = 1./(1 + (derOfL/lambda).^2);
      case 'Charbonnier'
          % g(|x|) = 1/sqrt(1 + |x|^2 / lambda^2)
          g_U = 1./sqrt(1 + (derOfU/lambda).^2);
          g_D = 1./sqrt(1 + (derOfD/lambda).^2);
          g_R = 1./sqrt(1 + (derOfR/lambda).^2);
          g_L = 1./sqrt(1 + (derOfL/lambda).^2);
      case 'Linear'
        % Linear Transformation
          g_U = 1;
          g_D = 1;
          g_R = 1;
          g_L = 1;
      otherwise
          assert(false, 'You need to give valid diffusitivity model type!');
        
  end
  
  image = image + sigma*(g_U.*derOfU + ...
                             g_D.*derOfD + ...
                             g_R.*derOfR + ...
                             g_L.*derOfL) ;

   
end

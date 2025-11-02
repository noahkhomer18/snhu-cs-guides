% IMAGE COMPRESSION TEMPLATE
% Structure for Parts 5 & 6 of the assignment

%% Part 5: Load Image and Derive k for CR ≈ 2
% Step 1: Load the image from image.mat
% load('image.mat');  % Adjust filename if needed
% A_image = ...;  % Extract image matrix from loaded data

% Step 2: Display original image
% figure;
% imshow(A_image);
% title('Original Image');

% Step 3: Get image dimensions
% [m, n] = size(A_image);
% Original storage = m * n

% Step 4: Derive k for compression ratio ≈ 2
% CR_target = 2;
% k = round((m * n) / (CR_target * (m + n + 1)));
% fprintf('For CR ≈ %d, use k = %d\n', CR_target, k);

% Step 5: Compute SVD of image
% [U_img, S_img, V_img] = svd(double(A_image));

% Step 6: Construct rank-k approximation
% U_k = U_img(:, 1:k);
% S_k = S_img(1:k, 1:k);
% V_k = V_img(:, 1:k);
% A_k = U_k * S_k * V_k';

%% Part 6: Analysis for Multiple CR Values
% Repeat for CR ≈ 2, 10, 25, 75

% CR_values = [2, 10, 25, 75];
% 
% for i = 1:length(CR_values)
%     cr = CR_values(i);
%     
%     % Calculate k for this CR
%     k = round((m * n) / (cr * (m + n + 1)));
%     
%     % Construct approximation
%     U_k = U_img(:, 1:k);
%     S_k = S_img(1:k, 1:k);
%     V_k = V_img(:, 1:k);
%     A_k = U_k * S_k * V_k';
%     
%     % Display approximate image
%     figure;
%     imshow(uint8(A_k));  % Convert back to uint8 for display
%     title(sprintf('Rank-%d Approximation (CR ≈ %d)', k, cr));
%     
%     % Calculate RMSE
%     error = rmse_helper(double(A_image), A_k);
%     fprintf('CR ≈ %d: RMSE = %.4f\n', cr, error);
%     
%     % Save image for report (optional)
%     % imwrite(uint8(A_k), sprintf('approx_CR%d.png', cr));
% end

%% Analysis Section (write in report, not code)
% 1. Describe trends as CR increases
%    - How does image quality change?
%    - How does RMSE change?
%    - What happens to visible artifacts?
%
% 2. Recommend "best CR"
%    - Consider: quality vs. compression
%    - Justify based on your observations
%    - Consider use case (storage vs. visual quality)


% GOOD STYLE EXAMPLE: How to Structure Your Code
% This demonstrates proper commenting, organization, and output formatting

%% Part 1: Rank-1 Approximation
% Clear section header with part number
% Explain what this section does

% Step 1: Load or define matrix
% (Replace with your assignment matrix)
A = [1 2 3; 3 3 4; 5 2 7];  % Assignment matrix A

% Step 2: Compute SVD
[U, S, V] = svd(A);

% Step 3: Extract components for rank-1
u1 = U(:, 1);
sigma1 = S(1, 1);
v1 = V(:, 1);

% Step 4: Construct rank-1 approximation
A1 = u1 * sigma1 * v1';

% Step 5: Round to 4 decimal places (as required)
A1_rounded = round(A1, 4);

% Step 6: Display result clearly labeled
fprintf('=== Part 1: Rank-1 Approximation ===\n');
fprintf('A1 (rounded to 4 decimals):\n');
disp(A1_rounded);

% Step 7: Calculate and display RMSE
error1 = rmse_helper(A, A1);
fprintf('RMSE between A and A1: %.4f\n\n', error1);

%% Part 2: Rank-2 Approximation
% Same structure, clearly separated

[U, S, V] = svd(A);  % Recompute or reuse from above

U2 = U(:, 1:2);
S2 = S(1:2, 1:2);
V2 = V(:, 1:2);

A2 = U2 * S2 * V2';
A2_rounded = round(A2, 4);

fprintf('=== Part 2: Rank-2 Approximation ===\n');
fprintf('A2 (rounded to 4 decimals):\n');
disp(A2_rounded);

error2 = rmse_helper(A, A2);
fprintf('RMSE between A and A2: %.4f\n', error2);

% Analysis
fprintf('\nComparison:\n');
if error2 < error1
    fprintf('A2 is better (lower RMSE = less error)\n');
else
    fprintf('A1 is better (lower RMSE = less error)\n');
end

%% Key Style Points:
% 1. Clear section headers with %%
% 2. Inline comments explaining each step
% 3. Labeled outputs using fprintf
% 4. Consistent rounding (4 decimals)
% 5. Analysis included with output
% 6. Code is readable and well-organized


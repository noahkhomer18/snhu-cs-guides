% TEACHING EXAMPLES: SVD and Matrix Approximations
% Note: This uses EXAMPLE data, not assignment data
% Purpose: Demonstrate methodology and MATLAB syntax

%% Example Matrix (DIFFERENT from assignment)
% Using a 3x3 example matrix to show structure
B = [2 1 4;
     1 3 2;
     4 2 5];

%% PART 1 EXAMPLE: Rank-1 Approximation
% Compute SVD
[U, S, V] = svd(B);

% Rank-1: use only first singular value/vectors
U1 = U(:, 1);           % First column of U
S1 = S(1, 1);           % First singular value
V1 = V(:, 1);           % First column of V

% Construct rank-1 approximation
B1 = U1 * S1 * V1';

% Display result (rounded to 4 decimals)
B1_rounded = round(B1, 4);
fprintf('Rank-1 Approximation B1:\n');
disp(B1_rounded);

% Calculate RMSE (assuming you have rmse_helper.m)
% error1 = rmse_helper(B, B1);
% fprintf('RMSE (B to B1): %.4f\n', error1);

%% PART 2 EXAMPLE: Rank-2 Approximation
% Rank-2: use first two singular values/vectors
U2 = U(:, 1:2);         % First two columns
S2 = S(1:2, 1:2);       % First two singular values (diagonal)
V2 = V(:, 1:2);         % First two columns

% Construct rank-2 approximation
B2 = U2 * S2 * V2';

% Display result (rounded to 4 decimals)
B2_rounded = round(B2, 4);
fprintf('\nRank-2 Approximation B2:\n');
disp(B2_rounded);

% Calculate RMSE
% error2 = rmse_helper(B, B2);
% fprintf('RMSE (B to B2): %.4f\n', error2);

%% PART 3 EXAMPLE: Vector Operations on U Matrix
% Extract columns
u1 = U(:, 1);
u2 = U(:, 2);
u3 = U(:, 3);

% Dot product d1 = dot(u1, u2)
d1 = dot(u1, u2);
fprintf('\nDot product d1 = dot(u1, u2): %.6f\n', d1);

% Cross product c = cross(u1, u2)
c = cross(u1, u2);
fprintf('Cross product c = cross(u1, u2):\n');
disp(c);

% Dot product d2 = dot(c, u3)
d2 = dot(c, u3);
fprintf('Dot product d2 = dot(c, u3): %.6f\n', d2);

% EXPLANATION NOTE:
% The U matrix columns should be orthonormal, so:
% - d1 should be approximately 0 (orthogonal)
% - d2 relates to the orientation/volume spanned

%% PART 4 EXAMPLE: Span Check
% Method 1: Check rank
rank_U = rank(U);
fprintf('\nRank of U matrix: %d\n', rank_U);

% Method 2: Check determinant (if square)
if size(U, 1) == size(U, 2)
    det_U = det(U);
    fprintf('Determinant of U: %.6f\n', det_U);
    % Non-zero determinant means columns are linearly independent
end

% Method 3: Check if columns are linearly independent
% Reduced row echelon form
rref_U = rref(U);
fprintf('Reduced row echelon form of U:\n');
disp(rref_U);

% Conclusion: If rank = 3 (for 3x3), columns span R^3


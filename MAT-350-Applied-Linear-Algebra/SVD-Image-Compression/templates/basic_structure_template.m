% BASIC STRUCTURE TEMPLATE
% Fill in with your assignment matrix and calculations

%% Define Matrix
% Replace with your assignment matrix A
A = [1 2 3;
     3 3 4;
     5 2 7];

%% Compute SVD
[U, S, V] = svd(A);

% U = [u1 u2 u3] where each ui is a column
% S = diagonal matrix of singular values
% V = [v1 v2 v3] where each vi is a column

%% Rank-1 Approximation (Part 1)
% Extract first components
% u1 = U(:, 1);
% sigma1 = S(1, 1);
% v1 = V(:, 1);
%
% Construct A1 = u1 * sigma1 * v1'
% Round to 4 decimals: round(A1, 4)
% Calculate RMSE: rmse_helper(A, A1)

%% Rank-2 Approximation (Part 2)
% Extract first two components
% U2 = U(:, 1:2);
% S2 = S(1:2, 1:2);
% V2 = V(:, 1:2);
%
% Construct A2 = U2 * S2 * V2'
% Round to 4 decimals: round(A2, 4)
% Calculate RMSE: rmse_helper(A, A2)
% Compare RMSE values to determine which is better

%% Vector Operations (Part 3)
% Extract U columns
% u1 = U(:, 1);
% u2 = U(:, 2);
% u3 = U(:, 3);
%
% d1 = dot(u1, u2)
% c = cross(u1, u2)
% d2 = dot(c, u3)
%
% Explain: Do these values make sense?
% (Think about orthogonality properties of U)

%% Span Check (Part 4)
% Method options:
% 1. rank(U) == 3  (for 3x3 matrix)
% 2. det(U) ~= 0
% 3. rref(U) == eye(3)
%
% Conclusion: If independent, columns span R^3


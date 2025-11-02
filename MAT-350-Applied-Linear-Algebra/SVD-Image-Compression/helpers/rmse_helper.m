function error = rmse_helper(original, approximation)
%RMSE_HELPER Calculate Root Mean Square Error between two matrices
%   INPUTS:
%       original - Original matrix (m x n)
%       approximation - Approximated matrix (m x n, same size)
%   OUTPUT:
%       error - Root Mean Square Error (scalar)
%
%   Example usage:
%       A = [1 2; 3 4];
%       A1 = [1.1 1.9; 3.2 3.8];
%       error = rmse_helper(A, A1);

% Compute element-wise difference
diff = original - approximation;

% Square each element
squared_diff = diff .^ 2;

% Compute mean of squared differences
mean_squared = mean(squared_diff(:));

% Take square root
error = sqrt(mean_squared);

end


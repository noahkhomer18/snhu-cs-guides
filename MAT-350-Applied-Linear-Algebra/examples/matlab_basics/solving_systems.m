%% Solving Linear Systems in MATLAB
% This script demonstrates how to solve linear systems Ax = b

%% Example 1: Simple 2x2 System
% System: 2x + 3y = 7
%         4x - y = 1

A1 = [2 3; 4 -1];
b1 = [7; 1];

% Solve using backslash operator
x1 = A1 \ b1;
disp('Solution to 2x2 system:');
disp(['x = ', num2str(x1(1))]);
disp(['y = ', num2str(x1(2))]);

% Verify solution
verification1 = A1 * x1;
disp('Verification (should equal b1):');
disp(verification1);

%% Example 2: 3x3 System
% System: x + 2y + 3z = 14
%         2x + 5y + 2z = 18
%         6x - 3y + z = -2

A2 = [1 2 3; 2 5 2; 6 -3 1];
b2 = [14; 18; -2];

% Solve the system
x2 = A2 \ b2;
disp('Solution to 3x3 system:');
disp(['x = ', num2str(x2(1))]);
disp(['y = ', num2str(x2(2))]);
disp(['z = ', num2str(x2(3))]);

% Verify solution
verification2 = A2 * x2;
disp('Verification (should equal b2):');
disp(verification2);

%% Example 3: Overdetermined System (Least Squares)
% More equations than unknowns
A3 = [1 1; 1 2; 1 3; 1 4];
b3 = [2; 3; 5; 6];

% Solve using least squares
x3 = A3 \ b3;
disp('Least squares solution:');
disp(['x = ', num2str(x3(1))]);
disp(['y = ', num2str(x3(2))]);

% Calculate residual
residual = A3 * x3 - b3;
disp('Residual vector:');
disp(residual);
disp('Sum of squared residuals:');
disp(sum(residual.^2));

%% Example 4: Using LU Decomposition
% For the 3x3 system from Example 2
[L, U, P] = lu(A2);
disp('LU decomposition of A2:');
disp('Lower triangular L:');
disp(L);
disp('Upper triangular U:');
disp(U);
disp('Permutation matrix P:');
disp(P);

% Solve using LU decomposition
y = L \ (P * b2);
x_lu = U \ y;
disp('Solution using LU decomposition:');
disp(x_lu);

%% Example 5: Checking System Properties
% Check if matrix is invertible
if det(A2) ~= 0
    disp('Matrix A2 is invertible');
    A2_inv = inv(A2);
    disp('Inverse of A2:');
    disp(A2_inv);
else
    disp('Matrix A2 is singular (not invertible)');
end

% Check condition number
cond_num = cond(A2);
disp(['Condition number of A2: ', num2str(cond_num)]);
if cond_num > 1000
    disp('Warning: Matrix is ill-conditioned');
end

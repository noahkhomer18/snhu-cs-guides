%% Matrix Operations in MATLAB
% This script demonstrates basic matrix operations in MATLAB

%% Creating Matrices
% Create a 3x3 matrix
A = [1 2 3; 4 5 6; 7 8 9];
disp('Matrix A:');
disp(A);

% Create a column vector
b = [1; 2; 3];
disp('Vector b:');
disp(b);

% Create a row vector
c = [1 2 3];
disp('Vector c:');
disp(c);

% Create identity matrix
I = eye(3);
disp('Identity matrix I:');
disp(I);

% Create zero matrix
Z = zeros(2, 3);
disp('Zero matrix Z:');
disp(Z);

% Create matrix of ones
O = ones(2, 2);
disp('Ones matrix O:');
disp(O);

%% Basic Matrix Operations
% Matrix addition
B = [9 8 7; 6 5 4; 3 2 1];
C = A + B;
disp('A + B:');
disp(C);

% Matrix multiplication
D = A * B;
disp('A * B:');
disp(D);

% Element-wise multiplication
E = A .* B;
disp('A .* B (element-wise):');
disp(E);

% Matrix transpose
A_transpose = A';
disp('A transpose:');
disp(A_transpose);

% Matrix power
A_squared = A^2;
disp('A^2:');
disp(A_squared);

%% Vector Operations
% Dot product
v1 = [1 2 3];
v2 = [4 5 6];
dot_product = dot(v1, v2);
disp('Dot product of v1 and v2:');
disp(dot_product);

% Cross product (for 3D vectors)
v3 = [1 2 3];
v4 = [4 5 6];
cross_product = cross(v3, v4);
disp('Cross product of v3 and v4:');
disp(cross_product);

% Vector norm
norm_v1 = norm(v1);
disp('Norm of v1:');
disp(norm_v1);

%% Matrix Properties
% Determinant
det_A = det(A);
disp('Determinant of A:');
disp(det_A);

% Trace
trace_A = trace(A);
disp('Trace of A:');
disp(trace_A);

% Rank
rank_A = rank(A);
disp('Rank of A:');
disp(rank_A);

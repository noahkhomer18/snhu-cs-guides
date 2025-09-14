%% Vector Spaces and Subspaces in MATLAB
% This script demonstrates concepts of vector spaces, subspaces, and bases

%% Example 1: Span of Vectors
% Check if vectors span a space
v1 = [1; 2; 3];
v2 = [2; 4; 6];
v3 = [1; 1; 1];

% Create matrix with vectors as columns
A = [v1, v2, v3];
disp('Matrix A with vectors as columns:');
disp(A);

% Check rank and dimension of column space
rank_A = rank(A);
disp(['Rank of A: ', num2str(rank_A)]);
disp(['Dimension of column space: ', num2str(rank_A)]);

% Check if vectors are linearly independent
if rank_A == size(A, 2)
    disp('Vectors are linearly independent');
else
    disp('Vectors are linearly dependent');
end

%% Example 2: Finding a Basis for Column Space
% Use QR decomposition to find orthonormal basis
[Q, R] = qr(A);
disp('QR decomposition:');
disp('Q (orthonormal basis for column space):');
disp(Q);
disp('R (upper triangular):');
disp(R);

% The first rank_A columns of Q form an orthonormal basis
basis_col_space = Q(:, 1:rank_A);
disp('Orthonormal basis for column space:');
disp(basis_col_space);

%% Example 3: Null Space
% Find null space of matrix A
null_space = null(A);
disp('Null space of A:');
disp(null_space);

% Verify: A * null_space should be zero
verification = A * null_space;
disp('Verification (A * null_space should be zero):');
disp(verification);

%% Example 4: Row Space and Left Null Space
% Row space is the column space of A'
row_space = A';
[Q_row, R_row] = qr(row_space);
basis_row_space = Q_row(:, 1:rank_A);
disp('Basis for row space:');
disp(basis_row_space);

% Left null space is the null space of A'
left_null_space = null(A');
disp('Left null space:');
disp(left_null_space);

%% Example 5: Orthogonal Complement
% Given a subspace, find its orthogonal complement
% Let S be the span of v1 and v2
S = [v1, v2];
disp('Subspace S (span of v1 and v2):');
disp(S);

% Find orthogonal complement of S
S_complement = null(S');
disp('Orthogonal complement of S:');
disp(S_complement);

% Verify orthogonality
orthogonality_check = S' * S_complement;
disp('Verification of orthogonality (should be zero):');
disp(orthogonality_check);

%% Example 6: Projection onto Subspace
% Project vector b onto subspace spanned by columns of A
b = [1; 0; 0];
disp('Vector to project:');
disp(b);

% Projection formula: P = A(A'A)^(-1)A'
projection_matrix = A * inv(A' * A) * A';
projection = projection_matrix * b;
disp('Projection of b onto column space of A:');
disp(projection);

% Alternative method using QR decomposition
[Q, R] = qr(A);
projection_alt = Q * Q' * b;
disp('Projection using QR method:');
disp(projection_alt);

%% Example 7: Change of Basis
% Given coordinates in one basis, find coordinates in another basis
% Original basis: standard basis {e1, e2, e3}
% New basis: columns of matrix B
B = [1 1 0; 0 1 1; 1 0 1];
disp('New basis B:');
disp(B);

% Vector in standard coordinates
v_standard = [2; 3; 4];
disp('Vector in standard coordinates:');
disp(v_standard);

% Convert to new basis coordinates
v_new_basis = B \ v_standard;
disp('Vector in new basis coordinates:');
disp(v_new_basis);

% Verify: B * v_new_basis should equal v_standard
verification = B * v_new_basis;
disp('Verification:');
disp(verification);

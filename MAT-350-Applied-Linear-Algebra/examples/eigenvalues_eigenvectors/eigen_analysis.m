%% Eigenvalue and Eigenvector Analysis in MATLAB
% This script demonstrates eigenvalue decomposition and applications

%% Example 1: Basic Eigenvalue Decomposition
% Create a symmetric matrix
A = [4 1; 1 4];
disp('Matrix A:');
disp(A);

% Find eigenvalues and eigenvectors
[eigenvectors, eigenvalues] = eig(A);
disp('Eigenvalues:');
disp(diag(eigenvalues));
disp('Eigenvectors (columns):');
disp(eigenvectors);

% Verify: Av = λv
lambda1 = eigenvalues(1,1);
v1 = eigenvectors(:,1);
verification1 = A * v1;
expected1 = lambda1 * v1;
disp('Verification for first eigenpair:');
disp('A * v1:');
disp(verification1);
disp('λ1 * v1:');
disp(expected1);

%% Example 2: Power Method for Dominant Eigenvalue
% Find the largest eigenvalue iteratively
function [lambda, v] = power_method(A, max_iter, tolerance)
    % Initialize with random vector
    n = size(A, 1);
    v = rand(n, 1);
    v = v / norm(v);
    
    for i = 1:max_iter
        v_old = v;
        v = A * v;
        lambda = norm(v);
        v = v / lambda;
        
        % Check convergence
        if norm(v - v_old) < tolerance
            break;
        end
    end
end

% Apply power method
[lambda_dominant, v_dominant] = power_method(A, 100, 1e-6);
disp('Power method results:');
disp(['Dominant eigenvalue: ', num2str(lambda_dominant)]);
disp('Dominant eigenvector:');
disp(v_dominant);

%% Example 3: Matrix Powers and Eigenvalues
% If A has eigenvalues λ₁, λ₂, ..., λₙ
% Then A^k has eigenvalues λ₁ᵏ, λ₂ᵏ, ..., λₙᵏ

k = 3;
A_power = A^k;
[eigenvectors_power, eigenvalues_power] = eig(A_power);
disp('Eigenvalues of A^3:');
disp(diag(eigenvalues_power));
disp('Original eigenvalues raised to power 3:');
disp(diag(eigenvalues).^k);

%% Example 4: Diagonalization
% A = PDP^(-1) where P contains eigenvectors and D contains eigenvalues
P = eigenvectors;
D = eigenvalues;
A_reconstructed = P * D * inv(P);
disp('Original matrix A:');
disp(A);
disp('Reconstructed A = PDP^(-1):');
disp(A_reconstructed);
disp('Difference (should be near zero):');
disp(A - A_reconstructed);

%% Example 5: Applications - Stability Analysis
% For discrete dynamical system x(k+1) = Ax(k)
% System is stable if all eigenvalues have |λ| < 1

% Create a matrix for stability analysis
B = [0.8 0.2; 0.1 0.9];
[eigenvectors_B, eigenvalues_B] = eig(B);
eigenvalues_B_diag = diag(eigenvalues_B);

disp('Matrix B for stability analysis:');
disp(B);
disp('Eigenvalues of B:');
disp(eigenvalues_B_diag);

% Check stability
max_eigenvalue_magnitude = max(abs(eigenvalues_B_diag));
if max_eigenvalue_magnitude < 1
    disp('System is stable (all |λ| < 1)');
else
    disp('System is unstable (at least one |λ| ≥ 1)');
end

%% Example 6: Principal Component Analysis (PCA) Preview
% Create sample data
data = [1 2; 2 4; 3 6; 4 8; 5 10];
data_centered = data - mean(data);

% Covariance matrix
cov_matrix = (data_centered' * data_centered) / (size(data, 1) - 1);
[eigenvectors_pca, eigenvalues_pca] = eig(cov_matrix);

disp('Sample data:');
disp(data);
disp('Covariance matrix:');
disp(cov_matrix);
disp('PCA eigenvalues (variance explained):');
disp(diag(eigenvalues_pca));
disp('PCA eigenvectors (principal components):');
disp(eigenvectors_pca);

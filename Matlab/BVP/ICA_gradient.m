function [ic1, ic2]     = ICA_gradient(s1, s2)

  if(nargin > 1)
    %seed = 10; 
    %rng(seed);
    n = 2;
    N = size(s1,1);
	
	%set variance of each source to unity
	% TBD: apply zscore?...
    s1=s1-mean(s1);
    s2=s2-mean(s2);
    s1=s1/std(s1);
    s2=s2/std(s2);

    %combine signals
    s=[s1, s2];
	%make new mixing matrix --> this matrix is not known
    A = randn(n,n);
	%make n mixtures (x) from n source signals
    x = s*A;
	% figure
    % plot(x(:,1))
    % title('x1 input to ICA');
    % figure
    % plot(x(:,2))
    % title('x2 input to ICA');
    
    %Preprocessing: Sphering
    %1. Centering:
    % figure
    % scatter((x(:,1)),(x(:,2)))
    % title('x1 x2 scatter before centering');
    Mu = mean(x);
    x = x - repmat(Mu,[N,1]);
	% figure
    % scatter((x(:,1)),(x(:,2)))
    % title('x1 x2 scatter after centering');
	
	
    %[U, S, ~] = svd(x,'econ');
    %T  = U * diag(1 ./ sqrt(diag(S))) * U';
    %Zcw = T * x;
	
	%2.Whitenin: The observed vector x is linearly transformed to obtain a vector that is white, which
    % means its components are uncorrelated and the variance is equal to unity
    %[V,D] = eig(A) devuelve la matriz diagonal D de los valores propios y la matriz V cuyas columnas son los vectores propios derechos correspondientes, de manera que A*V = V*D
    % A = V*D*V' --> A = I = x*x' --> x^hat = V*D^(-1/2)*V'*x
    Sx = x'*x;
    [V,D] = eig(Sx);
    x = V*sqrt(inv(D))*V'*x';
    x = x';
	
	% Initialize un-mixing matrix W: it extracts n components u = (u1,...)
    % where, ui = wi'*x . We seek an un-mixing W that maximizes the entropy
    % of U, the un-mixed output sequences 
    W = eye(n,n);
	
	% Initilize u, the estimated source signals --> U = W*X;
    u = x*W;
	
    maxiter = 1000;
    eta = 0.25;
	% Functions and gradient magnitude
    hs = zeros(maxiter,1);
    gs = zeros(maxiter,1);
    for iter = 1:maxiter
        u=x*W;
        U=tanh(u);
        detW = abs(det(W));
        h = ((1/N)*sum(sum(U)) + 0.5*log(detW));
        g = inv(W') - (2/N)*x'*U;
        W= W + eta*g;
        hs(iter) = h;
        gs(iter) = norm(g(:));
    end
    ic1 = u(:,1);
    ic2 = u(:,2);
  elseif(nargin == 1)
%     seed = 10; 
%     rng(seed);
    n = size(s1,2);
    N = size(s1,1);
	%zero mean ¡, unity variance
    for k=1:n
       s1(:,k)=s1(:,k)-mean(s1(:,k)); 
    end
    for k=1:n
       s1(:,k)=s1(:,k)/std(s1(:,k)); 
    end
	
    s = zeros(N,n);
    for k=1:n
       s(:,k) = s1(:,k);
    end
	
    A = randn(n,n);
    x = s*A;
    %Preprocessing: Sphering
    %1. Centering:
    Mu = mean(x);
    x = x - repmat(Mu,[N,1]);
    %[U, S, ~] = svd(x,'econ');
    %T  = U * diag(1 ./ sqrt(diag(S))) * U';
    %Zcw = T * x;
    %2.Whitenin: The observed vector x is linearly transformed to obtain a vector that is white, which
    % means its components are uncorrelated and the variance is equal to unity
    Sx = x'*x;
    [V,D] = eig(Sx);
    x = V*sqrt(inv(D))*V'*x';
    x = x';
    W = eye(n,n);
    u = x*W;
    maxiter = 1000;
    eta = 0.25;
    hs = zeros(maxiter,1);
    gs = zeros(maxiter,1);
    for iter = 1:maxiter
        u=x*W;
        U=tanh(u);
        detW = abs(det(W));
        h = ((1/N)*sum(sum(U)) + 0.5*log(detW));
        g = inv(W') - (2/N)*x'*U;
        W= W + eta*g;
        hs(iter) = h;
        gs(iter) = norm(g(:));
    end
    ic1 = u;
    ic2 = W;
  end

end
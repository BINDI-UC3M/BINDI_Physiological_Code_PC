function [Zica, W, T, mu] = fastICA(Z,r,type,flag)
  A = randn(size(Z,1),size(Z,1));
  Z = A*Z;
  TOL = 1e-6;         % Convergence criteria
  MAX_ITERS = 100;    % Max # iterations
  if ~exist('flag','var') || isempty(flag)
      % Default display flag
      flag = 1;
  end
  if ~exist('type','var') || isempty(type)
      % Default type
      type = 'kurtosis';
  end
  n = size(Z,2);
  if strncmpi(type,'kurtosis',1)
      USE_KURTOSIS = true;
      algoStr = 'kurtosis';
  elseif strncmpi(type,'negentropy',1)
      USE_KURTOSIS = false;
      algoStr = 'negentropy';
  else
      error('Unsupported type ''%s''',type);
  end
  mu = mean(Z,2);
  Zc = bsxfun(@minus,Z,mu); %elimina la media de las señales
  [U, S, V] = svd(Zc,'econ');
  T  = U * diag(1 ./ sqrt(diag(S))) * U';
  Zcw = T * Zc;
  normRows = @(X) bsxfun(@rdivide,X,sqrt(sum(X.^2,2)));
  W = normRows(rand(r,size(Z,1))); % Random initial weights
  k = 0;
  delta = inf;
  while delta > TOL && k < MAX_ITERS
      k = k + 1;
      Wlast = W; % Save last weights
      Sk = W * Zcw;
      if USE_KURTOSIS
          G = 4 * Sk.^3;
          Gp = 12 * Sk.^2;
      else
          G = Sk .* exp(-0.5 * Sk.^2);
          Gp = (1 - Sk.^2) .* exp(-0.5 * Sk.^2);
      end
      W = (G * Zcw') / n - bsxfun(@times,mean(Gp,2),W);
      W = normRows(W);
      [U, S, ~] = svd(W,'econ');
      W = U * diag(1 ./ diag(S)) * U' * W;
      delta = max(1 - abs(dot(W,Wlast,2)));    
  end
  Zica = W * Zcw;
  Zica =Zica';
end
function Q = sample_map_from_prior_gibbs_sweep(Q, R, kappa)

[M N] = size(Q);

% fprintf('\n');
for i=1:M
    for j=1:N
%         fprintf('\nNeuron (%d, %d)\n',i,j);
        k_max = R*[i>1 j<N i<M j>1]';
        % Sample p(q_{i,j}|Q\q_{i,j})
        % = p(q_{i,j}|those q's adjacent to q_{i,j})
        prob_vec = [];
        mu_vec = zeros(2,0);
        for k1=0:k_max(1)
            theta_k1 = 2*pi*k1/(R+1);
            mu_k1 = [cos(theta_k1) sin(theta_k1)]';
            for k2=0:k_max(2)
                theta_k2 = 2*pi*k2/(R+1);
                mu_k2 = [cos(theta_k2) sin(theta_k2)]';
                for k3=0:k_max(3)
                    theta_k3 = 2*pi*k3/(R+1);
                    mu_k3 = [cos(theta_k3) sin(theta_k3)]';
                    for k4=0:k_max(4)
                        theta_k4 = 2*pi*k4/(R+1);
                        mu_k4 = [cos(theta_k4) sin(theta_k4)]';
                        factor = 1;
                        mu_sum = 0;
                        if i > 1
                            h = [cos(Q(i-1,j)) sin(Q(i-1,j))]';
                            factor = factor * exp(kappa * mu_k1' * h);
                            mu_sum = mu_sum + mu_k1;
                        end
                        if j < N
                            h = [cos(Q(i,j+1)) sin(Q(i,j+1))]';
                            factor = factor * exp(kappa * mu_k2' * h);
                            mu_sum = mu_sum + mu_k2;
                        end
                        if i < M
                            h = [cos(Q(i+1,j)) sin(Q(i+1,j))]';
                            factor = factor * exp(kappa * mu_k3' * h);
                            mu_sum = mu_sum + mu_k3;
                        end
                        if j > 1
                            h = [cos(Q(i,j-1)) sin(Q(i,j-1))]';
                            factor = factor * exp(kappa * mu_k4' * h);
                            mu_sum = mu_sum + mu_k4;
                        end

                        ind = strfind(reshape(mu_vec,1,[]),mu_sum');
                        if ~isempty(ind)
                            if mod(ind,2) == 1
                                ind = (ind+1)/2;
                                prob_vec(ind) = prob_vec(ind) ...
                                    + factor * 2 * pi ...
                                    * bessi0(kappa * sqrt(mu_sum'*mu_sum));
                            end
                        else
                            mu_vec(:,end+1) = mu_sum;
                            prob_vec(end+1) = factor * 2 * pi ...
                                * bessi0(kappa * sqrt(mu_sum'*mu_sum));
                        end
                    end
                end
            end
        end
        prob_vec_sample = sample_discrete(normalise(prob_vec));
        mu_sample = mu_vec(:,prob_vec_sample);
        cos_sin = mu_sample / sqrt(mu_sample' * mu_sample);
        c = cos_sin(1);
        s = cos_sin(2);
        if c > 0
            thetahat = atan(s/c);
        elseif s > 0
            thetahat = atan(s/c) + pi;
        else
            thetahat = atan(s/c) - pi;
        end
        Q(i,j) = circ_vmrnd(thetahat, kappa ...
            * sqrt(mu_sample' * mu_sample), 1);
    end
end

end
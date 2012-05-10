function Qhat_vec = estimate_map_from_posterior_sweep_alt(Qhat_vec,Y_vec,R,kq,ky)

[M N] = size(Qhat_vec);
Q = Qhat_vec;

% fprintf('\n');
for i = 1:M
    for j = 1:N
        if isnan(Q{i,j}(1))
            Q{i,j} = [0 0]';
        end
    end
end
for i=1:M
    for j=1:N
%         fprintf('\nNeuron (%d, %d)\n',i,j);
        k_max = R*[i>1 j<N i<M j>1]';
        % Sample p(q_{i,j}|Q\q_{i,j})
        % = p(q_{i,j}|those q's adjacent to q_{i,j})
        prob_vec = [];
        mu_vec = zeros(2,0);
        if ~isnan(Y_vec{i,j}(1))
            y = Y_vec{i,j};
        else
            y = [0 0]';
        end
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
                            h = Q{i-1,j};
                            factor = factor * exp(mu_k1' * h);
                            mu_sum = mu_sum + mu_k1;
                        end
                        if j < N
                            h = Q{i,j+1};
                            factor = factor * exp(mu_k2' * h);
                            mu_sum = mu_sum + mu_k2;
                        end
                        if i < M
                            h = Q{i+1,j};
                            factor = factor * exp(mu_k3' * h);
                            mu_sum = mu_sum + mu_k3;
                        end
                        if j > 1
                            h = Q{i,j-1};
                            factor = factor * exp(mu_k4' * h);
                            mu_sum = mu_sum + mu_k4;
                        end
                        mu_sum = mu_sum + y;
%                         h = Q{i,j};
%                         factor = factor * exp(ky * y' * h);
                        
                        ind = strfind(reshape(mu_vec,1,[]),mu_sum');
                        if ~isempty(ind)
                            if mod(ind,2) == 1
                                ind = (ind+1)/2;
                                prob_vec(ind) = prob_vec(ind) ...
                                    + factor ...
                                    * bessi0(sqrt(mu_sum'*mu_sum));
                            end
                        else
                        mu_vec(:,end+1) = mu_sum;
                        prob_vec(end+1) = factor ...
                            * bessi0(sqrt(mu_sum'*mu_sum));
                        end
                    end
                end
            end
        end
        prob_vec = normalise(prob_vec);
        q_vec = 0;
        for m = 1:length(prob_vec)
            q_vec = q_vec + prob_vec(m) * mu_vec(:,m);
        end
        Q{i,j} = q_vec;
    end
end
Qhat_vec = Q;

Q_angle = zeros(M,N);
for i = 1:M
    for j = 1:N
        cos_sin = Q{i,j} / sqrt(Q{i,j}' *  Q{i,j});
        c = cos_sin(1);
        s = cos_sin(2);
        if c > 0
            q_angle = atan(s/c);
        elseif s > 0
            q_angle = atan(s/c) + pi;
        else
            q_angle = atan(s/c) - pi;
        end
        Q_angle(i,j) = q_angle;
    end
end
figure(2)
imagesc(mod(Q_angle,pi))
colorbar
colormap 'hsv'
caxis([0 pi])

end
function Qhat_vec_array = create_frames_estimation(Y, R, kq, ky, nGibbs)

if nargin < 5 nGibbs = 10; end
if nargin < 4 ky = 2; end

Qhat_vec_array = cell(nGibbs,1);
[M N] = size(Y{1,1});
Qhat_vec_array{1,1} = cell(M,N);
for i=1:M
    for j=1:N
        Qhat_vec_array{1,1}{i,j} = [0 0]';
    end
end
for i=1:M
    for j=1:N
        for k = 1:size(Y,1)
            if (Y{k}(i,j)~=Inf)
                Qhat_vec_array{1,1}{i,j} = Qhat_vec_array{1,1}{i,j} ...
                    + [cos(Y{k}(i,j)) sin(Y{k}(i,j))]';
            end
        end
    end
end
Y_vec = Qhat_vec_array{1,1};
keep_going = 1;
while keep_going
    keep_going = 0;
    for i=1:M
        for j=1:N
            q = Qhat_vec_array{1,1}{i,j};
            if (Y{1}(i,j)==Inf && q'*q == 0)
                Qhat_vec_array{1,1}{i,j} = 0;
                if i>1
                    q = Qhat_vec_array{1,1}{i-1,j};
                    Qhat_vec_array{1,1}{i,j} = Qhat_vec_array{1,1}{i,j} ...
                        + q * (q'*q~=0);
                end
                if i<M
                    q = Qhat_vec_array{1,1}{i+1,j};
                    Qhat_vec_array{1,1}{i,j} = Qhat_vec_array{1,1}{i,j} ...
                        + q * (q'*q~=0);
                end
                if j>1
                    q = Qhat_vec_array{1,1}{i,j-1};
                    Qhat_vec_array{1,1}{i,j} = Qhat_vec_array{1,1}{i,j} ...
                        + q * (q'*q~=0);
                end
                if j<N
                    q = Qhat_vec_array{1,1}{i,j+1};
                    Qhat_vec_array{1,1}{i,j} = Qhat_vec_array{1,1}{i,j} ...
                        + q * (q'*q~=0);
                end
                q = Qhat_vec_array{1,1}{i,j};
                Qhat_vec_array{1,1}{i,j} = q / sqrt(q'*q);
            end
            q = Qhat_vec_array{1,1}{i,j};
            if q'*q == 0
                keep_going = 1;
            end
        end
    end
end
for i = 2:nGibbs
    fprintf('\n\nEstimation. Gibbs sweep %d of %d', i, nGibbs)
    Q_vec_i = estimate_map_from_posterior_sweep( ...
        Qhat_vec_array{i-1,1},Y_vec,R,kq,ky);
    for j = 1:M
        for k = 1:N
            Qhat_vec_array{i,1}{j,k} = Qhat_vec_array{i-1,1}{j,k} * ...
                (i-1)/i + Q_vec_i{j,k}/i;
        end
    end
end

workspace_str = ['workspaces/map_estimation_N_' num2str(M*N) '_R_' ...
    num2str(R) '_kq_' num2str(kq) '_ky_' num2str(ky) ...
    '_nG_' num2str(nGibbs) '.mat'];
save(workspace_str)

end
function Qarray = create_frames_sampling(M, N, R, kq, ky, nGibbs)

if nargin < 1 M = 32; end
if nargin < 2 N = 32; end
if nargin < 3 R = 2; end
if nargin < 4 kq = 1; end
if nargin < 5 nGibbs = 10; end

Qarray = cell(nGibbs,1);
Qarray{1,1} = rand(M,N)*2*pi-pi;
for i = 2:nGibbs
    fprintf('\n\nSampling. Gibbs sweep %d of %d', i, nGibbs)
    Qarray{i,1} = ...
        sample_map_from_prior_gibbs_sweep(Qarray{i-1,1}, R, kq);
end

workspace_str = ['workspaces/map_sampling_N_' num2str(M*N) '_R_' ...
     num2str(R) '_kq_' num2str(kq) '_ky_' num2str(ky) '_nG_' ...
     num2str(nGibbs) '.mat'];
save(workspace_str)


end
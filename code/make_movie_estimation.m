function make_movie_estimation(NN,R,kq,ky,nGibbs_sampling,nGibbs_estimation,rng)
% See http://www.math.canterbury.ac.nz/~c.scarrott/MATLAB_Movies/movies.html

workspace_str = ['workspaces/map_estimation_N_' num2str(NN) '_R_' ...
    num2str(R) '_kq_' num2str(kq) '_ky_' num2str(ky) ...
     '_nG_' num2str(nGibbs_estimation) '.mat'];
load(workspace_str)

workspace_str = ['workspaces/map_sampling_N_' num2str(NN) '_R_' ...
    num2str(R) '_kq_' num2str(kq) '_ky_' num2str(ky) '_nG_' ...
    num2str(nGibbs_sampling) '.mat'];
load(workspace_str, 'Qarray')

% Pad movie with cells so that loop boundary is clear.
nPre = 2;
nPost = 1;
n_dups = 1;

fig1 = figure(1);
set(fig1,'units','normalized','outerposition',[0 0 1 1])
set(fig1,'units','pixels')
winsize = get(fig1,'Position');
winsize(1:2) = [0 0];
numframes=nPre+n_dups*nGibbs_estimation+nPost;
A=moviein(numframes,fig1,winsize);
set(fig1,'NextPlot','replacechildren')

for i=1:nPre
    plot_reconstruction(Qarray{nGibbs_sampling,1},...
        Y_vec,1,rng);
    A(:,i)=getframe(fig1,winsize);
end

for i=2:nGibbs_estimation
    for j = 1:M
        for k = 1:N
            Qhat_vec_array{i,1}{j,k} = Qhat_vec_array{i,1}{j,k}/i;
        end
    end
    plot_reconstruction(Qarray{nGibbs_sampling,1}, ...
        Qhat_vec_array{i,1},i,rng);
    for j = 1:n_dups
        A(:,n_dups*(i-1)+j+nPre)=getframe(fig1,winsize);
    end
end

for i=1:nPost
    plot_reconstruction(Qarray{nGibbs_sampling,1}, ...
        Qhat_vec_array{nGibbs_estimation,1},nGibbs_estimation,rng);
    A(:,numframes-nPost+i)=getframe(fig1,winsize);
end

save(workspace_str)
movie_str = ['movies/map_estimation_N_' num2str(N*M) '_R_' num2str(R) ...
    '_kq_' num2str(kq) '_ky_' num2str(ky)  '_nG_' ...
    num2str(nGibbs_estimation) '.mpg'];
% mpgwrite(A,jet,movie_str);
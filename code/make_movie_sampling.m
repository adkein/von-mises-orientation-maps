function A = make_movie_sampling(NN,R,kq,ky,nGibbs)
% See http://www.math.canterbury.ac.nz/~c.scarrott/MATLAB_Movies/movies.html

workspace_str = ['workspaces/map_sampling_N_' num2str(NN) '_R_' ...
    num2str(R) '_kq_' num2str(kq) '_ky_' num2str(ky) '_nG_' ...
    num2str(nGibbs) '.mat'];
movie_str = ['movies/map_sampling_N_' num2str(NN) '_R_' ...
    num2str(R) '_kq_' num2str(kq) '_ky_' num2str(ky) '_nG_' ...
    num2str(nGibbs) '.mpg'];
load(workspace_str)


% writerObj = VideoWriter('testfile.avi');
% open(writerObj);
% fig1 = figure(1);
% set(fig1,'units','normalized','outerposition',[0 0 1 1])
% set(fig1,'units','pixels')
% winsize = get(fig1,'Position');
% winsize(1:2) = [0 0];
% set(fig1,'NextPlot','replacechildren')
% set(gcf,'Renderer','opengl');
% for i = 1:5
%     plot_map(Qarray{1,1},R,kq,1);
%     frame = getframe(fig1,winsize);
%     writeVideo(writerObj,frame);
% end
% for i = 1:nGibbs
%     plot_map(Qarray{i,1},R,kq,1);
%     frame = getframe(fig1,winsize);
%     writeVideo(writerObj,frame);
% end
% for i = 1:5
%     plot_map(Qarray{nGibbs,1},R,kq,1);
%     frame = getframe(fig1,winsize);
%     writeVideo(writerObj,frame);
% end
% close(writerObj);



% % Pad movie with cells so that loop boundary is clear.
nPre = 40;
nPost = 40;
n_dups = 20;

fig1 = figure(1);
set(fig1,'units','normalized','outerposition',[0 0 1 1])
set(fig1,'units','pixels')
winsize = get(fig1,'Position');
winsize(1:2) = [0 0];
numframes=nPre+n_dups*nGibbs+nPost;
A=moviein(numframes,fig1,winsize);
set(fig1,'NextPlot','replacechildren')


plot_map(Qarray{1,1},R,kq,1);
A(:,1)=getframe(fig1,winsize);
for i=1:nPre
    A(:,i)=A(:,1);
end

for i=1:nGibbs
    plot_map(Qarray{i,1},R,kq,i);
    A(:,n_dups*(i-1)+1+nPre)=getframe(fig1,winsize);
    for j = 2:n_dups
        A(:,n_dups*(i-1)+j+nPre)=A(:,n_dups*(i-1)+1+nPre);
    end
end

plot_map(Qarray{nGibbs,1},R,kq,nGibbs);
A(:,numframes-nPost+1)=getframe(fig1,winsize);
for i=1:nPost
    A(:,numframes-nPost+i)=A(:,numframes-nPost+1);
end

save(workspace_str)
movie_str = ['movies/map_sampling_N_' num2str(N*M) '_R_' num2str(R) ...
    '_kq_' num2str(kq)  '_ky_' num2str(ky) '_nG_' num2str(nGibbs) '.mpg'];
mpgwrite(A,jet,movie_str);





% 
% nPre = 60;
% nPost = 60;
% n_dups = 30;
% numframes=nPre+n_dups*nGibbs+nPost;
% MakeQTMovie start moviestr
% MakeQTMovie framerate 1
% fig1 = figure(1);
% set(fig1,'units','normalized','outerposition',[0 0 1 1])
% set(fig1,'units','pixels')
% winsize = get(fig1,'Position');
% winsize(1:2) = [0 0];
% numframes=nPre+nGibbs+nPost;
% set(fig1,'NextPlot','replacechildren')
% 
% plot_map(Qarray{1,1},R,kq,1);
% frame_new = MakeQTMovie('addfigure',0,0,0);
%     plot_map(Qarray{1,1},R,kq,1);
% for i=1:nPre
%     MakeQTMovie('addfigure',0,0,1,frame_new)
% end
% 
% for i=1:nGibbs
%     plot_map(Qarray{i,1},R,kq,i);
%     frame_new = MakeQTMovie('addfigure',0,0,0);
%     for j = 1:n_dups-1
%         MakeQTMovie('addfigure',0,0,1,frame_new)
%     end
% end
% 
% plot_map(Qarray{nGibbs,1},R,kq,nGibbs);
% for i=1:nPost
%     MakeQTMovie('addfigure',0,0,0)
% end
% MakeQTMovie finish
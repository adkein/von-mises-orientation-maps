function plot_blank_estimation(M,N,R,kappa)

subplot(1,2,1)
imagesc(zeros(M,N))
cla
set(gca,'xtick',[])
set(gca,'ytick',[])
title(['A sample from the prior,   ' num2str(M*N) ' cells'], ...
    'interpreter', 'latex')
subplot(1,2,2)
imagesc(zeros(M,N))
cla
set(gca,'xtick',[])
set(gca,'ytick',[])
title('Reconstruction', 'interpreter', 'latex')

end
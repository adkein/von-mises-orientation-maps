function plot_blank(M,N,R,kappa)

subplot(1,2,1)
imagesc(zeros(M,N))
cla
set(gca,'xtick',[])
set(gca,'ytick',[])
title([num2str(M*N) ' cells, $\;\;\;$rank ' num2str(R) ...
    ', $\;\;\;$conc. param. ' num2str(kappa)], 'interpreter', 'latex')
subplot(1,2,2)
imagesc(zeros(M,N))
cla
set(gca,'xtick',[])
set(gca,'ytick',[])

end
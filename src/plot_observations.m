function plot_observations(Q,Y,kq,ky)

if nargin < 4
    Y = generate_von_mises_observations(Q,kq);
end

[M N] = size(Q);

subplot(1,2,1)
imagesc(Q)
pos_vec = get(gca,'position');
colorbar
colormap('hsv')
set(gca, 'position', pos_vec);
caxis([-pi pi])
set(gca,'fontsize',24)
set(gca,'xtick',[])
set(gca,'ytick',[])
title(['A sample from the prior,   ' num2str(M*N) ' cells'], ...
    'interpreter', 'latex')
subplot(1,2,2)
imagesc(Y)
pos_vec = get(gca,'position');
colorbar
colormap('hsv')
set(gca, 'position', pos_vec);
caxis([-pi pi])
set(gca,'fontsize',24)
set(gca,'xtick',[])
set(gca,'ytick',[])
title(['A noisy observation, conc. param. ' num2str(ky)], ...
    'interpreter', 'latex')

end
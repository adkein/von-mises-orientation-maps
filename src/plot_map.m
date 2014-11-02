function plot_map(Q,R,kappa,nG)

[M N] = size(Q);

subplot(1,2,1)
% imagesc(mod(Q,pi))
imagesc(Q)
pos_vec = get(gca,'position');
colorbar
colormap('hsv')
set(gca, 'position', pos_vec);
% caxis([0 pi])
caxis([-pi pi])
set(gca,'fontsize',24)
set(gca,'xtick',[])
set(gca,'ytick',[])
title([num2str(M*N) ' cells, $\;\;\;$rank ' num2str(R) ...
    ', $\;\;\;$conc. param. ' num2str(kappa)], 'interpreter', 'latex')
subplot(1,2,2)
cQ = cos(Q);
sQ = sin(Q);
y = repmat((1:M)',N,1);
x = [];
for k = 1:N
    x = [x; k*ones(M,1)];
end
u = reshape(cQ,M*N,1);
v = reshape(sQ,M*N,1);
h = quiver(x, y, u, -v, 0.5, 'linestyle', '-', 'linewidth', 1, 'color', 'k');
adjust_quiver_arrowhead_size(h, 1);
set(gca, 'ydir', 'reverse')
axis([0 M+1 0 N+1])
set(gca,'xtick',[])
set(gca,'ytick',[])
title(['Gibbs sweep ' num2str(nG)], 'interpreter', 'latex');
set(gca,'fontsize',24)

end
function plot_reconstruction(Q,Qhat,nG,rng)

[M N] = size(Q);
Qhat_angle = zeros(M,N);

subplot(1,2,1)
if rng == 0
    imagesc(mod(Q,pi))
else
    imagesc(Q)
end
pos_vec = get(gca,'position');
colorbar
colormap('hsv')
set(gca, 'position', pos_vec);
if rng == 0
    caxis([0 pi])
else
    caxis([-pi pi])
end
set(gca,'fontsize',24)
set(gca,'xtick',[])
set(gca,'ytick',[])
title(['A sample from the prior,   ' num2str(M*N) ' cells'], ...
    'interpreter', 'latex')
subplot(1,2,2)
% for i = 1:M
%     for j = 1:N
%         if isnan(Qhat{i,j}(1))
%             Qhat{i,j} = [1 0]';
%         end
%     end
% end
for i = 1:M
    for j = 1:N
        cos_sin = Qhat{i,j} / sqrt(Qhat{i,j}' *  Qhat{i,j});
        c = cos_sin(1);
        s = cos_sin(2);
        if c > 0
            q_angle = atan(s/c);
        elseif s > 0
            q_angle = atan(s/c) + pi;
        else
            q_angle = atan(s/c) - pi;
        end
        Qhat_angle(i,j) = q_angle;
    end
end
% imagesc(Qhat)
if rng == 0
    Qhat_angle = mod(Qhat_angle,pi);
    for i = 1:M
        for j = 1:N
            if isnan(Qhat_angle(i,j))
                Qhat_angle(i,j) = pi;
            else
                Qhat_angle(i,j) = mod(Qhat_angle(i,j),pi);
            end
        end
    end
    imagesc(Qhat_angle)
else
    for i = 1:M
        for j = 1:N
            if isnan(Qhat_angle(i,j))
                Qhat_angle(i,j) = pi;
            end
        end
    end
    imagesc(Qhat_angle)
end
pos_vec = get(gca,'position');
colorbar
colormap('hsv')
set(gca, 'position', pos_vec);
if rng == 0
    caxis([0 pi])
else
    caxis([-pi pi])
end
set(gca,'fontsize',24)
set(gca,'xtick',[])
set(gca,'ytick',[])
rmse = 0;
for i = 1:M
    for j = 1:N
        q_angle = [cos(Q(i,j)) sin(Q(i,j))]';
        q = Qhat{i,j};
        if q'*q ~= 0
            qhat_angle = q/sqrt(q'*q);
            rmse = rmse + (q_angle-qhat_angle)'*(q_angle-qhat_angle);
        else
            rmse = rmse + sqrt(2);
        end
    end
end
rmse = sqrt(rmse/(N*M));
title(['Reconstruction at Gibbs sweep ' num2str(nG), ...
   ',   RMSE ' num2str(rmse)], 'interpreter', 'latex')

end
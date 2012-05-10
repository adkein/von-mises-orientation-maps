function Y = generate_von_mises_observations(Q,ky)

if nargin < 2 ky = 2; end

display('Generating observations ...');
[M N] = size(Q);

y_max = 5;
Y = cell(y_max,1);


% % All cells observed once
% for i = 1:y_max
%     Y{i,1} = zeros(M,N);
% end
% for i = 1:M
%     for j = 1:N
%         Y{1,1}(i,j) = circ_vmrnd(Q(i,j),ky,1);
%     end
% end


% Sparse multiple observations on a grid
for i = 1:y_max
    Y{i,1} = Inf*ones(M,N);
end
for i = 1:2:M
    for j = 1:2:N
        for k = 1:y_max
            Y{k,1}(i,j) = ky * Q(i,j);%circ_vmrnd(Q(i,j),ky,1);
        end
    end
end

end
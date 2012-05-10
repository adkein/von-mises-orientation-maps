M = 50;
N = 50;
R = 4;
kq = 4;
ky = 3;
nGibbs_sampling = 20;
nGibbs_estimation = 20;
rng = 0; % 0 for [0, pi], 1 for [-pi, pi];
shift = 0;

Qarray = create_frames_sampling_pinwheel(M, N, R, kq, ky, ...
    nGibbs_sampling,shift);
movie_struct = make_movie_sampling(M*N,R,kq,ky,nGibbs_sampling);
Y = generate_von_mises_observations(Qarray{nGibbs_sampling,1},ky);
Qhat_vec_array = create_frames_estimation_alt(Y, R, kq, ky, nGibbs_estimation);
make_movie_estimation(M*N,R,kq,ky,nGibbs_sampling,nGibbs_estimation,rng);
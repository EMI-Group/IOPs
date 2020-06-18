% Nabi Omidvar

tic;
clear;
% set random seed
rand('state', sum(100*clock));
randn('state', sum(100*clock));

addpath(genpath('../../../ilsgo'))


runindex = nan;
isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
if(isOctave)
    arg_list = argv();
    runindex = str2num(arg_list{1});
end

func_num     = %FUN%;
popsize      = 50;
max_fes      = 3e4;
epoch_length = 50;

design = imop(func_num);

sizes = design.increments;
sizes(1) = design.dim_initial;

opts.popsize      = popsize;
opts.max_fes      = max_fes;
opts.epoch_length = epoch_length;
opts.display      = 1;
opts.threshold    = eps;
opts.fail_count   = 1;
opts.max_fes      = sizes * 5000;
opts.pexplore     = 1;

fhs.trace  = fopen(sprintf('trace/tracef%02d_%02d.txt',  func_num, runindex), 'w');
fhs.groups = fopen(sprintf('groups/groups%02d_%02d.txt', func_num, runindex), 'w');
fhs.gcount = fopen(sprintf('gcount/gcount%02d_%02d.txt', func_num, runindex), 'w');

get_groups = @(s)(load_group(design, s));

[bestval sols] = cbcc(@imop, design, get_groups, opts, runindex, fhs);

if(isOctave)
    save('-7', sprintf('sols/sol%02d_%02d.mat', func_num, runindex), 'sols');
else
    save(sprintf('sols/sol%02d_%02d.mat', func_num, runindex), 'sols');
end

fclose(fhs.trace);
fclose(fhs.groups);
fclose(fhs.gcount);
toc;

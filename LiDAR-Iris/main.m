clear; clc;
addpath(genpath('src'));
global data_path; 
%  directory structure 
% - 00
%   - 00.csv (gtpose)
%   - velodyne
%      - <00001.bin>
%      - <00002.bin>
%% data path setting
data_path = '../00/'; 
GTposes_file='00.csv';
%% loading ground-truth poses and creating structural feature matrix SFM
resolution = [80,360];Range=80; 
[des_iris, GT_poses] = Load_Data(resolution,GTposes_file,Range);

figure(1); clf;
plot(GT_poses(:,1), GT_poses(:,2));
axis equal;
%% loop parameter setting
 revisit_criteria = 4; % 
 num_node_enough_apart = 300;
%%
num_queries = length(GT_poses);
des_log=cell(1,num_queries);
des_mask=cell(1,num_queries);
FFT_angle=cell(1,num_queries);
for index=1:num_queries
  [T,Mask]=LoGFeatureEncode(des_iris{index},4,18,1.6,0.75);
  curr_angle=FFT(des_iris{index});
  FFT_angle{index}=curr_angle;
  des_log{index}=T;
  des_mask{index}=Mask;
end

%% main
is_revisit=zeros(num_queries-num_node_enough_apart,1);
results=zeros(num_queries-num_node_enough_apart,2);
exp_poses =zeros(num_queries,2);

for query_idx = 1:num_queries
        
    query_pose = GT_poses(query_idx,:);
    exp_poses(query_idx,:) =query_pose;

    if( query_idx <= num_node_enough_apart )
       continue;
    end
    
    [revisitness, how_far_apart] = isRevisitGlobalLoc(query_pose, exp_poses(1:query_idx-num_node_enough_apart, :), revisit_criteria);
    
   is_revisit(query_idx-num_node_enough_apart,1)=revisitness;
    
  % find the nearest (top 1) via pairwise comparison
    nearest_idx = 0;
    min_dist = inf; % initialization 
    for ith_candidate =1:query_idx-num_node_enough_apart
        query_angle=FFT_angle{query_idx};
        candidate_angle=FFT_angle{ith_candidate};
        candidate_shift= FFT_register(query_angle,candidate_angle);
        distance_to_query =GetHamming_dis(des_log{query_idx},des_mask{query_idx},des_log{ith_candidate},des_mask{ith_candidate},candidate_shift,resolution);

        if( distance_to_query < min_dist)
            nearest_idx = ith_candidate;
            min_dist = distance_to_query;
        end     
    end
    results(query_idx-num_node_enough_apart,:)=[nearest_idx,min_dist];
    
    if( rem(query_idx, 100) == 0)
        disp( strcat(num2str(query_idx/num_queries * 100), ' % processed') );
    end
    
end
%% Entropy thresholds 
min_thres=min(results(:,2))+0.01;
max_thres=max(results(:,2))+0.01;
thresholds = linspace(min_thres, max_thres,100); 
num_thresholds = length(thresholds);

% Main variables to store the result for drawing PR curve 
num_hits=zeros(1, num_thresholds);
Precisions = zeros(1, num_thresholds); 
Recalls = zeros(1, num_thresholds); 
true_positive=sum(is_revisit);
%% prcurve analysis 
for thres_idx = 1:num_thresholds
  threshold = thresholds(thres_idx);
  predict_postive=0;num_hits=0;
    for frame_idx=1:length(is_revisit)
        min_dist=results(frame_idx,2);
        matching_idx=results(frame_idx,1);
        revisit=is_revisit(frame_idx,1); 
            if( min_dist <threshold)
                predict_postive=predict_postive+1;
                if(dist_btn_pose(GT_poses(frame_idx+num_node_enough_apart,:), GT_poses(matching_idx, :)) < revisit_criteria)
                    %TP
                    num_hits= num_hits + 1;
                end     
            end
    end
  
    Precisions(1, thres_idx) = num_hits/predict_postive;
    Recalls(1, thres_idx)=num_hits/true_positive;
    
end
%% save the log 
savePath = strcat("pr_result/within ", num2str(revisit_criteria), "m/");
if((~7==exist(savePath,'dir')))
    mkdir(savePath);
end
save(strcat(savePath, 'nPrecisions.mat'), 'Precisions');
save(strcat(savePath, 'nRecalls.mat'), 'Recalls');
%% visiualize GT path
figure(1);hold on;
plot(GT_poses(:,1), GT_poses(:,2),'LineWidth',2);
axis equal; grid on;
legend('Groud-Truth');

%%  save the loop information
data_save_path = fullfile('./data/'); 
filename = strcat(data_save_path, 'results', '.mat');
save(filename, 'results');










function [ IrisMap ] = LiDAR_Iris( ptcloud, num_sector, num_ring,range)
%% Preprocessing 
% Downsampling for fast search
% gridStep = 0.5; % 0.5m cubic grid downsampling is applied in the paper. 
% ptcloud = pcdownsample(ptcloud, 'gridAverage', gridStep);

% point cloud information 
num_points = ptcloud.Count;
IrisMap=zeros(num_ring,num_sector);
%% Save a point to the corresponding bin 
for ith_point =1:num_points

    % Point information 
    ith_point_xyz = ptcloud.Location(ith_point,:);
    dis= sqrt(ith_point_xyz(1)^2 + ith_point_xyz(2)^2);
    if( dis>range)
        continue;
    end
    %Iris method calculate
     arc = (atan2(ith_point_xyz(1,3), dis) * 180.0 /pi) + 24;
     yaw = (atan2(ith_point_xyz(1,2), ith_point_xyz(1,1)) * 180.0/pi) + 180;
     Q_dis = min(max(floor(dis), 0), 79);
     Q_arc = min(max(floor(arc /4), 0), 7);
     Q_yaw = min(max(floor(yaw + 0.5), 0),359);
     IrisMap(Q_dis+1, Q_yaw+1)=bitor(IrisMap(Q_dis+1, Q_yaw+1),bitshift(1,Q_arc));
end
end

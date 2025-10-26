%
% === ver 2025/10/26 Copyright (c) 2025 Takashi NAKAMURA  =====
%                

grd='D:/COAWST_DATA/Kushimoto/Grid/Kushimoto_grd_v0.1.nc';

h       = ncread(grd,'h');
latr    = ncread(grd,'lat_rho');
lonr    = ncread(grd,'lon_rho');
xr      = ncread(grd,'x_rho');
yr      = ncread(grd,'y_rho');
rmask   = ncread(grd,'mask_rho');
[Im,Jm] = size(h);

%% Seek release points at west boundary
Np=0;
for j=3:4:Jm-2
    if rmask(3,j)==1
        Np=Np+1;
        latf(Np)=latr(3,j);
        lonf(Np)=lonr(3,j);
    end
end

%%
day2sec=24.0*60.0*60.0;

Time0 = 0.0; %1*day2sec; % Start time; second since simulation start
period_day = 50; % days

depth = 0.0;


%% Write CSV ROMSPath input file
% See LTRANSv2 User's guide p.31
% the first column contains each particle's latitudinal
% coordinate, the second contains its longitudinal coordinate, the third column contains the
% particle's depth (in meters from surface, e.g., -35.55), and the fourth column contains the "date
% of birth" which is delay in seconds from the beginning of the model run until the time that
% particle will start being tracked (i.e., start to move). This is used to release batches of particles at
% different times. If all particles start moving at the start of the model simulation, then the value for
% their "date of birth" should be zero. If the Settlement Module is turned on, a fifth column must
% contain an identification number, usually the identification number of the habitat polygon from
% which each particle starts. In the example LTRANS model, the file is called
% "initial_part_location.csv".

fid=fopen('initial_part_location.csv','w');   
for j=1:period_day*24*6 % Relese particle every 10 min interval
    for i=1:Np
        fprintf(fid,'%f, %f, %f, %f\r\n',lonf(i),latf(i),depth,Time0);   
    end
    Time0 = Time0 + 10*60; % sec; 10 min interval
end
fclose(fid) ;

totalfloats =  period_day*24*6*Np

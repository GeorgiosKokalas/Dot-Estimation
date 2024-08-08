function dotArrays=generate_dots(curr_num,nlim,rdlim,rflim)

%%
% generating dot stimuli that controll for surface area & density
% based on Joonkoo Park's code base (https://osf.io/s7xer/; script_generate_dots.m dotGenJP.m dotField2GKA.m)
% 
% input cell (varargin)
%      1. nlim     - [min max] values of number; default is [8 32].
%      2. rdlim    - [min max] values of r_d, radius of each dot; default is [6 12].
%      3. rflim    - [min max] values of r_f, radius of the field; default is [120 240].
%      4. level    - number of levels across N, Sz, and Sp; default is 5.
% 
% output : dotArrays
%
% For a balanced design, the minimum and the maximum values of nlim, rdlim,
%   and rflim should all the equivalent. To achieve this, because area as
%   in individual area (IA) and field area (FA) is proportionate to the
%   square of radius, if the range of n differs in 4 folds, the range of
%   rd (radius of each dot) and rf (radius of the circular field in which
%   the dots are drawn) should differ in 2 folds. 
% 
% dependence: dotGenJP dotField2GKA 
% 7/29/2024 hansem.sohn@gmail.com

%% initialization
stimDim = dotGenJP('nlim',nlim,'rdlim',rdlim,'rflim',rflim,'level',nlim(2)-nlim(1)+1);

%%

% Magnitude values containing information about N, r_d, and r_f
magval_r = stimDim.magval_r;

% Buffer allows extra space between the dots
buffer = 1.5;

nTry=100; % if dot generation fails (e.g., too many dots given field/dot size), return error

% Struct that will contain all the dot-array parameters
dotArrays = []; % struct([]);

% find number closest to curr_num (this happens due to log sampling)
[~,id_num]=min(abs(magval_r(:,1)-curr_num));

i_num=id_num(randperm(length(id_num),1)); % deal with multiple samples

% dot coordinates
for ierr = 1 : nTry
    try
    radii = magval_r(i_num,2) * buffer * ones(curr_num,1);
    catch
        disp('');
    end
    fieldRadius = magval_r(i_num,3);
    [dts, err] = dotField2GKA(radii, fieldRadius); % output [x, y] with each row for each dot; cartesian coordinate with center of field=(0,0)
    if err == 0
        break;
    end
    if ierr == nTry
        warning('dotField2GKA failed.');
    end
end

% output
dotArrays.x=dts(:,1);
dotArrays.y=dts(:,2);
dotArrays.r=repmat(magval_r(i_num,2),size(dts,1),1);

return;


%% belows are for plotting

% nPix = game_opt.field_size_pix;   % width/height of the image in pixels
% AxisAdj = ceil(nPix/2);
% mulfac = 8; % create a background image that's "mulfac" times larger (for anti-aliasing)
%
% dts = dts + AxisAdj;
% M = zeros( mulfac * nPix );
% dts_aa = dts * mulfac;
% 
% M( sub2ind(size(M),dts_aa(:,1),dts_aa(:,2)) ) = 1;
% J = double(bwdist(M) <= magval_r(i,2) * mulfac);
% 
% % reduce the image by "mulfac" times and trim <0 and >1 values
% J = imresize(J, 1/mulfac);
% J(J(:)<0) = 0;
% J(J(:)>1) = 1;
% 
% figure;
% imshow(J)
% axis square;
% 
% % Save the image as a bmp file
% id_save=1;
% if id_save
%     dir_tmp = fullfile(num2str(curr_num));
%     if ~exist(dir_tmp,'dir')
%         mkdir(dir_tmp);
%     end
%     
%     fn = sprintf('logN_%d_logSz_%d_logSp_%d_%d.jpg',floor(dotArrays.logN),floor(dotArrays.logSz),floor(dotArrays.logSp));
%     imwrite(J,fullfile(dir_tmp, fn));
% end
% 
% 

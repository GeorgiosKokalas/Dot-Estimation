function present_ITI(visual_opt)

stage_idx = 0; % current stage ITI
phd_duration =visual_opt.photoD_duration{stage_idx+1};

% fixation mark
curr_str='+'; 
curr_pos = [visual_opt.xCenter, visual_opt.yCenter];
text_color = visual_opt.white;
text_size = visual_opt.fixation_size;
phd_on = false; % presented later
present_without_flip(visual_opt, curr_str, curr_pos, phd_on,text_color,text_size);

% photodiode on
present_photodiode(visual_opt,phd_duration)
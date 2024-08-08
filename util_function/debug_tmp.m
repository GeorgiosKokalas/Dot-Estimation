
    KbName('UnifyKeyNames');
    device_opt.stopkey	= KbName('x');
    device_opt.pause	= KbName('LeftArrow');
    device_opt.gokey	= KbName('RightArrow');
    device_opt.confirm  = KbName('Return');
    device_opt.abort	= KbName('ESCAPE');
    
    device_opt.one = KbName('1!');
    device_opt.two = KbName('2@');
    device_opt.three = KbName('3#');
    device_opt.four = KbName('4$');
    device_opt.five = KbName('5%');
    device_opt.six = KbName('6^');
    device_opt.seven = KbName('7&');
    device_opt.eight = KbName('8*');
    device_opt.nine = KbName('9(');
    device_opt.zero = KbName('0)');
    
    device_opt.key_interval = 1/20; % Small delay to avoid high-speed key register
    device_opt.key_interval_ignore = 150/1000; % if the same key is pressed during key_interval_ignore (effective sampling duration)

    
    tmp=check_keys(device_opt)
    tmp.names
    
    
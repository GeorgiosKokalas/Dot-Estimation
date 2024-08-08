function check_trajectory( )

	% Check the trajectory for current algorithm
	load visual_opt
	load game_opt
	
	visual_opt.spare_size = 5;
	
	corners			= visual_opt.corners;
	max_dist		= 2000;
	num_iter		= 1000;
	state			= 1;
	
	opponent_loc		  = [ randi([0, 1920], 1, 1 ), randi( [0, 1080], 1, 1) ];
	new_direction		  = zeros( num_iter + 1, 2 );
	new_direction( 1, : ) = [ 1920, 1080 ]./2;
	for iIter = 1 : num_iter
% 		opponent_loc	= [ randi([0, 1920], 1, 1 ), randi( [0, 1080], 1, 1) ];
		opponent_loc =  opponent_loc - [ opponent_loc(1)/1920, 0];
		
		Obj_loc  = [ new_direction( iIter, : ); opponent_loc; corners ];
		Obj_dist = pdist( Obj_loc );
		len_ind	 = length( Obj_loc( :, 1 ) ) - 1;
		Obj_dist = Obj_dist( 1 : len_ind );							% 1st component is distance with Player.
		[ min_dist, min_dist_ind ]	= min( Obj_dist( 2 : end ) );	% Get the minimum distanced corner.
		if length( min_dist_ind ) > 1
			% If the prey is staying at the conter of mass point which has identical distances.
			min_dist_ind = min_dist_ind( randi( [ 1, length( min_dist_ind ) ], 1, 1 ) );
		end
		
		% This devices helps to consider the distance factor.
		%	What this mean is that 'If closer, move faster. If further, move slower'.
		%	This mimics the prey's behavior get more urgent when the player is near.
		if ( min_dist == 0)
			min_dist = 1;
		end
		if ( min_dist >= max_dist )
			min_dist = max_dist - 1;
		end
		
		dist_weight_prey = game_opt.preyWeight( ceil( min_dist ) );
		
		% step 3. Get the vector values between those object and get opposite vector and vector sum those values.
		vector( 1, : )	= -[ visual_opt.corners(min_dist_ind, 1) - new_direction( iIter, 1 ), visual_opt.corners(min_dist_ind, 2) - new_direction( iIter, 2) ];
		vector( 2, : )	= -[ opponent_loc(1) - new_direction(iIter, 1), opponent_loc(2) - - new_direction(iIter, 2) ];
		vector_sum		= sum( vector, 1 );
		
		new_direction(iIter+1, :)	= [ new_direction(iIter, 1) + vector_sum(1).*dist_weight_prey, new_direction(iIter, 2) + vector_sum(2).*dist_weight_prey ];
		
		% step 4. Final trim (avoiding escape from screen)
		%	Also tried to acheive that collision to single wall never happens by including additional parameter
		%	in calculating new vector.
		if new_direction(iIter+1, 1) <= visual_opt.wallThickness + visual_opt.npcWidth || ...
				new_direction(iIter+1,1) >= visual_opt.screenXpixels - visual_opt.wallThickness - visual_opt.npcWidth
			new_direction( iIter + 1, :) = [ new_direction( iIter+1, 1) + vector_sum(1)*game_opt.vector_cont_fact, new_direction(iIter+1, 2) + vector_sum(2) ];
			[ new_direction(iIter + 1, :), ~ ] = collision_detection_new( opponent_loc(1), opponent_loc(2), [ new_direction( iIter+1, 1), new_direction( iIter+1, 2)], state );
		end
		
		if new_direction( iIter+1, 2) <= visual_opt.wallThickness + visual_opt.npcWidth || ...
				new_direction(iIter+1,2) >= visual_opt.screenYpixels - visual_opt.wallThickness - visual_opt.npcWidth
			new_direction(iIter + 1, :) = [ new_direction( iIter+1, 1) + vector_sum(1), new_direction( iIter+1, 2) + vector_sum(2)*game_opt.vector_cont_fact ];
			[ new_direction(iIter + 1, :), ~ ] = collision_detection_new( opponent_loc(1), opponent_loc(2), [ new_direction( iIter+1, 1), new_direction( iIter+1, 2)], state );
		end
	end
end
%% Helper function to return the error in the overlap region
function overlap_error = findError(curr_patch,ref_patches,overlap_type,overlap_size,patch_size)
	if strcmp(overlap_type,'vertical')
		left_patch = ref_patches{1};
		left_overlap = left_patch(:,patch_size-overlap_size+1:patch_size,:);
		
		curr_overlap = curr_patch(:,1:overlap_size,:);
		overlap_error = rmsError(left_overlap,curr_overlap);
	elseif strcmp(overlap_type,'horizontal')
		top_patch = ref_patches{2};
		top_overlap = top_patch(patch_size-overlap_size+1:patch_size,:,:);
		
		curr_overlap = curr_patch(1:overlap_size,:,:);
		overlap_error = rmsError(top_overlap,curr_overlap);
	else
		left_patch = ref_patches{1};
		left_overlap = left_patch(:,patch_size-overlap_size+1:patch_size,:);
		

		top_patch = ref_patches{2};
		top_overlap = top_patch(patch_size-overlap_size+1:patch_size,:,:);
		
		corner_patch = ref_patches{3};
		corner_overlap = corner_patch(patch_size-overlap_size+1:patch_size,patch_size-overlap_size+1:patch_size,:);
		
		curr_top_overlap = curr_patch(1:overlap_size,:,:);
		curr_left_overlap = curr_patch(:,1:overlap_size,:);
		curr_corner_overlap = curr_patch(1:overlap_size,1:overlap_size,:);

		overlap_left_error = rmsError(left_overlap,curr_left_overlap);
		overlap_top_error = rmsError(top_overlap,curr_top_overlap);
		overlap_corner_error = rmsError(corner_overlap,curr_corner_overlap);

		overlap_error = overlap_left_error + overlap_top_error - overlap_corner_error;
	end
end
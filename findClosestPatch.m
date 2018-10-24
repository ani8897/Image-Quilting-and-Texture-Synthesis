%% Helper function to return a random patch of the closest patch to the given patch in the original image
function selected_patch = findClosestPatch(ref_patches,original_pic,error_tolerance,overlap_type,overlap_size,patch_size);
	[h,w,num_chan] = size(original_pic);
	num_rows = h-patch_size+1;
	num_cols = w-patch_size+1;
	error_patch = zeros([num_rows,num_cols]);
	min_error = 10000000.0;
	for i=1:h-patch_size+1
		for j=1:w-patch_size+1
			curr_patch = original_pic(i:i+patch_size-1,j:j+patch_size-1,:);
			overlap_error = findError(curr_patch,ref_patches,overlap_type,overlap_size,patch_size);
			if overlap_error == 0
				error_patch(i,j) = 0;
			else
				error_patch(i,j) = overlap_error;
				if overlap_error < min_error
					min_error = overlap_error;
				end
			end			
		end
	end
	
	% min_error = min(min(error_patch))*(1+error_tolerance);
	min_error = min_error*(1+error_tolerance);

	[close_patches_i, close_patches_j] = find(error_patch<min_error);
	x = randi(length(close_patches_i),1);

	start_i = close_patches_i(x);
	start_j = close_patches_j(x);

	selected_patch = original_pic(start_i:start_i+patch_size-1, start_j:start_j+patch_size-1, :);
end
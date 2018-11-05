%% Helper function to return correspondence error between two patches, the measure is a simple difference between intensities or the luminance
function correspondence_error = findCorrespondenceError(curr_patch,target_patch,corr_type)
	if strcmp(corr_type,'intensity')
		curr_patch = rgb2gray(curr_patch);
		target_patch = rgb2gray(target_patch);
		correspondence_error = rmsError(curr_patch,target_patch);
	else if strcmp(corr_type,'luminance')
		curr_patch = rgb2hsv(curr_patch);
		target_patch = rgb2hsv(target_patch);
		curr_patch = curr_patch(:,:,3);
		target_patch = target_patch(:,:,3);
		correspondence_error = rmsError(curr_patch,target_patch);
	end
end
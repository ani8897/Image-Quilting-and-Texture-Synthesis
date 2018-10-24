%% Helper function to return the root mean squared error between two patches
function rmse_error = findError(patch_a,patch_b)
	diff_patch = patch_a-patch_b;
	square_diff_patch = diff_patch.*diff_patch;
	rmse_error = sum(sum(sum(square_diff_patch)));
end
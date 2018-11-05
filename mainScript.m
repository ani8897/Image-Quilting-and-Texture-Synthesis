%% MainScript

%% Setting the color scale
my_num_of_colors = 256;
col_scale =  [0:1/(my_num_of_colors-1):1]';
my_color_scale = [col_scale,col_scale,col_scale];

%% Set to_save to 1, if you want to save the generated pictures
to_save = 0;

%% Loading the pictures

%% For GIF pictures, need to convert from index to rgb
[texture_paper_pic,map] = imread('paper_data/S29.gif');
texture_paper_pic = ind2rgb(texture_paper_pic,map);
% original_pic = double(texture_paper_pic);

texture_our_pic = imread('our_data/crowd.jpg');
original_pic = double(texture_our_pic)/255.0;

[h,w,num_chan] = size(original_pic);
file_name = "Result";
title_name = "Modified Pic";

%% Defining the parameters of our algorithm
patch_size = 60;
overlap_size = patch_size/6;
net_patch_size = patch_size-overlap_size;
error_tolerance = 0.1;

%% Calculating the new generated image size 
hnew = 2*net_patch_size*floor(h/net_patch_size) + overlap_size;
wnew = 2*net_patch_size*floor(w/net_patch_size) + overlap_size;
modified_pic = zeros([hnew,wnew,num_chan]);
% size(original_pic)
% size(modified_pic)
f = waitbar(0,"Quilting");
stepnum = 0;
i_limit = (hnew-overlap_size)/net_patch_size;
j_limit = (wnew-overlap_size)/net_patch_size;

for i = 1:i_limit
	for j = 1:j_limit

		if i==1 && j==1
			modified_pic(1:patch_size,1:patch_size,:) = getRandomPatch(original_pic,patch_size);

		elseif i==1
			start_ind = net_patch_size + (j-2)*net_patch_size;
			prev_patch = modified_pic(1:patch_size,start_ind - net_patch_size + 1:start_ind - net_patch_size + patch_size,:);
			
			ref_patches = cell(1,3);
			ref_patches{1} = prev_patch;
			
			selected_patch = findClosestPatch(ref_patches, original_pic, error_tolerance, 'vertical', overlap_size, patch_size);
			final_patch = minErrorBoundaryCut(ref_patches,selected_patch,overlap_size,'vertical',patch_size);
			
			modified_pic(1:patch_size,start_ind+1:start_ind+patch_size,:) = final_patch;

		elseif j==1
			start_ind = net_patch_size + (i-2)*net_patch_size;
			prev_patch = modified_pic(start_ind - net_patch_size + 1:start_ind - net_patch_size + patch_size,1:patch_size,:);
			
			ref_patches = cell(1,3);
			ref_patches{2} = prev_patch;
			
			selected_patch = findClosestPatch(ref_patches, original_pic, error_tolerance, 'horizontal', overlap_size, patch_size);
			final_patch = minErrorBoundaryCut(ref_patches,selected_patch,overlap_size,'horizontal',patch_size);
			
			modified_pic(start_ind+1:start_ind+patch_size,1:patch_size,:) = final_patch;

		else
			left_ind = net_patch_size + (j-2)*net_patch_size;
			top_ind = net_patch_size + (i-2)*net_patch_size;
			
			left_patch = modified_pic(top_ind + 1 : top_ind + patch_size,left_ind - net_patch_size + 1:left_ind - net_patch_size + patch_size,:);
			top_patch = modified_pic(top_ind - net_patch_size + 1:top_ind - net_patch_size + patch_size,left_ind + 1:left_ind + patch_size,:);
			corner_patch = modified_pic(top_ind - net_patch_size + 1:top_ind - net_patch_size + patch_size,left_ind - net_patch_size + 1:left_ind - net_patch_size + patch_size,:);
			
			ref_patches = cell(1,3);
			ref_patches{1} = left_patch;
			ref_patches{2} = top_patch;
			ref_patches{3} = corner_patch;

			selected_patch = findClosestPatch(ref_patches, original_pic, error_tolerance, 'both', overlap_size, patch_size);
			final_patch = minErrorBoundaryCut(ref_patches,selected_patch,overlap_size,'both',patch_size);

			modified_pic(top_ind+1:top_ind+patch_size,left_ind+1:left_ind+patch_size,:) = final_patch;

		end
		stepnum = stepnum + 1;
		waitbar(stepnum/(i_limit*j_limit),f,"Quilting");
	end
end
close(f);
imwrite(modified_pic,'Result.jpg');
saveFigure(my_color_scale,original_pic,modified_pic,title_name,file_name,1,to_save);
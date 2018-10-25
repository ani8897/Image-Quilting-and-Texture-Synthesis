%% Helper function to return the final patched up section using the selected patch and neighbor patches
function final_patch = minErrorBoundaryCut(ref_patches,selected_patch,overlap_size,overlap_type,patch_size)
	final_patch = zeros(size(selected_patch));

	if strcmp(overlap_type,'vertical')
		final_patch(:,overlap_size+1:patch_size,:) = selected_patch(:,overlap_size+1:patch_size,:);	
		left_patch = ref_patches{1};
		left_overlap = left_patch(:,patch_size-overlap_size+1:patch_size,:);
		selected_overlap = selected_patch(:,1:overlap_size,:);
		diff_patch = left_overlap-selected_overlap;
		% e = sum(diff_patch.*diff_patch,3);
		e = sum(abs(diff_patch),3);

		E = zeros(size(e));
		E(1,:) = e(1,:);
		for i = 2:patch_size
			for j = 1:overlap_size
				if j==1
					E(i,j) = e(i,j) + min([E(i-1,j), E(i-1,j+1)]);
				elseif j==overlap_size
					E(i,j) = e(i,j) + min([E(i-1,j-1), E(i-1,j)]);
				else
					E(i,j) = e(i,j) + min([E(i-1,j-1), E(i-1,j), E(i-1,j+1)]);
				end
			end
		end

		[min_E, prev_ind] = min(E(patch_size,:));
		if prev_ind==1
			final_patch(patch_size,:,:) = selected_patch(patch_size,:,:);
		else
			final_patch(patch_size,1:prev_ind-1,:) = left_patch(patch_size,patch_size - overlap_size + 1:patch_size - overlap_size + prev_ind-1,:);
			final_patch(patch_size,prev_ind:overlap_size,:) = selected_patch(patch_size,prev_ind:overlap_size,:);	
		end
		% final_overlap(patch_size,1:prev_ind-1,:) = left_patch(patch_size,1:prev_ind-1,:);
		% final_overlap(patch_size,prev_ind:overlap_size,:) = selected_patch(patch_size,prev_ind:overlap_size,:);
		for i = patch_size-1:-1:1
			[min_val, prev_ind] = min(abs(E(i,:) - (min_E-e(i+1,prev_ind))));
			min_E = E(i,prev_ind);
			if prev_ind==1
				final_patch(i,:,:) = selected_patch(i,:,:);
			else
				final_patch(i,1:prev_ind-1,:) = left_patch(i,patch_size - overlap_size + 1:patch_size - overlap_size + prev_ind-1,:);
				final_patch(i,prev_ind:overlap_size,:) = selected_patch(i,prev_ind:overlap_size,:);	
			end
			% final_overlap(i,1:prev_ind-1,:) = left_patch(i,1:prev_ind-1,:);
			% final_overlap(i,prev_ind:overlap_size,:) = selected_patch(i,prev_ind:overlap_size,:);
		end
		% final_patch(:,1:overlap_size,:) = final_overlap;

	elseif strcmp(overlap_type,'horizontal')
		final_patch(overlap_size+1:patch_size,:,:) = selected_patch(overlap_size+1:patch_size,:,:);	
		top_patch = ref_patches{2};
		top_overlap = top_patch(patch_size-overlap_size+1:patch_size,:,:);
		selected_overlap = selected_patch(1:overlap_size,:,:);
		diff_patch = top_overlap-selected_overlap;
		e = sum(diff_patch.*diff_patch,3);
		E = zeros(size(e));
		E(:,1) = e(:,1);
		for j = 2:patch_size
			for i = 1:overlap_size
				if i==1
					E(i,j) = e(i,j) + min([E(i,j-1), E(i+1,j-1)]);
				elseif i==overlap_size
					E(i,j) = e(i,j) + min([E(i-1,j-1), E(i,j-1)]);
				else
					E(i,j) = e(i,j) + min([E(i-1,j-1), E(i,j-1), E(i+1,j-1)]);
				end
			end
		end

		[min_E, prev_ind] = min(E(:,patch_size));

		if prev_ind==1
			final_patch(:,patch_size,:) = selected_patch(:,patch_size,:);
		else
			final_patch(1:prev_ind-1,patch_size,:) = top_patch(patch_size - overlap_size + 1:patch_size - overlap_size + prev_ind-1,patch_size,:);
			final_patch(prev_ind:overlap_size,patch_size,:) = selected_patch(prev_ind:overlap_size,patch_size,:);
		end
		% final_overlap(1:prev_ind-1,patch_size,:) = top_patch(1:prev_ind-1,patch_size,:);
		% final_overlap(prev_ind:overlap_size,patch_size,:) = selected_patch(prev_ind:overlap_size,patch_size,:);
		for i = patch_size-1:-1:1
			[min_val, prev_ind] = min(abs(E(:,i) - (min_E-e(prev_ind,i+1))));
			min_E = E(prev_ind,i);
			if prev_ind==1
				final_patch(:,i,:) = selected_patch(:,i,:);
			else
				final_patch(1:prev_ind-1,i,:) = top_patch(patch_size - overlap_size + 1:patch_size - overlap_size + prev_ind-1,i,:);
				final_patch(prev_ind:overlap_size,i,:) = selected_patch(prev_ind:overlap_size,i,:);
			end
			% final_overlap(1:prev_ind-1,i,:) = top_patch(1:prev_ind-1,i,:);
			% final_overlap(prev_ind:overlap_size,i,:) = selected_patch(prev_ind:overlap_size,i,:);
		end
		% final_patch(1:overlap_size,:,:) = final_overlap;
	else
		horizontal_cut_patch = minErrorBoundaryCut(ref_patches,selected_patch,overlap_size,'horizontal',patch_size);
		final_patch = minErrorBoundaryCut(ref_patches,horizontal_cut_patch,overlap_size,'vertical',patch_size);
	end
end
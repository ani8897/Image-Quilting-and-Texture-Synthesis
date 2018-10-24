%% Helper function to display and save 3 processed images
function saveFigure3(my_color_scale,original_pic,mid_pic,modified_pic,mid_name,title_name,file_name,is_color,to_save)
	if to_save==1
		fig = figure('units','normalized','outerposition',[0 0 1 1]); colormap(my_color_scale);
	else
		fig = figure; colormap(my_color_scale);
	end

	if is_color == 1
		colormap jet;
	else
		colormap(gray);
	end
	
	subplot(1,3,1), imagesc(original_pic), title('Original Image'), colorbar, daspect([1 1 1]), axis tight;
	subplot(1,3,2), imagesc(mid_pic), title(mid_name), colorbar, daspect([1 1 1]), axis tight;
	subplot(1,3,3), imagesc(modified_pic), title(title_name), colorbar, daspect([1 1 1]), axis tight;
	impixelinfo();
    
	if to_save == 1
		saveas(fig,file_name),close(fig);
	end
end
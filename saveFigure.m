% Helper function to display and save 2 processed images %
function saveFigure(my_color_scale,original_pic,modified_pic,title_name,file_name,is_color,to_save)
	if to_save==1
		fig = figure('units','normalized','outerposition',[0 0 1 1]); colormap(my_color_scale);
	else
		fig = figure; colormap(my_color_scale);
	end

	if is_color == 1
		colormap jet;
	end
	
	subplot(1,2,1), imagesc(original_pic), title('Original Image'), colorbar, daspect([1 1 1]), axis tight;
	subplot(1,2,2), imagesc(modified_pic), title(title_name), colorbar, daspect([1 1 1]), axis tight;
	impixelinfo();

	if to_save == 1
		saveas(fig,file_name),close(fig);
	end
end
function PlotSpikeCounts(dirs,counts,params,cos_tun,cellnum)
% dirs      directions of stimulus  1 x #directions
% counts    matrix of spike counts during stimulus presentation. The
%           matrix has dimensions #cells x #trials/direction x #directions
% cellnum   numbers of these cells, will be used in the title   1 x #cells
%           optional                                                             
if exist('cellnum') == 0
    cellnum = 1:size(counts,1)
    plot_title = 0;
else
    plot_title = 1;
end

%number of figures
fignum = ceil(length(cellnum)/9);

counts = counts(:,:,[1:size(counts,3),1]);
cos_tun = cos_tun(:,[1:size(cos_tun,2),1]);
dirs = [dirs;360];

i = 0;
for f = 1:fignum
    figure();
    for j = 1:9
        i = i+1;
        if i>length(cellnum)
            break
        end
        subplot(3,3,j)
        hold on
        boxplot(squeeze(counts(cellnum(i),:,:)),dirs,'Positions',dirs,'PlotStyle','compact','colors','k')  
        plot(dirs,cos_tun(cellnum(i),:),'r')
        plot(0:.1:360,tuningCurve(params(cellnum(i),:),0:.1:360),'g')
        xlim([0,360])
        hold off
        if plot_title == 1
            title(['cell: ', num2str(cellnum(i))])
        end
        if j == 9 | i == length(cellnum)
            legend({'cosine tuning','von Mises tuning'})
        end
    end
end
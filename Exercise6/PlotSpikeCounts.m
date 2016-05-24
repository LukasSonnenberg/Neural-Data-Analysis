function PlotSpikeCounts(dirs,counts,cellnum)
% dirs      directions of stimulus  1 x #directions
% counts    matrix of spike counts during stimulus presentation. The
%           matrix has dimensions #cells x #trials/direction x #directions
% cellnum   numbers of these cells, will be used in the title   1 x #cells
%                                                                   

%number of figures
fignum = ceil(size(counts,1)/9);

i = 0;
for f = 1:fignum
    figure();
    for j = 1:9
        i = i+1
        if i>size(counts,1)
            break
        end
        subplot(3,3,j)
        boxplot(squeeze(counts(i,:,:)),dirs)
    end
end
%Function for manually measuring bad frames
%marea is area for measured frames, circles is parameters for plotting 
%input (b) is list of frames for manual measurement
function [marea, circles] = fpsmf(b)
files = dir('*.tif'); %make list of all .tifs in dir
I = imread(files(1).name);
fprintf('Select multiple boundary points\n')

for fctr=1:length(b)
    I = imread(files(b(fctr)).name); %read in file(ctr)f
    I = I(:,:,3); %take highest contrast channel
    I = medfilt2(I,[3 3]);
    imshow(I),hold on
    wctr = 1;
    clear XY
    while 1==1
        try
            [XY(wctr,2), XY(wctr,1)] = ginput(1);
        catch
            circles(fctr,1:3) = [Par(1), Par(2), Par(3)];
            break
        end
        wctr = wctr + 1;
        if size(XY,1) >2 
            Par = CircleFitByPratt(XY);
            imshow(I), hold on
            viscircles([Par(2),Par(1)],Par(3),'linewidth',0.5,'lineStyle','--','EnhanceVisibility',false,'Color','r');
        end
    end
end
close
marea = circles(:,3).^2*pi;


            
        
        
    
    
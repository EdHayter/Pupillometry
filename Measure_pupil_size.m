%{
Run this script while current directory contains images.
Leaves the following variables
    area(:,1) - timestamps [currently commented out]
    area(:,2) - ellipse size 
    badframes - any frames that cause a matlab error
    ellipses - ellipse variables for each image
    files - list of file names in directory 
    RECT - cropping rectangle (outdated)

Ed Hayter 2018
%}
clear; close('all')
files = dir('*.tif'); %make list of all .tiffs in dir
IMG = imread(files(40).name); % Select example frame (change number if needed!)
%{
fprintf('Crop image to desired size by selecting area and double clicking\n')
[I, RECT] = imcrop(IMG);close %find cropping RECT
%}

I=IMG(:,:,3);
figure,imshow(I);
fprintf('Select pupil centre estimate\n')
[initx, inity] = ginput(1); %plant seed
inity = round(inity); 
initx = round(initx);
fprintf('Select top left & bottom right corners of reflection\n')
[reflectx, reflecty] = ginput(2);
reflecty = round(reflecty);
reflectx = round(reflectx);
%{
% Include this if you want an extra region cropped (ie if pupil boundary is
% hidden by eye lid)
fprintf('Select top left & bottom right corners of edge of eye\n') 
[rubbishx, rubbishy] = ginput(2);
rubbishy = round(rubbishy);
rubbishx = round(rubbishx);
%}
%{
fprintf('Select ROI\n')
h = imellipse(gca);
mask = createMask(h);
%}
close

while 1==1 %this loop is to allow user to test thresholds & decide
    imshow(I),hold on
    if ~exist('OK')
        threshold = input('Enter threshold: ');
        regionGrowingplot(I, [inity initx], threshold); 
    else
        threshold = OK;
        regionGrowingplot(I, [inity initx], threshold);
    end
    OK = input('Hit enter if threshold is OK, else enter new threshold: ');
    if isempty(OK)
        fprintf('Thanks! Running...\n')
        break
    end
end
close
badframes = [];

%y0 = initx; 
%x0 = inity; 
rx = reflectx;
ry = reflecty;
    

for fctr = 1:length(files)
    tic
    try
        IMG = imread(files(fctr).name); %read in file(ctr)
       % I = imcrop(IMG, RECT); %crop
        I = IMG(:,:,3); %take highest contrast channel. You can probably play about with this, my images were saved as RGB 
                        %and the blue channel seemed to give best contrast, might not be the case in yours? 
        I = medfilt2(I,[3 3]);
        processimage2 %use processimage2 if just fitting single ellipse.
    catch
        badframes(end+1)=fctr;
        areatemp(end+1) = 0;
        ellipses(fctr,1:5) = [0 0 0 0 0]; 
        if length(badframes) == 30
            error('too many bad frames')
        end
    end
end
area = areatemp; % added these two lines in to tidy things up. remove them if running the block below!!
clearvars -except area ellipses files badframes

%this section gets timestamps from image files - this will have to be
%rewritten based on how data is aquired.
%{
for ctr = 1:length(files) %import timestamps to first column of Area, converting to datenum in sec
    area(ctr) = str2num(files(ctr).name(20:21))*60*60 + str2num(files(ctr).name(22:23))*60 + str2num(files(ctr).name(24:25)) + str2num(files(ctr).name(26:28))/1000; +str2num(files(ctr).name(39:end-4))/1e6;
end
area = (area - min(area))'; %converts datenum to sec
area(:,2) = areatemp'; %add pupil sizes to second column
plot(area(:,1),area(:,2),'LineWidth',1,'Color','black');
clearvars -except area files ellipses RECT badframes
%}




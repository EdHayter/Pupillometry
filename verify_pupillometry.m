function verify_pupillometry(files,ellipses,num_to_visualise)
%get some random images
files_to_view = randi(length(files),[num_to_visualise,1]);
%loop over images
for ctr = 1:num_to_visualise
    image_num = files_to_view(ctr);
    I = imread(files(image_num).name);
    % I = imcrop(I, RECT);
    x0 = ellipses(image_num,1);
    y0 = ellipses(image_num,2);
    a = ellipses(image_num,3);
    b = ellipses(image_num,4);
    t = ellipses(image_num,5);
    ang = linspace(0,2*pi,90);
    %get rotation matrix
    Q = [cos(t), -sin(t); sin(t), cos(t)];
    x=a*cos(ang);y=b*sin(ang);
    p=[y',x'];
    pn=p*Q;
    pn(:,1)=pn(:,1)+y0;
    pn(:,2)=pn(:,2)+x0;
    figure,imshow(I), hold on, plot(pn(:,1),pn(:,2)) %plots ellipse
    title(image_num)
end
%process image to create XY list of boundary coordinates, fits single
%ellipse to those points and stores in variable ellipses

[~, Binary] = regionGrowing(I, [inity initx], threshold); %regiongrowing, set threshold
Binary = imcomplement(imfill(Binary,'holes')); % fill hole
Binary = imopen(Binary,strel('disk',5)); % Smooth
Binarydil = imdilate(Binary,ones(3)); % Dilate
Boundary =  imcomplement(Binarydil - Binary); %Find boundary
Boundary(ry(1):ry(2),rx(1):rx(2)) = 1; %gets rid of wobble from reflection

%uncomment if using the second removal square
%Boundary(rubbishy(1):rubbishy(2),rubbishx(1):rubbishx(2)) = 1; 
 

BW = ~Boundary;
[x, y] = ind2sub(size(BW),find(BW));
XY = [x y];

ellipse = EllipseDirectFit(XY);

A=ellipse(1);B=ellipse(2);C=ellipse(3);D=ellipse(4);E=ellipse(5);F=ellipse(6);
e = 4*A*C-B^2;
x0 = (B*E-2*C*D)/e; y0 = (B*D-2*A*E)/e;   % Ellipse center
F0 = -2*(A*x0^2+B*x0*y0+C*y0^2+D*x0+E*y0+F);
g = sqrt((A-C)^2+B^2); a = F0/(A+C+g); b = F0/(A+C-g);
a = sqrt(a);  b = sqrt(b); % Major & minor axes
t = 1/2*atan2(B,A-C); % Rotation angle (in radians, anticlockwise is positve)
%{
%uncomment this section to plot boundary on each image (if checking every frame)
ct = cos(t); st = sin(t); 
p = linspace(0,2*pi,500); cp = cos(p); sp = sin(p);   % Variable parameter
x = x0+a*ct*cp-b*st*sp; y = y0+a*st*cp+b*ct*sp;   % Generate points on ellipse
imshow(I), hold on
plot(y,x,'y--','lineWidth',1), axis equal
%}

areatemp(fctr) = pi * a * b;
ellipses(fctr,1:5) = [x0, y0, a, b, t];
%ellipses(fctr,1:3) = [Par(1), Par(2), Par(3)];
fprintf('%.2f%% done. Time taken: %.2f seconds\n',fctr/length(files)*100,toc);

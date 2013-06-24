function Canny(Image,High_T,Low_T,Sigma,Sz)
%This is the function to extract edge information from the image using
%Canny algorithm
%Image is the input original image
%High_T is the high threshold of the double threshold
%Low_T is the low threshold
%Sigma is the parameter of the Gaussian filter
%Sz is the size of the Gaussian mask

%First of all, make sure the image is gray based
[H,W,C]=size(Image);
if C~=1
    Image=rgb2gray(Image);
end
Image=double(Image);

figure;
imshow(Image,[]);

% %Step 1, use Gaussian Filter to remove noise
% %We first creat the Gaussian Mask
% GaMask=Gaussian(Sigma,Sz);
% %Filter the image
% Image=conv2(Image,GaMask,'same');
% 
% figure;
% imshow(Image,[]);

%Step 2, use Sobel operator to get the edge value
SobelX=[-1,0,1;-2,0,2;-1,0,1];
SobelY=[1 2 1;0 0 0;-1 -2 -1];

GradientX=conv2(Image,SobelX,'same');
GradientY=conv2(Image,SobelY,'same');
%Compute the edge strengths
EdgeStre=sqrt((GradientX).^2+(GradientY).^2);
%Compute the edge direction
EdgeDire=atan((GradientY)./(GradientX))*180/pi;

figure;
imshow(EdgeStre,[]);

%Step 3, Non-maximum suppression
for x=1:H
    for y=1:W
        %First of all, devide the direction in to 4-connected neighbourhood
        if (EdgeDire(x,y)>=-90 && EdgeDire(x,y)<-67.5) || (EdgeDire(x,y)>=67.5 && EdgeDire(x,y)<=90)
            EdgeDire(x,y)=90;
            Neigh1=EdgeStre(max(x-1,1),y);
            Neigh2=EdgeStre(min(x+1,H),y);
        elseif EdgeDire(x,y)>=-67.5 && EdgeDire(x,y)<-22.5
            EdgeDire(x,y)=-45;
            Neigh1=EdgeStre(max(x-1,1),max(y-1,1));
            Neigh2=EdgeStre(min(x+1,H),min(y+1,W));
        elseif EdgeDire(x,y)>=-22.5 && EdgeDire(x,y)<22.5
            EdgeDire(x,y)=0;
            Neigh1=EdgeStre(x,max(y-1,1));
            Neigh2=EdgeStre(x,min(y+1,W));
        elseif EdgeDire(x,y)>=22.5 && EdgeDire(x,y)<67.5
            EdgeDire(x,y)=45;
            Neigh1=EdgeStre(max(x-1,1),min(y+1,W));
            Neigh2=EdgeStre(min(x+1,H),max(y-1,1));
        end
        %After we know the direction, we compare the neighbour value
        if EdgeStre(x,y)<Neigh1 || EdgeStre(x,y)<Neigh2
            EdgeStre(x,y)=0;
        end
    end
end
%Crop off the image size edge
EdgeStre(1,:)=0;
EdgeStre(:,1)=0;
EdgeStre(H,:)=0;
EdgeStre(:,W)=0;

figure;
imshow(EdgeStre,[]);

%Step 4, Double thresholding
EdgeStre=EdgeStre/max(max(EdgeStre));
Indicator=ones(H,W);
%The pixel value which is larger than high threshold is marked as strong edge
temp=find(EdgeStre>=High_T);
Indicator(temp)=2;%We use 2 to indicate strong edge
EdgeStre(temp)=1;
%The pixel value which is smaller than low threshold is marked as background
temp=find(EdgeStre<=Low_T);
Indicator(temp)=0;%We use 0 to supress the 
EdgeStre(temp)=0;

figure;
imshow(EdgeStre,[]);

%Step 5, Edge tracking by hysteresis
flagg=1;
while (flagg)
    flagg=0;
    %Find the weak edges and get the poitions
    [InX,InY]=find(Indicator==1);
    for i=1:length(InX)
        %Find eight neighbours of the weak pixel
        N1=[max(InX(i)-1,1),max(InY(i)-1,1)];
        N2=[max(InX(i)-1,1),InY(i)];
        N3=[max(InX(i)-1,1),min(InY(i)+1,W)];
        N4=[InX(i),max(InY(i)-1,1)];
        N5=[InX(i),min(InY(i)+1,W)];
        N6=[min(InX(i)+1,H),max(InY(i)-1,1)];
        N7=[min(InX(i)+1,H),InY(i)];
        N8=[min(InX(i)+1,H),min(InY(i)+1,W)];
        if Indicator(N1(1),N1(2))==2 || Indicator(N2(1),N2(2))==2 || Indicator(N3(1),N3(2))==2 ...
            || Indicator(N4(1),N4(2))==2 || Indicator(N5(1),N5(2))==2 || Indicator(N6(1),N6(2))==2 ...
            || Indicator(N7(1),N7(2))==2 || Indicator(N8(1),N8(2))==2
            %If the neighbours do exist strong edges
            EdgeStre(InX(i),InY(i))=1;
            Indicator(InX(i),InY(i))=2;
            flagg=1;
        end
    end
end
EdgeStre(find(Indicator==1))=0;
figure;
imshow(EdgeStre,[]);
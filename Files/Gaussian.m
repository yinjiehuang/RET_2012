function GaMask=Gaussian(sigma,sz)
%This function is used to create the gaussian filter mask to remove the
%noise

% sz=ceil(6*sigma+1);
% if mod(sz,2)==0
%     sz=sz-1;
% end

GaMask=zeros(sz,sz);
center=(sz+1)/2;
for i=1:sz
    for j=1:sz
        GaMask(i,j)=(1/2*pi*sigma^2)*exp(-((i-center)^2+(j-center)^2)/(2*sigma^2));
    end
end

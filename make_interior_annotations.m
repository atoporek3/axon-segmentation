clc
clear
close all

%mkdir("images and masks")

data=load("centerpoints.mat");
images=data.images;
points=data.annotations;

for i=1:length(images)
    nAnnot = size(points{i},3);
    maj = floor(nAnnot/2);
    score = zeros (size(images{i}));
    
    image = double(images {i})/255;
    simplebin = imfill(imbinarize(image,adaptthresh(image)),'holes');
    region_ids = bwlabel(simplebin,4);
    %out is the ID of the larest region, the connected background
    out=mode(region_ids,'all');
    
    for j=1:nAnnot
        
        annots = points {i}(:,:,j);
        toUse=region_ids(annots==1);
        toUse(toUse==out)=[];
        thisUserScored=((ismember(region_ids,toUse)));
        score(thisUserScored)=score(thisUserScored)+1;
        
    end
    
    mask=(score>1);
    
%     imshow([image, score]);
%     pause();
    imwrite(image,['images and masks/','image_',num2str(i),'.tif'], 'Compression', 'none') ;
    imwrite(mask,['images and masks/','mask_',num2str(i),'.tif'], 'Compression', 'none') ;
       
    
    
end
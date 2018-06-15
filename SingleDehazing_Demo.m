% image dehazing demo
clear all;
close all
clc;

%--------------------------------------------------------------

% 
% %---------------------------------------------------------
% % 
% % % % % %a few sky patch
TestingDataDir='input_image\'
filename ='Hill.png';
% filename ='Cartoon.bmp';
% filename ='cones.bmp';
% filename ='forest1.bmp';
filename ='Doll.bmp';
% filename ='Canon (input).bmp';
% % filename ='DSC_0558-640x480.bmp';
% filename ='swan_input.bmp';
% % filename ='P1250427.bmp';
% filename ='Palace.png';
% filename='train.bmp';
%  filename='IMG_8766.bmp';
% filename='lake.jpg';
% %---------------------------------------------------
scale =1;
isSave=1;
LIM=[0,1];
isEnhanced=1;
gamma=0.8;

if(1)
    ix1=strfind(filename,'\');
    ix2=strfind(filename,'.');
    if(isempty(ix1))
        ix1=0;
    end
    strname=filename((ix1(end)+1):(ix2-1));       
end

im_hazy=imread(strcat(TestingDataDir,filename));
figure(1);imshow(im_hazy); title('Original Testing Image');

%^-------------------------------------%-----------------------------------------------
% Our method£ºnormal
method='OTSFDE'; J0=150;
[OurResults,Our_trans]=OTSFDE_method(im_hazy,method,J0);

if(isEnhanced)
%        OurResults=GammaEnhance(OurResults,im_hazy,gamma);
   OurResults=GammaEnhance(OurResults,im_hazy);
end
figure(2);imshow((OurResults));title('Dehazed Image via OTSFDE');
figure(21);mesh(Our_trans);figure(gcf);;  title('Estimated transmission Map via  OTSFDE');

%----------------------------------------
% Our method£ºfast
method='SOTSFDE'; J0=210;
[OurResults_fast,Our_trans_fast]=OTSFDE_method(im_hazy,method,J0);
if(isEnhanced)
%    OurResults_fast=GammaEnhance(OurResults_fast,im_hazy,gamma);
   OurResults_fast=GammaEnhance(OurResults_fast,im_hazy);
end
figure(20);imshow((OurResults_fast));title('Dehazed Image via SOTSFDE method');
figure(210);imagesc(Our_trans_fast);figure(gcf);;  title('Estimated transmission Map via SOTSFDE method');


%------------------------------------------------







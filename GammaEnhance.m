function [ enhanced_im ] = GammaEnhance( I, refImage,gamma )
if(nargin==3)
   method2=1;
   method1=0;
else
    method2=0;
    method1=1;
end


if(method1)
    DEUBG=0;
        %UNTITLED Summary of this function goes here
        refImage=double(refImage);
        I=double(I);
        
        hsv_ref=rgb2hsv((refImage));
        hsv_im=rgb2hsv(I);          
        V_ref=hsv_ref(:,:,3);
        m_V_ref=mean(V_ref(:));
        K=128/m_V_ref;
        V_ref=V_ref*K;
        
        V_im=hsv_im(:,:,3);  
        V_im=max(V_im,5);
        
         eps=10^(2);
         r=50;
         lamuta=0.1;
        
         p_num=V_im.*V_ref+lamuta*(V_ref).^2;
         p_den=(V_im).^2+lamuta*(V_ref).^2;
         p=p_num./(p_den+0.00001);
         
         if(0)
               s=guidedfilter_color(im,p, r,eps); 
               s=max(s,0.8);
               s=min(s,20); 
                for c=1:3
                     I(:,:,c) =double(I(:,:,c)).*s;                
                end         
         else
             
               s= guidedfilter(V_ref,p, r,eps);
              s=max(s,0.8);
               s=min(s,10);             
               
              hsv_im(:,:,3)=min((V_im.*s),255);              
              enhanced_im=hsv2rgb(hsv_im);                         
              enhanced_im=uint8(enhanced_im);            
         end
                        
         if(DEUBG)
              figure(20001);mesh(s);title(' illuminance enhancement factor');
         end                  

elseif(method2)
   % perform histogram adjustment before showing the image
       I=single(I);
        [row,col,~] = size(I);
        % img=double(img);
        % --- RGB 2 HSV ---
        HSV = rgb2hsv(I);
        V = HSV(:,:,3)/255;    
        mean_V=mean(V(:));
        
        HSV_ref= rgb2hsv(single(refImage));
        V_ref=HSV_ref(:,:,3)/255;
        mean_V_ref=mean(V_ref(:));
%         mean_V_ref=max(mean_V_ref,0.5);         
        gamma=max(log(mean_V_ref)/log(mean_V),0.70);
        gamma=min(gamma,0.95);
                
        adjustedV =V.^gamma*255; 
        HSV(:,:,3)=adjustedV;
        
        enhanced_im = hsv2rgb(HSV);
       enhanced_im = uint8(enhanced_im);
        
else
    
    enhanced_im = AGCWD(I);
    
end

end


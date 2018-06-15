 function feat = computerfeature_new(I,isTest)
 % isTest=1, 表示仅计算3个特征来计算trans，否则计算所有特征
 
% RGB and gray channel
       I=double(I);
        [row col dim]           = size(I);
      
           
    if(0)
            R                       = I(:,:,1);                             % Red
            G                       = I(:,:,2);                             % Green
            B                       = I(:,:,3);                             % Blue
            
          % comput  features: the standard deviation of chroma
            rg=R-G;
            yb=(R+G)/2-B;
           
            mean_rg = mean(rg(:));
            mean_yb = mean(yb(:));

            mean_rg2= mean(rg(:).*rg(:));
            mean_yb2= mean(yb(:).*yb(:));
            var_rg = mean_rg2 - mean_rg .* mean_rg;
            var_yb = mean_yb2 - mean_yb .* mean_yb;

            K=85.59;
            std_c=sqrt(var_rg+var_yb)+0.3*sqrt(mean_rg.^2+mean_yb.^2)/K; %standard deviation of chroma
            % std_c=std_c/max(std_c(:));  %normalized

            %------------------------------
            % the luminance contrast  
            hsv=rgb2hsv(I);
            v=hsv(:,:,3);
            s=hsv(:,:,2);
            if(0)
               max_v=max(v(:));
               min_v=min(v(:));
                contrast_I=(max_v+min_v)/(max_v-min_v+0.5)    ;          %luminance contrast                
            else
                mean_v=mean(v(:));
                contrast_I=abs(v-mean_v);
            end
            contrast_I=mean(contrast_I(:));
            % contrast_I=contrast_I./max(contrast_I(:)); %normalized

            mean_s= mean(s(:));   %saturation 
            % mean_s=mean_s./max(mean_s(:));  %normalized

           feat=[std_c,contrast_I,mean_s];
        
        
    else           
           [row col dim]           = size(I);
            ps=15;
           
            
             % HSV color space: saturation image: Is                
              I_hsv                   = rgb2hsv(I);
              Is                      = I_hsv(:,:,2);%eq(15) 
              Iv                      = I_hsv(:,:,3);      
              
              R                       = I(:,:,1);                             % Red
              G                       = I(:,:,2);                             % Green
              B                       = I(:,:,3);                             % Blue
                            
           feat=[];
           if(isTest==0)                                      
                         
                %             I=cat(3,R,G,B);
                            I_gray=uint8(I);
                            Ig                      = double(rgb2gray(I_gray));    % Gray             
                        % Dark channel prior image: Id, pixel-wise, scaled to [0 1]
                        % normalization
                            Irn                     = R./255;
                            Ign                     = G./255;
                            Ibn                     = B./255;
                            Id                      = min(min(Irn,Ign),Ibn);%eq(14)
                      
                        % MSCN
                            MSCN_window             = fspecial('gaussian',7,7/6);%Wl,k in eq(7)
                            MSCN_window             = MSCN_window/sum(sum(MSCN_window));        
                            warning('off');               
                            mu                      = imfilter(Ig,MSCN_window,'replicate');%eq(7)
                            mu_sq                   = mu.*mu;
                            sigma                   = sqrt(abs(imfilter(Ig.*Ig,MSCN_window,'replicate') - mu_sq));%eq(8)
                            MSCN                    = (Ig-mu)./(sigma+1);%eq(6)
                            cv                      = sigma./mu; %eq(10)                                     

                    %% Fog aware statistical feature extraction     
                        % f1        
                            MSCN_var                = nanvar(im2col(MSCN,[ps,ps], 'distinct'));
                        % f2,f3                    
                            MSCN_V_pair_col         = im2col((MSCN.*circshift(MSCN,[1 0])),[ps ps], 'distinct');
                            MSCN_V_pair_col_temp1   = MSCN_V_pair_col; MSCN_V_pair_col_temp1(MSCN_V_pair_col_temp1>0)=NaN;
                            MSCN_V_pair_col_temp2   = MSCN_V_pair_col; MSCN_V_pair_col_temp2(MSCN_V_pair_col_temp2<0)=NaN;
                            MSCN_V_pair_L_var       = nanvar(MSCN_V_pair_col_temp1);
                            MSCN_V_pair_R_var       = nanvar(MSCN_V_pair_col_temp2);
                %         f4        
                            Mean_sigma              = mean(im2col(sigma, [ps ps], 'distinct'));
                         % f5        
                             Mean_cv                 = mean(im2col(cv, [ps ps], 'distinct'));
                        % f6, f7, f8                    
                            [CE_gray CE_by CE_rg]   = CE1(I,ps);
                            Mean_CE_gray            = mean(im2col(CE_gray, [ps ps], 'distinct'));
                            Mean_CE_by              = mean(im2col(CE_by, [ps ps], 'distinct'));
                            Mean_CE_rg              = mean(im2col(CE_rg, [ps ps], 'distinct'));     
                %         f9        
                            IE_temp                 = num2cell(im2col(uint8(Ig), [ps ps], 'distinct'),1);
                            IE                      = cellfun(@entropy,IE_temp);
                %         f10        
                %              Mean_Id                 = mean(im2col(Id, [ps ps], 'distinct'));
                   
                            % f11        
                             Mean_Is                 = mean(im2col(Is, [ps ps], 'distinct'));
                        % f12        
                         % rg and by channel
                            rg                      = R-G;%rg = R-G in eq(11)
                            by                      = 0.5*(R+G)-B;%yb = 0.5(R+G)-B in eq(11）  
                            CF                      = sqrt(std(im2col(rg, [ps ps], 'distinct')).^2 + std(im2col(by, [ps ps], 'distinct')).^2) + 0.3* sqrt(mean(im2col(rg, [ps ps], 'distinct')).^2 + mean(im2col(by, [ps ps], 'distinct')).^2);   
                            K=85.59;
                            CF=CF/K;
                       % the luminance contrast  
                           if(0)
                               max_v=max(Iv(:));
                               min_v=min(Iv(:));
                               contrast_I=(max_v+min_v)/(max_v-min_v+0.5);          %luminance contrast                
                            else%                                   
                                    h = fspecial('average',11); 
                                    s_Iv = imfilter(Iv,h,'same','replicate');  
                                    Th=18;
                                    Th_min=0.1;
                                    if(1)
                                         mag=abs(Iv-s_Iv);
                                         ix=find(mag<Th_min);
                                         mag(ix)=Th_min;
                                         weber_mag=mag./(s_Iv+1);                         
                                         ix=find(mag>Th);
                                         if(length(ix)>1)
                                            mag(ix)=Th; 
                                         end
                                         
                                    else                    
                                            [vx,vy]=gradient(Iv);
                                            mag=abs(vx)+abs(vy);                    
                                            weber_mag=mag./(Iv+1);
                                    end                                  
                                   
                                    Mean_contrast                 = mean(im2col(mag, [ps ps], 'distinct'));
                                    Mean_Weber_contast                 = mean(im2col(weber_mag, [ps ps], 'distinct'));
                                       
                            end
                            
                      feat=[MSCN_var(:) MSCN_V_pair_R_var(:) MSCN_V_pair_L_var(:) Mean_sigma(:) Mean_cv(:) Mean_CE_gray(:) Mean_CE_by(:) Mean_CE_rg(:) IE(:) Mean_Is(:) CF(:) Mean_contrast(:) Mean_Weber_contast(:)];
           else
                  % isTest=1;
                   % f11                                   
                    Mean_Is                 = reshape(mean(im2col(Is, [ps ps], 'distinct')),[row col]/ps);
                        
                    % f12        
                         % rg and by channel
                            rg                      = R-G;%rg = R-G in eq(11)
                            by                      = 0.5*(R+G)-B;%yb = 0.5(R+G)-B in eq(11）  
                            CF                      = sqrt(std(im2col(rg, [ps ps], 'distinct')).^2 + std(im2col(by, [ps ps], 'distinct')).^2) + 0.3* sqrt(mean(im2col(rg, [ps ps], 'distinct')).^2 + mean(im2col(by, [ps ps], 'distinct')).^2);   
                            K=85.59;
                            CF=CF/K;
                       % the luminance contrast                                                            
                            h = fspecial('average',11); 
                            s_Iv = imfilter(Iv,h,'same','replicate');  
                            Th=18;
                            Th_min=3;
                            if(0)
                                         mag=abs(Iv-s_Iv);
                                         ix=find(mag<Th_min);
                                         mag(ix)=Th_min;
                                         
                                         weber_mag=mag./(s_Iv+1);                         
                                         ix=find(mag>Th);
                                         if(length(ix)>1)
                                            mag(ix)=Th; 
                                         end
                           else                    
                                            [vx,vy]=gradient(Iv);
                                            mag=abs(vx)+abs(vy);    
                                         ix=find(mag<Th_min);
                                         mag(ix)=Th_min;
                                         
                                            weber_mag=mag./(Iv+1);
                           end

                                   Mean_contrast                 = mean(im2col(mag, [ps ps], 'distinct'));
                                   Mean_Weber_contast                 = mean(im2col(weber_mag, [ps ps], 'distinct'));
                        
                    
                     CF=mean(CF(:));
                     feat=[Mean_Is(:) CF(:) Mean_contrast(:) Mean_Weber_contast(:)];     
%                      feat=[Mean_Is(:) CF(:) Mean_Weber_contast,Mean_contrast];  
               
           end                      


    end
 end





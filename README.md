# OTSFDE and SOTSFDE

##Optimal Transmission Estimation via Fog Density Perception for Efficient Single Image Defogging
(http://dx.doi.org/10.1109/TMM.2017.2778565) (IEEE Trans. Multimedia)


##This MATLAB code is an implementation of the single image dehazing algorithm proposed in the paper "Optimal Transmission Estimation via Fog Density Perception for Efficient Single Image Defogging" by Zhigang Ling, Jianwei Gong, Guoliang Fan and Xiao Lu.

##Introduction
Single image defogging algorithms based on prior assumptions or constraints have captured much attention because of their simplicity and practicality. However, they still have some challenges to deal with foggy images captured under weather conditions where these assumptions or constraints may not be effective or efficient enough. In this paper, we aim to develop a novel image defogging algorithm by directly predicting the fog density of recovered images rather than adopting prior assumptions or constraints. In order to achieve this goal, two specific steps are introduced. First, we adopt three fog-relevant statistical features derived from foggy images, and further develop a simple fog density evaluator (SFDE) by creating a linear combination of these fog-relevant features. This proposed evaluator can efficiently perceive the fog density of a single image without reference to a corresponding fog-free image and has a low computational load compared with an existing method. Second, a physics-based mathematical relationship between the transmission and the fog density score of the recovered image is developed via SFDE, thus image defogging can be posed as a minimization problem on the fog density score of the recovered image. As a result, two optimal transmission models, called an Optimal Transmission model via SFDE (OTSFDE) and a Simpler Optimal Transmission models via SFDE (SOTSFDE), are present to determine the key transmission map for efficient fog removal. Compared to OTSFDE, SOTSFDE has low computational complexity with slight performance degradation. Experimental results demonstrate that the proposed algorithms can effectively remove fog and are not confined by any assumptions or constraints, both quantitatively and qualitatively, compared with some existing algorithms.


If you use these codes in your research, please cite:

	@inproceedings{OTSFDE_Ling_2018,		
	  title={Optimal Transmission Estimation via Fog Density Perception for Efficient Single Image Defogging},
	  author={Zhigang Ling, Jianwei Gong, Guoliang Fan and Xiao Lu},
	  booktitle={IEEE Trans. Multimedia},
	  year={2018}
	} 


##Dependencies

The code can be run on MATLAB R2015a. 


##How to generate the results

Enter the src directory, run SingleDehazing_Demo.m. It will use images under img directory as default to produce the results. 
GammaEnhance.m is used to improve the exposure of defogged images for better visual quality.


# Authors
  Zhigang Ling, zgling_hunan@126.com


##License

The software code of the OTSFDE and SOTSFDE algorithm is provided for non-commercial use under the attached LICENSE.md
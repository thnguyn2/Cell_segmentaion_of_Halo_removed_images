%This script demonstrate the cell segmentation results
%Author: Tan H. Nguyen
%University of Illinois at Urbana-Champaign
clc;
clear all;
close all;
im = cast(imread('E:\Data_for_cell_segmentation\f0_t71_i0_ch0_c10_r16_z0_HR_NS.tif'),'single');

figure(1);
subplot(221);
imagesc(im);
colormap jet
title('Original image');

%Smooth out the image before moving on to avoid the noise
ho = fspecial('gaussian',[30 30],1);
im = imfilter(im,ho,'same');
%Generate the binary mask for the cells
[~,threshold]=edge(im,'sobel');
%Return the threshold value for the edge response calculate from the gradient information with the Sobel filter
disp(['Detected thresold for the image ' num2str(threshold)]);
fudgeFactor = 0.5;
bw = edge(im,'sobel',threshold*fudgeFactor);
%Dilate the image
se90 = strel('line',5,90);
se = strel('line',5,0);
bw_dil = imdilate(bw,[se90 se]); %Dilate the image horizontally and vertically
bw_dil = imfill(bw_dil,'holes');%Fill out the holes inside the cells
minarea = 2000;

%Make sure the background is nicer
bg = 1-bw_dil;
bgse90 = strel('line',1,90);
bgse = strel('line',1,0);
bg_dil = imclose(bg,strel('disk',5));
bg_dil = bwareaopen(bg_dil,50);
bw_dil = bw_dil.*(1-bg_dil);
bw_dil = bwareaopen(bw_dil,minarea);

subplot(222);
imagesc(bw_dil);colormap gray;

subplot(223);

imagesc(bg_dil);title('Background mask')
%Make sure we get rid of too small cells
%Create a label map for the cell indices
L = bwlabel(bw_dil,4);
subplot(224);
imagesc(L);


%% SIR SDR SAR <<Separatrion>>
clc;clear all;close all

fs=16000;
s_1=audioread('C:\Users\chen\array\female_16k_10s.wav'); % 原始
s_2=audioread('C:\Users\chen\array\male_16k_10s.wav');
s=[s_1(1:fs*4).'/max(abs(s_1(1:fs*4)));s_2(1:fs*4).'/max(abs(s_2(1:fs*4)))];

se_1 = audioread('C:\Users\chen\array\TIKR_sep61_0.001.wav'); % 分離
se_2 = audioread('C:\Users\chen\array\TIKR_sep62_0.001.wav');
% se_1 = audioread('C:\Users\yicheng\Desktop\Master_Program\Localization\J_STSP\Circular_array\Separation_result\sSor_2tEnhanced.wav'); % 分離
% se_2 = audioread('C:\Users\yicheng\Desktop\Master_Program\Localization\J_STSP\Circular_array\Separation_result\sSor_1tEnhanced.wav');
% se_1 = audioread('C:\Users\yicheng\Desktop\Master_Program\Localization\J_STSP\Circular_array\Separation_result\SD source2 iter150.wav'); % 分離
% se_2 = audioread('C:\Users\yicheng\Desktop\Master_Program\Localization\J_STSP\Circular_array\Separation_result\SD source1 iter150.wav');;
% se_1 = audioread('C:\Users\yicheng\Desktop\Master_Program\Localization\J_STSP\Circular_array\Separation_result\raw.wav'); % 分離
% se_2 = audioread('C:\Users\yicheng\Desktop\Master_Program\Localization\J_STSP\Circular_array\Separation_result\raw.wav');
se=[se_1(1:fs*4).';se_2(1:fs*4).'];
% ie=se;

[SDR,SIR,SAR,perm]=bss_eval_sources(se,s)

% [SDR,ISR,SIR,SAR,perm]=bss_eval_images(ie,i)
% SDR:source to distortion ratio
% SIR:source ti interferences ratio
% SAR:source to artifacts
% range: negative infinite to infinite
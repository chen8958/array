angle=0:15:345;
MicPos=(1/100)*4.5*[sind(angle);cosd(angle);zeros(1,length(angle))];
for i=1:length(angle)
    
    [P_half SorPos SorLen p]=Mix3D_Plan_HRTF_function(MicPos,[angle(i),90]);
    display(angle(i));
    model_matching(angle,MicPos,angle(i));
    
end
surround(angle);
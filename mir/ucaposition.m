function position=ucaposition(M,r,Center_X,Center_Y,Center_Z,leadlag)
mode=input('chooose line axis 1.xyplane 2.y yzplane 3. z xzplane:');
radius = r;
theta = 360/M;
switch (mode)
    case 1
    for i =1:M
    position(1,i)=Center_X+radius*cosd((i-1)*theta+leadlag);
    position(2,i)=Center_Y+radius*sind((i-1)*theta+leadlag);
    position(3,i)=Center_Z;
    end
    case 2
    for i =1:M
    position(1,i)=Center_X;
    position(2,i)=Center_Y+radius*cosd((i-1)*theta+leadlag);
    position(3,i)=Center_Z+radius*sind((i-1)*theta+leadlag);
    end
    case 3
    for i =1:M
    position(1,i)=Center_X+radius*cosd((i-1)*theta+leadlag);
    position(2,i)=Center_Y;
    position(3,i)=Center_Z+radius*sind((i-1)*theta+leadlag);
    end
end
end

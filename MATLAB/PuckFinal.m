function [X_final, Y_final] = PuckFinal2(X_n, Y_n, X_b, Y_b, WIDTH, RADII)

X_temp = -1;
Y_temp = 0;

% Angle between points
theta = atan(abs(X_n - X_b)/abs(Y_n - Y_b));

% Length in x-direction from puck to racket
L = abs(Y_b - Y_temp)*tan(theta);

% Length between points in Y-direction. This is for ignoring very small changes.
LY = abs(Y_b-Y_n); 

if((Y_n < Y_b && LY > 0.005) && (X_n > RADII/2 && X_n < WIDTH - RADII/2))
while X_n ~= X_temp && Y_n ~= Y_temp 
    
   % Left side
    if X_n < X_b 
        if L > (X_b - RADII) 
            Y_vvegg = Y_b - (X_b - RADII)/tan(theta);  
            Y_b = Y_vvegg;
            X_b = RADII;
            X_n = RADII + 0.1*tan(theta);
            L = (Y_b - Y_temp)*tan(theta);
        else
            X_temp = X_b - (Y_b - Y_temp)*tan(theta) + 0.05*theta; 
            X_n = X_temp; 
            Y_n = Y_temp;
        end
    
    % Right side
    elseif X_n > X_b
        if L + X_b > (WIDTH - RADII)
            Y_hvegg = Y_b - (WIDTH - RADII - X_b)/tan(theta);
            Y_b = Y_hvegg;
            X_b = WIDTH - RADII;
            X_n = WIDTH - RADII - 0.1*tan(theta);
            L = (Y_b - Y_temp)*tan(theta);
        else
            X_temp = X_b + (Y_b - Y_temp)*tan(theta)- 0.05*theta;
            X_n = X_temp;
            Y_n = Y_temp;
        end
        
    else
        X_temp = WIDTH/2 - 0.045;
    end
end

else
    X_temp = WIDTH/2 - 0.045;
end
X_final = X_temp;
Y_final = Y_temp;
end
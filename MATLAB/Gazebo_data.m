%  cmd: rosinit('127.0.0.1')
%  cmd: rosshutdown 
x_base = [0 0.76 0.76 0 0]; y_base = [-0.04 -0.04 1.80 1.80 -0.04];
plot(x_base, y_base, 'b')
axis([-0.04 0.80, -0.08 1.84]);
x_robot_before = 0; 
sist_plot = 0;
have_plotted = false;
X_before = 0;
Y_before = 0;
X = 33.5; Y = 0;
WIDTH = 0.76; RADII = 0.04;
hold on

pub1 = rospublisher('/slider_controller_pos/command','std_msgs/Float64MultiArray')
pause(1)
msg = rosmessage(pub1)
msg.Data = [0.0,0.0]
send(pub1,msg)

%Subscriber 
sub = rossubscriber("/gazebo/link_states","gazebo_msgs/LinkStates");
pause(1)
subPos = sub.LatestMessage 
subPos_name = subPos.Name

% Find the position of where puck is in the subscriber messages
index = find(strcmp(subPos_name, 'gazebo2::dummy'))

% Get puck X and Y position
X_now = subPos.Pose(index).Position.X + 0.335; % Puck_x + offset
Y_now = subPos.Pose(index).Position.Y + 0.9; % Puck_y + offset

for i = 1:1500
        
    subPos = sub.LatestMessage;
    X_before = X_now;
    Y_before = Y_now;
    
    
    % Get puck X and Y position
    X_now = subPos.Pose(index).Position.X + 0.335; % Puck + offset
    Y_now = subPos.Pose(index).Position.Y + 0.9; % Puck  
    
    %Calculate the position of where the puck will land
    [X, Y] = PuckFinal(X_now, Y_now, X_before, Y_before, WIDTH, RADII);
    
    % Check if the output display should be cleared.
    if (Y_now > Y_before && Y_now > 0.3 )
        cla reset;
        have_plotted = false;
        plot(x_base, y_base, 'b')
        axis([-0.04 0.80, -0.08 1.84]);
        hold on
    end
    
    %Check if the output display should draw the estimated puck landing
    %position
    if ( (abs(x_robot_before - X) > 0.12 && i > sist_plot + 20) || ~have_plotted)
        x_robot_before = X;
        have_plotted = PuckFinalDrawing(X_now, Y_now, X_before, Y_before, WIDTH, RADII, 'b',have_plotted);
    end
    
    
    %Send the position where the racket should go to gazebo
    msg.Data = [Y, X];
    send(pub1,msg);
    
    %Update delay
    pause(0.03);
end
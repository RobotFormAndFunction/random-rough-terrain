%Terrain block variation
%This is based off of the 2008 JEB paper Neuromechanical response of 
%musculo-skeletal structures in cockroaches during rapid running on
%rough terrain (https://doi.org/10.1242/jeb.012385)

%All dimensions are in mm

clear all; close all; clc;

HipHeight=0.1; %mm This is the hip height of the robot
RobotBodyLength=4; %mm This is the body length of the robot
SideLength=RobotBodyLength/4; %mm locks are scaled to 1/4 the length
%of the robot
Ground=0; %This sets the ground plane, one could make a solid block base
UpperBound=3*HipHeight; %mm This sets the upper bound of the distribution
Mean=UpperBound/2; %mm
StandardDeviation=Mean/3; %mm

ArenaLength=RobotBodyLength*10; %mm - How many multiples of body lengths
ArenaWidth=RobotBodyLength*5; %mm - How many multiples of body lengths

Blocks=abs(normrnd((Mean),(StandardDeviation),...
    [ArenaLength/SideLength ArenaWidth/SideLength]));
Block_vector=reshape(Blocks,numel(Blocks),1);

figure(1) %plotting histogram of blocks
histfit(Block_vector,7)
xlabel('Block elevation (mm)')
ylabel('Block count')

figure(2) %plotting 3D visualization of terrain
bar3(Blocks,1)
axis equal

X=0:SideLength:ArenaWidth-1;
Y=0:SideLength:ArenaLength-1;
loop=1;

%moving generated data to cells to construct STL files
vertices_cell=cell(numel(Blocks),1);
faces_cell=cell(numel(Blocks),1);

for index1=1:length(X)
    for index2=1:length(Y)
        x_corner=X(index1);
        y_corner=Y(index2);
        height=Blocks(index2,index1);
        vertices_cell{loop,1}=cube_vertices(x_corner,y_corner,SideLength,height,Ground);
        faces_cell{loop,1}=cube_faces(loop);
        loop=loop+1;
    end
end

fv.vertices=cell2mat(vertices_cell);
fv.faces=cell2mat(faces_cell);

%% Render
% The model is rendered with a PATCH graphics object. We also add some dynamic
% lighting, and adjust the material properties to change the specular
% highlighting.
figure(3)
patch(fv,'FaceColor',       [0.8 0.8 1.0], ...
         'EdgeColor',       'none',        ...
         'FaceLighting',    'gouraud',     ...
         'AmbientStrength', 0.15);

% Add a camera light, and tone down the specular highlighting
camlight('headlight');
material('dull');

% Fix the axes scaling, and set a nice view angle
axis('image');
view([-30 30]);
xlabel('Width (mm)')
ylabel('Length (mm)')
zlabel('Elevation (mm)')

%% Write file
stlwrite('terrain.stl',fv);



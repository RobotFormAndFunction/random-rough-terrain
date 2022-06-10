%used with cube_verticies
%This function reshapes the data for cubes to work with the STL files

function [faces]=cube_faces(cube_number)
array=(cube_number-1)*36+1:1:cube_number*36;
faces=transpose(reshape(array, 3, 12));
end
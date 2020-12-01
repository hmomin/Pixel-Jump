classdef Pipe < handle
    %PIPE is a Pipe in the game that the Player can collide with.
    %   x is the x-location of the Pipe and y is a vector of the y-values that the Pipe is
    %   composed of. onTop is a boolean that indicates whether the Pipe is on top or on
    %   the bottom of the screen. length is the length of the Pipe.
    
    properties
        x;
        y;
        onTop;
        length;
    end
    
    methods
        function obj = Pipe()
            %PIPE constructor just resets the Pipe to the end of the scene.
            obj.reset();
        end
        
        function update(obj)
            %UPDATE updates the Pipe object on each frame.
            global img;
            obj.x = obj.x - 1;
            if obj.x > 0
                img(obj.y, obj.x, 1) = 255;
                img(obj.y, obj.x, 2) = 0;
                img(obj.y, obj.x, 3) = 0;
            else
                obj.reset();
            end
        end
        
        function reset(obj)
            %RESET resets a Pipe object to its original state about to pass through the
            %scene.
            global img;
            obj.x = 37;
            obj.onTop = rand() > 0.5;
            if obj.onTop
                obj.length = randi([5, 8]);
                obj.y = (1: obj.length);
            else
                obj.length = randi(4);
                numRows = size(img, 1);
                obj.y = (numRows: -1: numRows - obj.length);
            end
        end
    end
end
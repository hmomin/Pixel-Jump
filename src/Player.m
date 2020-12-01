classdef Player < handle
    %PLAYER is a pixel-based representation of the character that walks
    %through Pixel Jump.
    %   (xNorm, yNorm) are respective (x, y) values when the player looks like it's facing
    %   you. (xWalk, yWalk) are (x, y) values when the player looks like a stick-figure.
    %   (xDuck, yDuck) are (x, y) values when the player looks like it's ducking. walkOn
    %   alternates the player between 'norm' and 'walk' values to give off the appearance
    %   of walking. jumpCount keeps track of where in jumpFrames the player is to indicate
    %   whether or not the player should be jumping.
    
    properties
        xNorm = [3, 4, 5, 5, 5, 4, 3, 3, 4, 4, 3, 5, 4, 3, 5];
        yNorm = [7, 7, 7, 8, 9, 9, 9, 8, 10, 11, 11, 11, 12, 13, 13];
        xWalk = [3, 4, 5, 5, 5, 4, 3, 3, 4, 4, 4, 4];
        yWalk = [7, 7, 7, 8, 9, 9, 9, 8, 10, 11, 12, 13];
        xDuck = [3, 3, 3, 3, 4, 5, 5, 5, 5, 4];
        yDuck = [13, 12, 11, 10, 10, 10, 11, 12, 13, 12];
        x, y;
        walkOn = false;
        jumpCount = 0;
        jumpFrames = [4, 1, 0, -1, -4];
    end
    
    methods
        function obj = Player()
            %PLAYER constructor initializes the player to 'norm' values.
            obj.x = obj.xNorm;
            obj.y = obj.yNorm;
        end
        
        function update(obj)
            %UPDATE simply updates the image to show the player's x and y values.
            global img;
            for k = 1: length(obj.x)
                img(obj.y(k), obj.x(k), 2) = 255;
                img(obj.y(k), obj.x(k), 3) = 255;
            end
        end
        
        function jumpUpdater(obj)
            %JUMPUPDATER allows the player to execute an entire jump sequence even if the
            %user/network stops pressing up midway through.
            if obj.jumpCount == 0
                obj.x = obj.xWalk;
                obj.y = obj.yWalk;
            end
            if obj.jumpCount == length(obj.jumpFrames)
                obj.jumpCount = 0;
            else
                obj.jumpCount = obj.jumpCount + 1;
                obj.y = obj.y - obj.jumpFrames(obj.jumpCount);
            end
        end
        
        function walkUpdater(obj)
            %WALKUPDATER alternates the player between 'norm' and 'walk' values to give
            %off the illusion of walking.
            obj.jumpCount = 0;
            if obj.walkOn
                obj.x = obj.xNorm;
                obj.y = obj.yNorm;
            else
                obj.x = obj.xWalk;
                obj.y = obj.yWalk;
            end
            obj.walkOn = ~obj.walkOn;
        end
        
        function duck(obj)
            %DUCK simply sets the player's (x, y) values to 'duck' values.
            obj.jumpCount = 0;
            obj.x = obj.xDuck;
            obj.y = obj.yDuck;
        end
    end
end
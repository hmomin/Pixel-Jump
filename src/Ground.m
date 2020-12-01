classdef Ground < handle
    %GROUND is a pixel-based representation of the ground that the Player walks on.
    %   vals keeps track of which part of the ground is safe (0 or 1) and which is lava
    %   (-1). If lavaOn is true, lava is currently being drawn out and lavaRange will
    %   decrease on each subsequent frame. lavaProbability controls how frequently lava
    %   appears and the frequency increases over time.
    
    properties
        vals = zeros(1, 36);
        lavaOn = false;
        lavaProbability = 0.01;
        lavaRange = 0;
    end
    
    methods
        function obj = Ground()
            %GROUND constructor initializes a safe, patchy ground.
            for k = 1: 36
                if mod(k, 2) == 0
                    obj.vals(k) = 0;
                else
                    obj.vals(k) = 1;
                end
            end
        end
        
        function update(obj)
            %UPDATE updates the Ground object on each frame.
            
            global img pipe;
            % shift the ground patches up...
            obj.vals(1: end - 1) = obj.vals(2: end);
            % ... then determine the last one probabilistically
            if obj.lavaOn
                if obj.lavaRange == 0
                    % lava is done, the next patch is ground.
                    obj.vals(end) = 0;
                    obj.lavaOn = false;
                else
                    obj.vals(end) = -1;
                    obj.lavaRange = obj.lavaRange - 1;
                end
            else
                % lava can't be too close to a pipe or another lava puddle
                if rand() < obj.lavaProbability ...
                        && min([pipe.x, 36 - pipe.x]) > 5 ...
                        && ~any(obj.vals(end - 4: end - 2) == -1)
                    obj.lavaOn = true;
                    obj.lavaRange = randi([0, 1]);
                    obj.vals(end) = -1;
                elseif obj.vals(end - 1) == 0
                    obj.vals(end) = 1;
                elseif obj.vals(end - 1) == 1
                    obj.vals(end) = 0;
                end
            end
            % update the ground in the image
            for k = 1: length(obj.vals)
                if obj.vals(k) >= 0
                    img(size(img, 1), k, 2) = 100;
                    if obj.vals(k) == 0
                        img(size(img, 1), k, 3) = 0;
                    elseif obj.vals(k) == 1
                        img(size(img, 1), k, 3) = 100;
                    end
                else
                    img(size(img, 1), k, 1) = 255;
                end
            end
            % increase probability of lava ever-so-slightly on each update
            if obj.lavaProbability < 1
                obj.lavaProbability = obj.lavaProbability + 0.0001;
            end
        end
    end
end
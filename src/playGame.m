function playGame()
    %PLAYGAME creates the game for user-play or auto-play and continuously loops until the
    %game finishes.
    global gameOver gameStarted ground img player currKey pipe scoreText beginText gameOverText autoplay;
    
    if autoplay
        load pretrained.mat bestNet;
    end
    
    set(gameOverText, 'visible', 'off');
    player = Player();
    ground = Ground();
    pipe = Pipe();
    t = 0.2;
    score = 0;
    
    startTime = tic;
    % update the game on each frame increment
    while ~gameOver
        % check if figure exists
        g = groot;
        if isempty(g.Children)
            return;
        end
        if gameStarted
            % grab output behavior if autoplaying
            if autoplay
                output = bestNet.feedForward(getInputs());
                [~, idx] = max(output);
                % idx mapping: 1 -> jump, 2 -> walk, 3 -> duck
                % we can map to currKey using a snazzy linear transformation
                currKey = -idx + 2;
            end
            
            % clean display
            img(:, :, :) = 0;
            
            % adjust player behavior based on current key
            if player.jumpCount ~= 0 || currKey == 1
                player.jumpUpdater();
            elseif currKey == -1
                player.duck();
            else
                player.walkUpdater();
            end
            
            % update components
            player.update();
            ground.update();
            pipe.update();
            
            % determine whether player has collided with pipe
            relevantPlayerY = player.y(player.x == pipe.x);
            if ~isempty(intersect(relevantPlayerY, pipe.y))
                gameOver = true;
            end
            
            % determine whether player has touched lava
            bottomPlayerX = player.x(player.y == 13);
            lavaX = find(ground.vals == -1);
            if ~isempty(intersect(bottomPlayerX, lavaX))
                gameOver = true;
            end
            
            % incrementally speed up the game
            timeDelta = t - 0.001*toc(startTime);
            if timeDelta < 0.02
                timeDelta = 0.02;
            end
            imshow(img);
            pause(timeDelta);
            
            % change score text
            score = score + 1;
            set(scoreText, 'String', ['Score: ', num2str(score)]);
        end
    end
    
    % perform game over routine
    set(gameOverText, 'visible', 'on');
    set(beginText, 'visible', 'on');
    pause(2);
    gameOver = false;
    gameStarted = false;
    autoplay = false;
end
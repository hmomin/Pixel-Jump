function playTraining()
    %PLAYTRAINING trains a NEAT AI to play Pixel Jump on pressing the 'Begin Training'
    %button.
    
    ERROR_POWER = 2;
    DESIRED_FITNESS = 10000^ERROR_POWER;
    TRAINING_ITERATIONS = 1000;
    NUM_INDIVIDUALS = 150;
    
    global ground img pipe scoreText genText;
    
    set(genText, 'visible', 'on');
    populationScores = zeros(TRAINING_ITERATIONS, 1);
    tracker = InnovationTracker();
    pop = Population(20, 3, NUM_INDIVIDUALS, tracker);
    
    for k = 1: TRAINING_ITERATIONS
        set(genText, 'String', ['Generation: ', num2str(k)]);
        fitness = 0;
        % initialize training elements
        speciesMap = pop.speciesMap;
        genomes = speciesMap.values;
        
        % initialize game elements and networks
        initializeGame();
        players = [];
        alive = [];
        nets = [];
        fitnesses = [];
        for p = 1: length(genomes)
            genomeSubset = genomes{p};
            len = length(genomeSubset);
            fitnesses = [fitnesses; -1*ones(len, 1)];
            alive = [alive; true(len, 1)];
            for m = 1: len
                players = [players; Player()];
                nets = [nets; Network(genomeSubset(m))];
            end
        end
        ground = Ground();
        pipe = Pipe();
        t = 0.2;

        startTime = tic;
        
        % update the game on each frame increment
        while any(alive)
            % check if figure exists
            g = groot;
            if isempty(g.Children)
                return;
            end
            
            % get inputs before clearing display
            inputs = getInputs();
            img(:, :, :) = 0;

            % adjust each player behavior based on network output
            for p = 1: length(players)
                player = players(p);
                if alive(p)
                    output = nets(p).feedForward(inputs);
                    [~, idx] = max(output);
                    % idx mapping: 1 -> jump, 2 -> walk, 3 -> duck
                    if player.jumpCount ~= 0 || idx == 1
                        player.jumpUpdater();
                    elseif idx == 2
                        player.walkUpdater()
                    elseif idx == 3
                        player.duck();
                    else
                        error(['idx = ', num2str(idx)]);
                    end
                    player.update();
                end
            end

            % update components
            ground.update();
            pipe.update();

            for p = 1: length(players)
                player = players(p);
                if alive(p)
                    % determine whether each player has collided with pipe
                    relevantPlayerY = player.y(player.x == pipe.x);
                    if ~isempty(intersect(relevantPlayerY, pipe.y))
                        alive(p) = false;
                        fitnesses(p) = fitness^ERROR_POWER;
                    end

                    % determine whether each player has touched lava
                    bottomPlayerX = player.x(player.y == 13);
                    lavaX = find(ground.vals == -1);
                    if ~isempty(intersect(bottomPlayerX, lavaX))
                        alive(p) = false;
                        fitnesses(p) = fitness^ERROR_POWER;
                    end
                end
            end

            % incrementally speed up the game
            timeDelta = t - 0.001*toc(startTime);
            if timeDelta < 0
                timeDelta = 0.02;
            end
            % COMMENT OUT the pause() and imshow() below if you don't care about being
            % able to see the training take place.
            imshow(img);
            pause(timeDelta);

            % change score text
            fitness = fitness + 1;
            set(scoreText, 'String', ['Score: ', num2str(fitness)]);
        end
        
        % set fitnesses of all genomes
        counter = 1;
        for p = 1: length(genomes)
            genomeSubset = genomes{p};
            for m = 1: length(genomeSubset)
                genomeSubset(m).setFitness(fitnesses(counter));
                counter = counter + 1;
            end
        end
        
        % create next generation
        pop.explicitFitnessSharing();
        pop.reproduce(tracker);
        scores = sqrt(fitnesses);
        meanScore = mean(scores);
        numSpecies = length(genomes);
        generation = k;
        [maxScore, idx] = max(scores);
        populationScores(k) = meanScore;
        fprintf('generation %g - time taken: %.2fs - num species: %g - mean score: %.2f - max score: %g\n', ...
            generation, toc(startTime), numSpecies, meanScore, maxScore);
        
        % save stats for this generation
        bestNet = nets(idx);
        if ~exist('pretrained_nets', 'dir')
            mkdir('pretrained_nets');
        end
        save(['pretrained_nets/pretrained_gen_', num2str(k), '.mat'], ...
            'bestNet', 'generation', 'maxScore', 'meanScore', 'numSpecies');
        save('pretrained.mat', 'bestNet');
        
        % check if any fitnesses are up to the desired fitness
        if any(fitnesses > DESIRED_FITNESS)
            break;
        end
    end
    
    figure(2);
    hold on;
    plot(populationScores(populationScores > 0));
    xlabel('generation number');
    ylabel('mean fitness');
    set(gca, 'FontSize', 18);
    hold off;
end
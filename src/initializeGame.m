function initializeGame()
    %INITIALIZEGAME initializes the Pixel Jump game.
    
    global beginText gameOverText gameStarted img;
    gameStarted = true;
    
    % wipe the image and start with a clean slate
    img = uint8(zeros(14, 36, 3));
    set(beginText, 'visible', 'off');
    set(gameOverText, 'visible', 'off');
    imshow(img);
end
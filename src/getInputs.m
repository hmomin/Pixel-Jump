function inputs = getInputs()
    %GETINPUTS retrieves the inputs for a neural network trained by NEAT-MATLAB.
    %   The inputs are in the form of a 20 x 1 column vector and contain compressed image
    %   data from the scene on screen.
    global img;
    spot = double(img(1: 14, 6: 15, 1))/255;
    reducedSpot = zeros(2, 10);
    for p = 1: 7: 14
        for m = 1: size(spot, 2)
            reducedSpot(ceil(p/7), m) = sum(spot(p: p + 6, m));
        end
    end
    inputs = reshape(reducedSpot, 20, 1);
end
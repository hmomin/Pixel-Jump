# Pixel Jump

Pixel Jump is a pixel-based game written in MATLAB that can integrate with NEAT-MATLAB to allow neural network evolution in favor of stronger players.

## Installation

In order to run it, you will need a recent (ideally 2018+) version of MATLAB. Using a command prompt, navigate into your MATLAB directory and perform the following two commands to download the pixel-jump and NEAT-MATLAB source code:
```
git clone https://github.com/hmomin/pixel-jump
git clone https://github.com/hmomin/NEAT-MATLAB
```
From there, open MATLAB and navigate to the place where you downloaded these libraries and add them to the MATLAB path, including all subfolders. Now, all you have to do is enter `pixel_jump` in the Command Window and you should see the GUI below pop up:

<p align="center">
  <img src="https://dr3ngl797z54v.cloudfront.net/pixel_jump_gui.PNG" width="100%" alt="Pixel Jump GUI">
</p>

## Gameplay

You can start playing Pixel Jump just by pressing any key. Hold up to jump and down to duck.

<p align="center">
  <img src="https://dr3ngl797z54v.cloudfront.net/pixel_jump_play.gif" width="100%" alt="Play Pixel Jump">
</p>

Alternatively, you can hit the 'Begin Training' button to train neural networks to play the game effectively via the NEAT algorithm.

<p align="center">
  <img src="https://dr3ngl797z54v.cloudfront.net/pixel_jump_train.gif" width="100%" alt="Train Pixel Jump">
</p>

Finally, the 'Autoplay' button allows you to play a trained neural network from the latest generation.

<p align="center">
  <img src="https://dr3ngl797z54v.cloudfront.net/pixel_jump_autoplay.gif" width="100%" alt="Autoplay Pixel Jump">
</p>

## License

All files in the repository are under the MIT license.
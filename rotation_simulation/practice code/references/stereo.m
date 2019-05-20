% Clear the workspace
sca;
clearvars;
close all;


%--------------------------------------------------------------------------
%                      Set up the screen
%--------------------------------------------------------------------------

% Set the stereomode 6 for red-green anaglyph presentation. You will need
% to view the image with the red filter over the left eye and the green
% filter over the right eye.
stereoMode = 6;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Skip sync tests for this demo in case people are using a defective
% system. This is for demo purposes only.
Screen('Preference', 'SkipSyncTests', 2);

% Setup Psychtoolbox for OpenGL 3D rendering support and initialize the
% mogl OpenGL for Matlab wrapper
InitializeMatlabOpenGL;

% Get the screen number
screenid = max(Screen('Screens'));

% Open the main window
[window, windowRect] = PsychImaging('OpenWindow', screenid, 0,...
    [], 32, 2, stereoMode);

% Show cleared start screen:
Screen('Flip', window);

% Screen size pixels
[screenXpix, screenYpix] = Screen('WindowSize', window);

% Set up alpha-blending for smooth (anti-aliased) edges to our dots
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

%--------------------------------------------------------------------------
%                      Set up the screen
%--------------------------------------------------------------------------

% Set the size of the square to be a fraction of the screen size. This will
% give us similar results on any demo system hopefully
squareDimPix = screenXpix / 5;

% For ease will will position dots +/- half of this size i.e. centered
% around zero. When we draw to the screen we center the dots automatically.
squareHalfDimPix = squareDimPix / 2;

% Number of dots
numDots = 500;

% Dot base position in pixels for the left and right eye. As you will see
% the vertical do positions will be the same in both cases.
dotPosXleft = (rand(1, numDots) .* 2 - 1) .* squareHalfDimPix;
dotPosYleft = (rand(1, numDots) .* 2 - 1) .* squareHalfDimPix;
dotPosXright = dotPosXleft;
dotPosYright = dotPosYleft;

% To shift the square in depth we need to shift the square by equal and
% opposite amounts in the left and right eyes. To make the square appear
% in front of the screen we need to shift the left eyes image to the right
% and the right eyes image to the left
shifterPix = 10;
dotPosXleft = dotPosXleft + shifterPix;
dotPosXright = dotPosXright - shifterPix;

% Dot diameter in pixels
dotDiaPix = 6;


%------------------------
% Drawing to the screen
%------------------------

% When drawing in stereo we have to select which eyes buffer we are going
% to draw in. These are labelled 0 for left and 1 for right. Note also, if
% you wear your anaglyph glasses the opposite way around the depth will
% reverse.

% Select left-eye image buffer for drawing (buffer = 0)
Screen('SelectStereoDrawBuffer', window, 0);

% Now draw our left eyes dots
Screen('DrawDots', window, [dotPosXleft; dotPosYleft], dotDiaPix,...
    [], [screenXpix / 2 screenYpix / 2], 2);

% Select right-eye image buffer for drawing (buffer = 1)
Screen('SelectStereoDrawBuffer', window, 1);

% Now draw our right eyes dots
Screen('DrawDots', window, [dotPosXright; dotPosYright], dotDiaPix,...
    [], [screenXpix / 2 screenYpix / 2], 2);

% Flip to the screen
Screen('Flip', window);

% Wait for a button press to exit the demo
KbWait;
sca;
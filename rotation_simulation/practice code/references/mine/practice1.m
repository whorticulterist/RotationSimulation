%clear work space
sca;
clearvars;
close all;

%~~~~~~~~~~~~~~~~
% set up screen
%~~~~~~~~~~~~~~~~

% Set the stereomode 6 for red-green anaglyph presentation. You will need
% to view the image with the red filter over the left eye and the green
% filter over the right eye.
%stereoMode = 4;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Skip sync tests for this demo in case people are using a defective
% system. This is for demo purposes only.
Screen('Preference', 'SkipSyncTests', 2);

% Setup Psychtoolbox for OpenGL 3D rendering support and initialize the
% mogl OpenGL for Matlab wrapper
InitializeMatlabOpenGL;

% find screen for display
screenid = max(Screen('Screens'));


% Initialise OpenGL
InitializeMatlabOpenGL;

% Open the main window with multi-sampling for anti-aliasing
[window, windowRect] = PsychImaging('OpenWindow', screenid, 0, [], 32, 2);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% start the openGL context(for issueing commands)
Screen('BeginOpenGl',window);

% set aspect ratio
ar = windowRect(3)/windowRect(4);
screenHeight = 30;
screenWidth = screenHeight * ar;

% enable lighting
glEnable(GL.LIGHTING);

% define a local lightsource
glEnable(GL.LIGHT0);

% enable occulusion handling
glEnable(GL.DEPTH_TEST);

% define projection matrix (3d space to monitor)
glMatrixMode(GL.PROJECTION);
glLoadIdentity;

% assuming distance to object is 100 cm
% define the field of view in y dimension
dist = 100;
angle = 2 * atand(screenHeight / dist);


% defined by the FOV(field of view), set up the perspective
% PROJECTION, the aspect ratio of our frustum and
% two clipping planes. these degine the min and max distances
% allowed here .1cm and 200cm
gluPerspective(angle, ar, 0.1, 200);

% setup modelview matrix, which defines the postion, orientation
% and direction of virtual camera
glMatrixMode(GL.MODELVIEW);
glLoadIdentity;

% fix the position of lightsource
glLightfv(GL.LIGHT0, GL.POSITION, [1 2 3 0]);

% fix position of camera
cam = [0 0 0];

% fix direction of camera
dir = [0 0 -100];

% define up
up = [0 1 0];

% implement defined camera parameters
glueLookAt(cam(1), cam(2), cam(3), dir(1), dir(2), dir(3), up(1), up(2), up(3));

% set background color to black
glClearColor(0,0,0,0);

% clear out the backbuffer
glClear;

% change the light reflection properties to make the material a color
glMaterialfv(GL.FRONT_AND_BACK,GL.AMBIENT, [1.0 0.0 0.0 1]);
glMaterialfv(GL.FRONT_AND_BACK,GL.DIFFUSE, [0.0 0.0 1.0 1]);

% end the openGL context
Screen('EndOpenGl', window);

%~~~~~~~~~~~~~~~~
% set up screen
%~~~~~~~~~~~~~~~~

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%~~~~~~~~~~~~~~~~
% load obj files
%~~~~~~~~~~~~~~~~

%~~~~~~~~~~~~~~~~
% load obj files
%~~~~~~~~~~~~~~~~

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%~~~~~~~~~~~~~~~~
% draw to screen
%~~~~~~~~~~~~~~~~

%~~~~~~~~~~~~~~~~
% draw to screen
%~~~~~~~~~~~~~~~~

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%~~~~~~~~~~~~~~~~
% practice
%~~~~~~~~~~~~~~~~

% Setup the positions of the spheres using the mexhgrid command
[cubeX, cubeY] = meshgrid(linspace(-25, 25, 10), linspace(-20, 20, 8));
[s1, s2] = size(cubeX);
cubeX = reshape(cubeX, 1, s1 * s2);
cubeY = reshape(cubeY, 1, s1 * s2);

% Define the intial rotation angles of our cubes
rotaX = rand(1, length(cubeX)) .* 360;
rotaY = rand(1, length(cubeX)) .* 360;
rotaZ = rand(1, length(cubeX)) .* 360;

% Now we define how many degrees our cubes will rotated per second and per
% frame. Note we use Degrees here (not Radians)
degPerSec = 180;
degPerFrame = degPerSec * ifi;

% Get a time stamp with a flip
vbl = Screen('Flip', window);

% Set the frames to wait to one
waitframes = 1;

while ~KbCheck

    % Begin the OpenGL context now we want to issue OpenGL commands again
    Screen('BeginOpenGL', window);

    % To start with we clear everything
    glClear;

    % Draw all the cubes
    for i = 1:1:length(cubeX)

        % Push the matrix stack
        glPushMatrix;

        % Translate the cube in xyz
        glTranslatef(cubeX(i), cubeY(i), -dist);

        % Rotate the cube randomly in xyz
        glRotatef(rotaX(i), 1, 0, 0);
        glRotatef(rotaY(i), 0, 1, 0);
        glRotatef(rotaZ(i), 0, 0, 1);

        % Draw the solid cube
        glutSolidCube(3);

        % Pop the matrix stack for the next cube
        glPopMatrix;

    end

    % End the OpenGL context now that we have finished doing OpenGL stuff.
    % This hands back control to PTB
    Screen('EndOpenGL', window);

    % Show rendered image at next vertical retrace
    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

    % Rotate the cubes for the next drawing loop
    rotaX = rotaX + degPerFrame;
    rotaY = rotaY + degPerFrame;
    rotaZ = rotaZ + degPerFrame;

end

% Shut the screen down
sca;




%~~~~~~~~~~~~~~~~
% practice
%~~~~~~~~~~~~~~~~

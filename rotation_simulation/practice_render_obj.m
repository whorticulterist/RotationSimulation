function practice_render_obj()

% Clear the workspace
close all;
clearvars;
sca;


% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Skip sync tests for this demo in case people are using a defective
% system. This is for demo purposes only.
Screen('Preference', 'SkipSyncTests', 2);

% Find the screen to use for display
screenid = max(Screen('Screens'));

% Initialise OpenGL
InitializeMatlabOpenGL;

% Open the main window with multi-sampling for anti-aliasing
[window, windowRect] = PsychImaging('OpenWindow', screenid, 0, [], 32, 2);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Start the OpenGL context (you have to do this before you issue OpenGL
% commands such as we are using here)
Screen('BeginOpenGL', window);

% For this demo we will assume our screen is 30cm in height. The units are
% essentially arbitary with OpenGL as it is all about ratios. But it is
% nice to define things in normal scale numbers
ar = windowRect(3) / windowRect(4);
screenHeight = 30;
screenWidth = screenHeight * ar;

% Enable lighting
glEnable(GL.LIGHTING);

% Define a local light source
glEnable(GL.LIGHT0);

% Enable proper occlusion handling via depth tests
glEnable(GL.DEPTH_TEST);

% Lets set up a projection matrix, the projection matrix defines how images
% in our 3D simulated scene are projected to the images on our 2D monitor
glMatrixMode(GL.PROJECTION);
glLoadIdentity;

% Calculate the field of view in the y direction assuming a distance to the
% objects of 100cm
dist = 100;
angle = 2 * atand(screenHeight / dist);

% Set up our perspective projection. This is defined by our field of view
% (here given by the variable "angle") and the aspect ratio of our frustum
% (our screen) and two clipping planes. These define the minimum and
% maximum distances allowable here 0.1cm and 200cm.
gluPerspective(angle, ar, 0.1, 200);

% Setup modelview matrix: This defines the position, orientation and
% looking direction of the virtual camera that will be look at our scene.
glMatrixMode(GL.MODELVIEW);
glLoadIdentity;

% Our point lightsource is at position (x,y,z) == (1,2,3)
glLightfv(GL.LIGHT0, GL.POSITION, [1 2 3 0]);

% Location of the camera is at the origin
cam = [0 0 0];

% Set our camera to be looking directly down the Z axis (depth) of our
% coordinate system
fix = [0 0 -100];

% Define "up"
up = [0 1 0];

% Here we set up the attributes of our camera using the variables we have
% defined in the last three lines of code
gluLookAt(cam(1), cam(2), cam(3), fix(1), fix(2), fix(3), up(1), up(2), up(3));

% Set background color to 'black' (the 'clear' color)
glClearColor(0, 0, 0, 0);

% Clear out the backbuffer
glClear;

% Define the light reflection properties by setting up reflection
% coefficients for ambient, diffuse and specular reflection:
glMaterialfv(GL.FRONT_AND_BACK,GL.AMBIENT, [ 0.5 0.5 0.5 1 ]);
glMaterialfv(GL.FRONT_AND_BACK,GL.DIFFUSE, [ .7 .7 .7 1 ]);
glMaterialfv(GL.FRONT_AND_BACK,GL.SPECULAR, [ 0.2 0.2 0.2 1 ]);
glMaterialfv(GL.FRONT_AND_BACK,GL.SHININESS,12);

% Make sure that surface normals are always normalized to unit-length,
% regardless what happens to them during morphing. This is important for
% correct lighting calculations:
glEnable(GL.NORMALIZE);

% End the OpenGL context now that we have finished setting things up
Screen('EndOpenGL', window);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% load obj
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

object = LoadOBJFile('thing.obj');

meshid = moglmorpher('addMesh', object{1});

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% load obj
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Initialize amount and direction of rotation
theta=0;
rotatev=[ 0 0 1 ];


% Initialize morph vector:
w=[ 0 1 ];

% Setup initial z-distance of objects:
zz = 20.0;

ang = 0.0;      % Initial rotation angle

% Half eye separation in length units for quick & dirty stereoscopic
% rendering. Our way of stereo is not correct, but it makes for a
% nice demo. Figuring out proper values is not too difficult, but
% left as an exercise to the reader.
eye_halfdist=3;

% Compute initial morphed shape for next frame, based on initial weights:
moglmorpher('computeMorph', w, morphnormals);

% Block keyboard input from spilling into Console:
ListenChar(2);

% Initially sync us to the VBL:
vbl=Screen('Flip', win);

% Some stats...
tstart=vbl;
framecount = 0;
waitframes = 1;

% Animation loop: Run until key press or one minute has elapsed...
t = GetSecs;
while ((GetSecs - t) < 60)
    % Switch to OpenGL rendering for drawing of next frame:
    Screen('BeginOpenGL', win);

    glMatrixMode(GL.PROJECTION);
    glLoadMatrixd(projMatrix{1});
    glMatrixMode(GL.MODELVIEW);
    glLoadMatrixd(state.modelView{1});

    % Draw into image buffer for left eye:
    Screen('EndOpenGL', win);
    Screen('SelectStereoDrawBuffer', win, 0);
    Screen('BeginOpenGL', win);

    % Clear out the depth-buffer for proper occlusion handling:
    glClear(GL.DEPTH_BUFFER_BIT);

    % Call our subfunction that does the actual drawing of the shape (see below):
    drawShape(ang, theta, rotatev, dotson, normalson);

    % Finish OpenGL rendering into Psychtoolbox - window and check for OpenGL errors.
    Screen('EndOpenGL', win);

    % Tell Psychtoolbox that drawing of this stim is finished, so it can optimize
    % drawing:
    Screen('DrawingFinished', win);

    % Now that all drawing commands are submitted, we can do the other stuff before
    % the Flip:

    % Calculate rotation angle of object for next frame:
    theta=mod(theta+0.1, 360);
    rotatev=rotatev+0.0001*[ sin((pi/180)*theta) sin((pi/180)*2*theta) sin((pi/180)*theta/5) ];
    rotatev=rotatev/sqrt(sum(rotatev.^2));

    % Compute simple morph weight vector for next frame:
    w(1)=(sin(framecount / 100 * 3.1415 * 2) + 1)/2;
    w(2)=1-w(1);

    % Compute morphed shape for next frame, based on new weight vector:
    moglmorpher('computeMorph', w, morphnormals);

    if 0
        % Test morphed geometry readback:
        mverts = moglmorpher('getGeometry');
        scatter3(mverts(1,:), mverts(2,:), mverts(3,:));
        drawnow;
    end

    % Check for keyboard press:
    [KeyIsDown, endrt, KeyCode] = KbCheck;
    if KeyIsDown
        if ( KeyIsDown==1 && KeyCode(closer)==1 )
            zz=zz-0.1;
            KeyIsDown=0;
        end

        if ( KeyIsDown==1 && KeyCode(farther)==1 )
            zz=zz+0.1;
            KeyIsDown=0;
        end

        if ( KeyIsDown==1 && KeyCode(rotateright)==1 )
            ang=ang+1.0;
            KeyIsDown=0;
        end

        if ( KeyIsDown==1 && KeyCode(rotateleft)==1 )
            ang=ang-1.0;
            KeyIsDown=0;
        end

        if ( KeyIsDown==1 && KeyCode(quitkey)==1 )
            break;
        end
    end

    % Update frame animation counter:
    framecount = framecount + 1;

    % We're done for this frame:

    % Show rendered image 'waitframes' refreshes after the last time
    % the display was updated and in sync with vertical retrace:
    vbl = Screen('Flip', win, vbl + (waitframes - 0.5) * ifi);
    %Screen('Flip', win, 0, 0, 2);
end

vbl = Screen('Flip', win);

% Calculate and display average framerate:
fps = framecount / (vbl - tstart) %#ok<NOPRT,NASGU>

% Reset moglmorpher:
moglmorpher('reset');

% Close onscreen window and release all other ressources:
sca;

% Enable regular keyboard again:
ListenChar(0);

% Reenable Synctests after this simple demo:
Screen('Preference','SkipSyncTests', oldskip);

% Well done!
return

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`
% drawShape does the actual drawing:
function drawShape(ang, theta, rotatev, dotson, normalson)
% GL needs to be defined as "global" in each subfunction that
% executes OpenGL commands:
global GL
global win

% Backup modelview matrix:
glPushMatrix;

% Setup rotation around axis:
glRotatef(theta,rotatev(1),rotatev(2),rotatev(3));
glRotatef(ang,0,1,0);

% Scale object by a factor of a:
a=0.1;
glScalef(a,a,a);

glColor4f(0.8,0.8,0.8,1.0);

% Render current morphed shape via moglmorpher:
moglmorpher('render');

% Some extra visualizsation code for normals, mesh and vertices:
if (dotson == 1 || dotson == 3)
    % Draw some dot-markers at positions of vertices:
    % We disable lighting for this purpose:
    glDisable(GL.LIGHTING);
    % From all polygons, only their defining vertices are drawn:
    glPolygonMode(GL.FRONT_AND_BACK, GL.POINT);
    glColor4f(0,0,1,1);

    % Ask morpher to rerender the last shape:
    moglmorpher('render');

    % Reset settings for shape rendering:
    glPolygonMode(GL.FRONT_AND_BACK, GL.FILL);
    glEnable(GL.LIGHTING);
end;

if (dotson == 2)
    % Draw connecting lines to visualize the underlying geometry:
    % We disable lighting for this purpose:
    glDisable(GL.LIGHTING);
    % From all polygons, only their connecting outlines are drawn:
    glColor4f(0,0,1,1);
    glPolygonMode(GL.FRONT_AND_BACK, GL.LINE);

    % Ask morpher to rerender the last shape:
    moglmorpher('render');

    % Reset settings for shape rendering:
    glPolygonMode(GL.FRONT_AND_BACK, GL.FILL);
    glEnable(GL.LIGHTING);
end;

if (normalson > 0)
    % Draw surface normal vectors on top of object:
    glDisable(GL.LIGHTING);
    % Green is a nice color for this:
    glColor4f(0,1,0,1);

    % Ask morpher to render the normal vectors of last shape:
    moglmorpher('renderNormals', normalson);

    % Reset settings for shape rendering:
    glEnable(GL.LIGHTING);
    glColor4f(0,0,1,1);
end;

if (dotson == 3 || dotson == 4)
   % Compute and retrieve projected screen-space vertex positions:
   vpos = moglmorpher('getVertexPositions', win);

   % Plot the projected 2D points into a Matlab figure window:
   vpos(:,2)=RectHeight(Screen('Rect', win)) - vpos(:,2);
   plot(vpos(:,1), vpos(:,2), '.');
   drawnow;
end;



% Restore modelview matrix:
glPopMatrix;

% Done, return to main-function:
return;

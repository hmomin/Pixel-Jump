function varargout = pixel_jump(varargin)
    % PIXEL_JUMP MATLAB code for pixel_jump.fig
    %      PIXEL_JUMP, by itself, creates a new PIXEL_JUMP or raises the existing
    %      singleton*.
    %
    %      H = PIXEL_JUMP returns the handle to a new PIXEL_JUMP or the handle to
    %      the existing singleton*.
    %
    %      PIXEL_JUMP('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in PIXEL_JUMP.M with the given input arguments.
    %
    %      PIXEL_JUMP('Property','Value',...) creates a new PIXEL_JUMP or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before pixel_jump_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to pixel_jump_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES
    
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
        'gui_Singleton',  gui_Singleton, ...
        'gui_OpeningFcn', @pixel_jump_OpeningFcn, ...
        'gui_OutputFcn',  @pixel_jump_OutputFcn, ...
        'gui_LayoutFcn',  [] , ...
        'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end
    
    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
    % End initialization code - DO NOT EDIT
end

% --- Executes just before pixel_jump is made visible.
function pixel_jump_OpeningFcn(hObject, ~, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to pixel_jump (see VARARGIN)
    
    % Choose default command line output for pixel_jump
    handles.output = hObject;
    
    % Update handles structure
    guidata(hObject, handles);
    
    % UIWAIT makes pixel_jump wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = pixel_jump_OutputFcn(~, ~, handles)
    % varargout  cell array for returning output args (see VARARGOUT);
    % handles    structure with handles and user data (see GUIDATA)
    
    % Get default command line output from handles structure
    varargout{1} = handles.output;
    
    global beginText scoreText genText gameOverText gameOver gameStarted img currKey train autoplay;
    beginText = handles.beginText;
    scoreText = handles.scoreText;
    gameOverText = handles.gameOverText;
    genText = handles.genText;
    gameOver = false;
    gameStarted = false;
    img = uint8(zeros(14, 36, 3));
    currKey = 0;
    train = false;
    autoplay = false;
    
    set(gameOverText, 'visible', 'off');
    set(genText, 'visible', 'off');
    
    % show the title image
    titleImg = imread('pixelJumpTitle.png');
    img(titleImg > 0) = 255;
    imshow(img);
    
end

% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
    % hObject    handle to figure1 (see GCBO)
    % eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
    %	Key: name of the key that was pressed, in lower case
    %	Character: character interpretation of the key(s) that was pressed
    %	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
    % handles    structure with handles and user data (see GUIDATA)
    global gameStarted currKey train autoplay;
    if ~train && ~autoplay
        if ~gameStarted
            initializeGame();
            playGame();
        else
            currKey = evaluateKey(eventdata.Key);
        end
    end
end

function res = evaluateKey(key)
    if strcmp(key, 'uparrow')...
            || strcmp(key, 'w')...
            || strcmp(key, 'space')...
            || strcmp(key, 'return')
        res = 1;
    elseif strcmp(key, 'downarrow')...
            || strcmp(key, 's')...
            || strcmp(key, 'backspace')...
            || strcmp(key, 'delete')
        res = -1;
    else
        res = 0;
    end
end

% --- Executes on key release with focus on figure1 and none of its controls.
function figure1_KeyReleaseFcn(hObject, eventdata, handles)
    % hObject    handle to figure1 (see GCBO)
    % eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
    %	Key: name of the key that was released, in lower case
    %	Character: character interpretation of the key(s) that was released
    %	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
    % handles    structure with handles and user data (see GUIDATA)
    global currKey train autoplay;
    % walk by default
    if ~train && ~autoplay
        currKey = 0;
    end
end

% --- Executes on button press in train.
function train_Callback(hObject, eventdata, handles)
    % hObject    handle to train (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    global train autoplay;
    
    if ~train && ~autoplay
        train = true;
        initializeGame();
        playTraining();
    end
end

% --- Executes on button press in autoplay.
function autoplay_Callback(hObject, eventdata, handles)
    % hObject    handle to autoplay (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    global autoplay;
    
    if ~autoplay
        % check if pretrained file exists
        if isfile('pretrained.mat')
            autoplay = true;
            initializeGame();
            playGame();
        else
            fprintf("AUTOPLAY ERROR: file 'pretrained.mat' does not exist.\nPlease train first using the 'Begin Training' button.\n");
        end
    end
end

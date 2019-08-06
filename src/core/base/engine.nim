import times, os, ../config, ./window, ./game
import opengl/glut
import opengl
import opengl/glu

const SECOND = 1000000000

type
  MyTime* = object
    d: int
 
  CoreEngine* = ref object of RootObj
    config*: Configuration
    IsRunning*: bool
    IsPaused*: bool
    time*:  MyTime
    game*: Game
  #game Game

proc `delta=`*(t: var MyTime, value: int) {.inline.} =
  t.d = value

proc delta*(t: MyTime): int {.inline.} =
  t.d




proc Stop*(e:CoreEngine): void {.inline} =
  echo "Stopping Game Engine"
  e.IsRunning = false



proc display() {.cdecl.} =
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT) # Clear color and depth buffers
  glMatrixMode(GL_MODELVIEW)                          # To operate on model-view matrix
  glLoadIdentity()                 # Reset the model-view matrix
  glTranslatef(1.5, 0.0, -7.0)     # Move right and into the screen

  # Render a cube consisting of 6 quads
  # Each quad consists of 2 triangles
  # Each triangle consists of 3 vertices

  glBegin(GL_TRIANGLES)        # Begin drawing of triangles

  # Top face (y = 1.0f)
  glColor3f(0.0, 1.0, 0.0)     # Green
  glVertex3f( 1.0, 1.0, -1.0)
  glVertex3f(-1.0, 1.0, -1.0)
  glVertex3f(-1.0, 1.0,  1.0)
  glVertex3f( 1.0, 1.0,  1.0)
  glVertex3f( 1.0, 1.0, -1.0)
  glVertex3f(-1.0, 1.0,  1.0)

  # Bottom face (y = -1.0f)
  glColor3f(1.0, 0.5, 0.0)     # Orange
  glVertex3f( 1.0, -1.0,  1.0)
  glVertex3f(-1.0, -1.0,  1.0)
  glVertex3f(-1.0, -1.0, -1.0)
  glVertex3f( 1.0, -1.0, -1.0)
  glVertex3f( 1.0, -1.0,  1.0)
  glVertex3f(-1.0, -1.0, -1.0)

  # Front face  (z = 1.0f)
  glColor3f(1.0, 0.0, 0.0)     # Red
  glVertex3f( 1.0,  1.0, 1.0)
  glVertex3f(-1.0,  1.0, 1.0)
  glVertex3f(-1.0, -1.0, 1.0)
  glVertex3f( 1.0, -1.0, 1.0)
  glVertex3f( 1.0,  1.0, 1.0)
  glVertex3f(-1.0, -1.0, 1.0)

  # Back face (z = -1.0f)
  glColor3f(1.0, 1.0, 0.0)     # Yellow
  glVertex3f( 1.0, -1.0, -1.0)
  glVertex3f(-1.0, -1.0, -1.0)
  glVertex3f(-1.0,  1.0, -1.0)
  glVertex3f( 1.0,  1.0, -1.0)
  glVertex3f( 1.0, -1.0, -1.0)
  glVertex3f(-1.0,  1.0, -1.0)

  # Left face (x = -1.0f)
  glColor3f(0.0, 0.0, 1.0)     # Blue
  glVertex3f(-1.0,  1.0,  1.0)
  glVertex3f(-1.0,  1.0, -1.0)
  glVertex3f(-1.0, -1.0, -1.0)
  glVertex3f(-1.0, -1.0,  1.0)
  glVertex3f(-1.0,  1.0,  1.0)
  glVertex3f(-1.0, -1.0, -1.0)

  # Right face (x = 1.0f)
  glColor3f(1.0, 0.0, 1.0)    # Magenta
  glVertex3f(1.0,  1.0, -1.0)
  glVertex3f(1.0,  1.0,  1.0)
  glVertex3f(1.0, -1.0,  1.0)
  glVertex3f(1.0, -1.0, -1.0)
  glVertex3f(1.0,  1.0, -1.0)
  glVertex3f(1.0, -1.0,  1.0)

  glEnd()  # End of drawing

  glutSwapBuffers() # Swap the front and back frame buffers (double buffering)

  
  

proc Unpause*(e:CoreEngine): void {.inline.} =
  if e.IsPaused != true :
    return 
  echo "Unpausing Game Engine"
  e.IsPaused = false

proc Pause*(e:CoreEngine): void {.inline.} =
  if e.IsPaused :
    return 
  echo "Pausing Game Engine"
  e.IsPaused = true

proc Start*(e:CoreEngine):void {.inline.} = 
  glClearColor(0.0, 0.0, 0.0, 1.0)                   # Set background color to black and opaque
  glClearDepth(1.0)                                 # Set background depth to farthest
  e.IsRunning = true
  echo "Starting Game Engine"
  glutMainLoop()

var engine: CoreEngine

var frames = 0
var frameCounter = float(0)
var lastTime = cpuTime()
var unprocessedTime  =float(0)
var render = false;
var passedTime =  float(0)

proc displayLoop() {.cdecl.}=
  let frameTime = 1/float(engine.config.FRAME_CAP)

  if engine.IsPaused != true:
    render = false
    let startTime = cpuTime()
    passedTime = float64(startTime) - float64(lastTime)
    lastTime = startTime

    unprocessedTime +=  float64(passedTime)
    frameCounter +=  passedTime
    if unprocessedTime > frameTime:
      render = true
      unprocessedTime -= frameTime
      
      # e.game.Input()
      # e.game.Update()
      sleep(10)
      glutPostRedisplay()
      engine.IsRunning = false
      frames = frames + 1

      if float(frameCounter) > 0.1:
          echo "FPS ",frames
          frames = 0;
          frameCounter = 0
      

proc CreateCoreEngine*(config : Configuration, game: Game) : CoreEngine =
  engine = CoreEngine(config:config, game:game,IsRunning:false, time: MyTime(d: 0))


  window.CreateWindow(config.WINDOW_WIDTH,config.WINDOW_HEIGHT,config.NAME)
  glutReshapeFunc(reshape)
  glutDisplayFunc(display)
  glutIdleFunc(displayLoop)

  loadExtensions()
  glEnable(GL_DEPTH_TEST)                           # Enable depth testing for z-culling
  glDepthFunc(GL_LEQUAL)                            # Set the type of depth-test
  glShadeModel(GL_SMOOTH)                           # Enable smooth shading
  glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST) # Nice perspective corrections


  return engine

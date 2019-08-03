import times, os, ../config, ./window, opengl/glut, opengl

const SECOND = 100000

type
  MyTime* = object
    d: int
 
  CoreEngine* = ref object of RootObj
    config*: Configuration
    IsRunning*: bool
    time*:  MyTime
  #game Game

proc `delta=`*(t: var MyTime, value: int) {.inline.} =
  t.d = value

proc delta*(t: MyTime): int {.inline.} =
  t.d




proc Stop*(e:CoreEngine): void {.inline} =
  echo "Stopping Game Engine"
  e.IsRunning = false

proc displayLoop(e: CoreEngine): void {.inline.} =
  e.IsRunning = true
  let frame = 0
  var frameCounter = 0

  let frameTime = 1/float(e.config.FRAME_CAP)
  var lastTime = cpuTime()
  var unprocessedTime  =float(0)
  echo lastTime

  echo "I AM RUNNING"
  while e.IsRunning:
    var render = false
    let startTime = cpuTime()
    var passedTime = float(startTime) - float(lastTime)
    lastTime = startTime

    unprocessedTime = float(unprocessedTime) + float(passedTime)/float(SECOND)
    frameCounter +=  int(passedTime)

    while unprocessedTime > frameTime:
      render = true
      unprocessedTime -= frameTime

proc Start*(e:CoreEngine): void {.inline.} =
  if e.IsRunning :
    return 
  echo "Starting Game Engine"
  e.IsRunning = true


proc Init*(e:CoreEngine):void {.inline.} = 
  glClearColor(0.0, 0.0, 0.0, 1.0)                   # Set background color to black and opaque
  glClearDepth(1.0)                                 # Set background depth to farthest
  glutMainLoop()


proc CreateCoreEngine*(config : Configuration) : CoreEngine =
  let engine = CoreEngine(config:config, IsRunning:false, time: MyTime(d: 0))


  window.CreateWindow(config.WINDOW_WIDTH,config.WINDOW_HEIGHT,config.NAME)
  return engine
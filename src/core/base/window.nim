import opengl/glut

proc CreateWindow*(width, height :int, title :string) : void =
  var argc: cint = 0
  glutInit(addr argc, nil)
  glutInitDisplayMode(GLUT_DOUBLE)
  glutInitWindowSize(width, height)
  glutInitWindowPosition(50, 50)
  discard glutCreateWindow(title)
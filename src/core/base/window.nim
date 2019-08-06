import opengl/glut
import opengl
import opengl/glu


proc CreateWindow*(width, height :int, title :string) : void =
  var argc: cint = 0
  glutInit(addr argc, nil)
  glutInitDisplayMode(GLUT_DOUBLE)
  glutInitWindowSize(width, height)
  glutInitWindowPosition(50, 50)
  glutSetWindow(glutCreateWindow(title))



proc reshape*(width: GLsizei, height: GLsizei) {.cdecl.} =
  # Compute aspect ratio of the new window
  if height == 0:
    return                # To prevent divide by 0

  # Set the viewport to cover the new window
  glViewport(0, 0, width, height)

  # Set the aspect ratio of the clipping volume to match the viewport
  glMatrixMode(GL_PROJECTION)  # To operate on the Projection matrix
  glLoadIdentity()             # Reset
  # Enable perspective projection with fovy, aspect, zNear and zFar
  gluPerspective(45.0, width / height, 0.1, 100.0)
  
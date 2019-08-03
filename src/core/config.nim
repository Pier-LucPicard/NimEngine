type 
  Shader* = object
    VERTEX*: string
    FRAGMENT*: string

  Configuration* = object 
    WINDOW_WIDTH*: int
    WINDOW_HEIGHT*: int
    NAME*: string
    SHADER*: Shader
    FRAME_CAP*: int

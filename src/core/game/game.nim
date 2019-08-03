import tables 

type
  Game* = ref object of RootObj
    Scenes*: Table[string, Scene]
    CurrentScene*: string
  
  Scene = ref object of RootObj
    Name*: string

proc CreateGame*(): Game = 
  # var  t = initTable[string,Scene]()

  var
    a = {"First": Scene(Name: "FirstScene")}.toTable 
  return Game(Scenes: a, CurrentScene: "First")
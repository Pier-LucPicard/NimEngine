import core/utils/fileUtils as fu
import core/base/engine
import core/base/game


proc main():void =
  # Start By loading the configuration of the game
  let config = fu.LoadConfig("src/config/dev.json")

  #Load the Game you want to play
  let loadedGame = CreateGame()
  echo loadedGame.CurrentScene

  #Create a Core Engine.  This Init all the component
  let coreEngine = CreateCoreEngine(config, loadedGame)
  
  #Start the game and give up control
  coreEngine.Start()


main()  

import strutils, strformat, json, ../config



proc LoadConfig*(filename :string) : Configuration =
  echo &"Loading config: {filename}"
  let splitArray = filename.split(".");

  if splitArray[high(splitArray)] != "json":
    raise newException(AssertionError, "Wrong File Extention! Expect an .json file")
  
  let configurationJson = parseJson(readFile(filename))
  let config = to(configurationJson, Configuration)
  return config;
 
proc LoadShader*(filename :string) :string =
  echo &"Loading shader: {filename}"
  let splitArray = filename.split(".");

  if splitArray[high(splitArray)] != "vert" or splitArray[high(splitArray)] != "frag":
    raise newException(AssertionError, "Wrong File Extention! Expect an .vert or .frag file")
  
  readFile(filename)


proc LoadMesh*(filename :string) :string =
  echo &"Loading mesh: {filename}"
  let splitArray = filename.split(".");

  if splitArray[high(splitArray)] != "obj":
    raise newException(AssertionError, "Wrong File Extention! Expect an .obj file")
  
  return readFile(filename)
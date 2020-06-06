import rbt
import osproc
import random
import logging


addHandler(newConsoleLogger(levelThreshold=lvlDebug))

proc main() =
  randomize()
  discard execCmd "clear"
  var t = initRBTree()

  for _ in .. 30:
    var d: string = ""
    for _ in .. 10:
      d.add(char(rand(int('a') .. int('z'))))
    t.insert(Data(d))

  echo "[result]"
  t.trace()


when isMainModule:
  main()
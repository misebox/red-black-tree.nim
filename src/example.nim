import rbt
import osproc
import random
import logging


addHandler(newConsoleLogger(lvlDebug))

proc main() =
  randomize()
  discard execCmd "clear"
  var t = initRBTree[string, string]()

  for _ in .. 10:
    var k: string = ""
    var d: string = ""
    for _ in 0 ..< 3:
      k.add(char(rand(int('A') .. int('Z'))))
    for _ in 0 ..< 10:
      d.add(char(rand(int('a') .. int('z'))))
    t.insert(k, d)

  echo "[result]"
  t.trace()


when isMainModule:
  main()
import rbt
import osproc
import random

proc main() =
  randomize()
  discard execCmd "clear"
  var t = initRBTree[int, string]()

  for _ in .. 10:
    let k = rand(100)
    var d: string = ""
    for _ in .. 10:
      d.add(char(rand(int('a') .. int('z'))))
    t.insert(k, d)

  echo "[result]"
  t.trace()


when isMainModule:
  main()
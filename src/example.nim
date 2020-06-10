import rbt
import osproc
import random
import logging
import strformat


addHandler(newConsoleLogger(lvlDebug))

proc main() =
  randomize()
  discard execCmd "clear"
  var t = initRBTree[string, string]()

  var keys = newSeq[string]()
  for _ in .. 30:
    var k: string = ""
    var v: string = ""
    for _ in 0 ..< 3:
      k.add(char(rand(int('A') .. int('Z'))))
    keys.add(k)
    for _ in 0 ..< 10:
      v.add(char(rand(int('a') .. int('z'))))
    t.insert(k, v)

  echo "[Inserted]"
  t.trace()
  echo "[Get]"
  for k in keys:
    echo k, t[k]
  echo "[Delete]"
  for k in keys:
    t.delete(k)
  echo "done"
  t.trace()

when isMainModule:
  main()
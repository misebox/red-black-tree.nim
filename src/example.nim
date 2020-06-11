import osproc
import random
import logging
import strformat

include rbt

addHandler(newConsoleLogger(lvlDebug))

proc main() =
  randomize()
  discard execCmd "clear"
  var t = initRBTree[string, string]()

  echo "[Insert]"
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

  echo "[Trace]"
  t.trace()
  echo "[Get]"
  for k in keys:
    echo k, t[k]
  echo "[Traverse]"
  for n in t.root.traverse:
    echo n
  echo "[Delete]"
  for k in keys:
    t.remove(k)
  echo "done"

  for n in t.root.traverse:
    echo n

when isMainModule:
  main()

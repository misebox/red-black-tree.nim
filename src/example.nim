import random
import logging
import strformat

import rbt

# addHandler(newConsoleLogger(lvlDebug))


type 
  GreatKey = object
    id: int
  Record = object
    name: string
    data: string
proc cmp(a: GreatKey, b: GreatKey): int = cmp(a.id, b.id)


proc main() =
  randomize()
  var t = initRBTree[string, string]()

  echo "[Insert]"
  var keys = newSeq[string]()
  for _ in .. 10:
    var k: string = ""
    var v: string = ""
    for _ in 0 ..< 3:
      k.add(char(rand(int('A') .. int('Z'))))
    keys.add(k)
    for _ in 0 ..< 5:
      v.add(char(rand(int('a') .. int('z'))))
    echo fmt"inserted ({k}: {v})"
    t.insert(k, v)
  echo fmt"count: {t.count}"

  echo ""
  echo "[Trace]"
  t.trace()
  echo "[Get]"
  for k in keys:
    echo fmt"{k}: {t[k]}"
  echo ""
  echo "[Traverse]"
  for k, v in t.traverse:
    echo (k, v)
  echo ""
  echo "[Delete]"
  for k in keys:
    t.remove(k)
  echo fmt"count: {t.count}"
  echo ""

  for n in t.traverse:
    echo n

  echo "[Use object as key or value]"
  let t2 = initRBTree[GreatKey, Record]()
  t2[GreatKey(id: 4)] = Record(name: "aa", data: "xx")
  t2[GreatKey(id: 4)] = Record(name: "bb", data: "yy")
  t2[GreatKey(id: 5)] = Record(name: "cc", data: "zz")
  for n in t2.traverse:
    echo n

when isMainModule:
  main()

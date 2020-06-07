import rbt
import unittest
import sequtils


test "Single insertion":
  let k = "hello"
  let v = "world"
  let t = initRBTree[string, string]()
  t.insert(k, v)
  assert(t["hello"] == some("world"))

test "Balance test 1":
  var lst = toSeq(0..<26).map(
    proc(x: int): (string, int) =
      ($(char(int('A') + x)), x)
  )
  var t = initRBTree[string, int]()
  for (k, v) in lst:
    t.insert(k, v)
  for (k, v) in lst:
    assert(t[k] == some(v))
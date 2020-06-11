import unittest
import rbt
import sequtils


suite "Public interface test":
  test "Single insertion":
    let k = "hello"
    let v = "world"
    var t = initRBTree[string, string]()
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

  test "Insertion looking up":
    var t = initRBTree[string, string]()
    t["A"] = "apple"
    t["B"] = "banana"
    t["C"] = "citlas"
    assert(t["A"] == some("apple"))
    assert(t["B"] == some("banana"))
    assert(t["C"] == some("citlas"))
    assert(t["D"].isNone)

  test "Insertion and taking":
    var t = initRBTree[string, string]()
    t["A"] = "apple"
    t["B"] = "banana"
    t["C"] = "citlas"
    assert(t.count == 3)
    assert(t.take("A") == some("apple"))
    assert(t.count == 2)
    assert(t.take("B") == some("banana"))
    assert(t.count == 1)
    assert(t.take("C") == some("citlas"))
    assert(t.count == 0)
    assert(t.take("D").isNone)

  test "Removal":
    var t = initRBTree[string, string]()
    t["A"] = "apple"
    t["B"] = "banana"
    assert(t.count == 2)
    t.remove("A")
    assert(t.count == 1)
    assert(t["B"] == some("banana"))
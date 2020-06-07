import unittest

# Include target module to test private property
include rbt

suite "Insertion Case 1":
  setup:
    let t = initRBTree[int, string]()
    t.insert(5, "ROOT")

  test "1.1":
    assert(t.root != nil)
    assert(t.root.key == 5)
    assert(t.root.value == "ROOT")

suite "Insertion Case 2":
  setup:
    let t = initRBTree[int, string]()
    t.insert(5, "ROOT")
    assert(t.root != nil)

  test "2.1":
    t.insert(3, "L")
    assert(t.root.left != nil)
    assert(t.root.left.key == 3)
    assert(t.root.left.value == "L")
  test "2.2":
    t.insert(7, "R")
    assert(t.root.right != nil)
    assert(t.root.right.key == 7)
    assert(t.root.right.value == "R")
  test "2.3":
    t.insert(7, "R")
    t.insert(3, "L")
    assert(t.root.left.key == 3)
    assert(t.root.left.value == "L")
    assert(t.root.right.key == 7)
    assert(t.root.right.value == "R")

suite "Insertion Case 3":
  setup:
    let t = initRBTree[int, string]()
    t.insert(5, "ROOT")
    t.insert(3, "L")
    t.insert(7, "R")
    assert(t.root != nil)
    assert(t.root.left != nil)
    assert(t.root.right != nil)
    let left = t.root.left
    let right = t.root.right
  test "3.1":
    t.insert(2, "LL")
    assert(left.left.key == 2)
    assert(left.left.value == "LL")
  test "3.2":
    t.insert(4, "LR")
    assert(left.right.key == 4)
    assert(left.right.value == "LR")
  test "3.3":
    t.insert(6, "RL")
    assert(right.left.key == 6)
    assert(right.left.value == "RL")
  test "3.4":
    t.insert(8, "RR")
    assert(right.right.key == 8)
    assert(right.right.value == "RR")
  test "3.5":
    t.insert(8, "RR")
    t.insert(6, "RL")
    t.insert(4, "LR")
    t.insert(2, "LL")
    assert(left.left.key == 2)
    assert(left.right.key == 4)
    assert(right.left.key == 6)
    assert(right.right.key == 8)
    t.insert(1, "LLL")
    assert(left.left.left.key == 1)
    t.insert(9, "RRR")
    assert(right.right.right.key == 9)

suite "Insertion - Case 4":
  setup:
    let t = initRBTree[int, string]()
    t.insert(7, "R")
    t.insert(5, "C")
  test "4.1":
    t.insert(3, "L")
    assert(t.root != nil)
    assert(t.root.left != nil)
    assert(t.root.right != nil)
    let left = t.root.left
    let right = t.root.right
    assert(t.root.key == 5)
    assert(left.key == 3)
    assert(left.value == "L")
    assert(right.key == 7)
    assert(right.value == "R")


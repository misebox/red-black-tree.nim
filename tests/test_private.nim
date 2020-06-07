import unittest

# Include target module to test private property
include rbt

suite "Insertion Case 1":
  setup:
    let t = initRBTree[int, string]()
    t.insert(5, "ROOT")

  test "1.1 Insert root node":
    assert(t.root != nil)
    assert(t.root.isBlack)
    assert(t.root.key == 5)
    assert(t.root.value == "ROOT")

suite "Insertion Case 2":
  setup:
    let t = initRBTree[int, string]()
    t.insert(5, "ROOT")
    assert(t.root != nil)

  test "2.1 Insert to left of root":
    t.insert(3, "L")
    assert(t.root.left != nil)
    assert(t.root.left.isRed)
    assert(t.root.left.key == 3)
    assert(t.root.left.value == "L")
  test "2.2 Insert to right of root":
    t.insert(7, "R")
    assert(t.root.right != nil)
    assert(t.root.right.isRed)
    assert(t.root.right.key == 7)
    assert(t.root.right.value == "R")
  test "2.3 Insert to both side of root":
    t.insert(7, "R")
    t.insert(3, "L")
    assert(t.root.left.isRed)
    assert(t.root.left.key == 3)
    assert(t.root.left.value == "L")
    assert(t.root.right.isRed)
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
    assert(t.root.isBlack)
    assert(left.isRed)
    assert(right.isRed)
  test "3.1 Insert to left of left of root":
    t.insert(2, "LL")
    assert(t.root.isBlack)
    assert(left.isBlack)
    assert(right.isBlack)
    assert(left.left.isRed)
    assert(left.left.key == 2)
    assert(left.left.value == "LL")
  test "3.2 Insert to right of left of root":
    t.insert(4, "LR")
    assert(t.root.isBlack)
    assert(left.isBlack)
    assert(right.isBlack)
    assert(left.right.key == 4)
    assert(left.right.value == "LR")
  test "3.3 Insert to left of right of root":
    t.insert(6, "RL")
    assert(t.root.isBlack)
    assert(left.isBlack)
    assert(right.isBlack)
    assert(right.left.key == 6)
    assert(right.left.value == "RL")
  test "3.4 Insert to right of right of root":
    t.insert(8, "RR")
    assert(t.root.isBlack)
    assert(left.isBlack)
    assert(right.isBlack)
    assert(right.right.key == 8)
    assert(right.right.value == "RR")
  test "3.5 Insert child of child of child of root":
    t.insert(8, "RR")
    t.insert(6, "RL")
    t.insert(4, "LR")
    t.insert(2, "LL")
    assert(left.left.key == 2)
    assert(left.right.key == 4)
    assert(right.left.key == 6)
    assert(right.right.key == 8)
    t.insert(1, "LLL")
    assert(left.isRed)
    assert(left.left.isBlack)
    assert(left.right.isBlack)
    assert(left.left.left.key == 1)
    t.insert(9, "RRR")
    assert(right.isRed)
    assert(right.left.isBlack)
    assert(right.right.isBlack)
    assert(right.right.right.key == 9)

suite "Insertion - Case 4":
  setup:
    let t = initRBTree[int, string]()
    proc assertResult(t: RBTree) =
      assert(t.root.isBlack)
      assert(t.root.key == 5)
      assert(t.root.left.isRed)
      assert(t.root.left.key == 3)
      assert(t.root.right.isRed)
      assert(t.root.right.key == 7)

  test "4.1 Rotate R":
    t.insert(7, "G")
    t.insert(5, "P")
    assert(t.root.isBlack)
    assert(t.root.left.isRed)
    t.insert(3, "N")
    t.assertResult()
    assert(t.root.left.value == "N")
    assert(t.root.value == "P")
    assert(t.root.right.value == "G")

  test "4.2 Rotate L":
    t.insert(3, "G")
    t.insert(5, "P")
    assert(t.root.isBlack)
    assert(t.root.right.isRed)
    t.insert(7, "N")
    t.assertResult()
    assert(t.root.left.value == "G")
    assert(t.root.value == "P")
    assert(t.root.right.value == "N")

  test "4.3 Rotate L and R":
    t.insert(7, "G")
    t.insert(3, "P")
    assert(t.root.isBlack)
    assert(t.root.left.isRed)
    t.insert(5, "N")
    t.assertResult()
    assert(t.root.left.value == "P")
    assert(t.root.value == "N")
    assert(t.root.right.value == "G")

  test "4.4 Rotate R and L":
    t.insert(3, "G")
    t.insert(7, "P")
    assert(t.root.isBlack)
    assert(t.root.right.isRed)
    t.insert(5, "N")
    t.assertResult()
    assert(t.root.left.value == "G")
    assert(t.root.value == "N")
    assert(t.root.right.value == "P")
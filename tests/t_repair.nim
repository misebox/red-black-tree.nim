import unittest

include rbt

suite "repair: Deletion Case 1":
  setup:
    let t = initRBTree[int, string]()
    t.insert(5, "ROOT")
    t.root.paint(RED)

  test "1.1 Delete root node":
    t.root.repair
    assert(t.root != nil)
    assert(t.root.parent == nil)
    assert(t.root.left == nil)
    assert(t.root.right == nil)
    assert(t.root.isBlack)

suite "repair: Deletion Case 2":
  setup:
    let t = initRBTree[int, string]()
  test "2.1 Sibling is red and N is left child of P":
    t.insert(5, "P")
    t.insert(4, "N")
    t.insert(7, "S")
    t.insert(6, "SL")
    t.insert(8, "SR")
    t.insert(9, "SRR")
    let
      p  = t.root.search(5).target
      n  = t.root.search(4).target
      s  = t.root.search(7).target
      sl = t.root.search(6).target
      sr = t.root.search(8).target
    assert(p.value == "P")
    assert(n.value == "N")
    assert(s.value == "S")
    assert(sl.value == "SL")
    assert(sr.value == "SR")
    assert(s.isRed)

    n.repair
    assert(p.isRed)
    assert(s.isBlack)
    assert(p.parent == s)
    assert(s.left == p)
    assert(p.right == sl)
    assert(sl.parent == p)
    assert(s.right == sr)
    assert(sr.parent == s)

  test "2.2 Sibling is red and N is right child of P":
    t.insert(5, "P")
    t.insert(7, "N")
    t.insert(3, "S")
    t.insert(4, "SR")
    t.insert(2, "SL")
    t.insert(1, "SRR")
    let
      p  = t.root.search(5).target
      n  = t.root.search(7).target
      s  = t.root.search(3).target
      sr = t.root.search(4).target
      sl = t.root.search(2).target
    assert(p.value == "P")
    assert(n.value == "N")
    assert(s.value == "S")
    assert(sl.value == "SL")
    assert(sr.value == "SR")
    assert(s.isRed)

    n.repair
    assert(p.isRed)
    assert(s.isBlack)
    assert(p.parent == s)
    assert(s.right == p)
    assert(p.left == sr)
    assert(sr.parent == p)

suite "repair: Deletion Case 3":
  setup:
    let t = initRBTree[int, string]()
  test "3.1 N, P, S, SL, and SR are black, N is left child":
    t.insert(5, "P")
    t.insert(3, "N")
    t.insert(7, "S")
    t.insert(8, "SR")
    t.insert(6, "SL")
    let
      p  = t.root.search(5).target
      n  = t.root.search(3).target
      s  = t.root.search(7).target
      sr = t.root.search(6).target
      sl = t.root.search(8).target
    p.paint(BLACK)
    n.paint(BLACK)
    s.paint(BLACK)
    sl.paint(BLACK)
    sr.paint(BLACK)
    n.repair
    assert(s.isRed)
  test "3.2 N, P, S, SL, and SR are black, N is right child":
    t.insert(5, "P")
    t.insert(7, "N")
    t.insert(3, "S")
    t.insert(4, "SR")
    t.insert(2, "SL")
    let
      p  = t.root.search(5).target
      n  = t.root.search(7).target
      s  = t.root.search(3).target
      sr = t.root.search(4).target
      sl = t.root.search(2).target
    p.paint(BLACK)
    n.paint(BLACK)
    s.paint(BLACK)
    sl.paint(BLACK)
    sr.paint(BLACK)
    repair(n)
    assert(s.isRed)

suite "repair: Deletion Case 4":
  setup:
    let t = initRBTree[int, string]()
  test "4.1 P is red, S and children are black, N is left child":
    t.insert(5, "P")
    t.insert(3, "N")
    t.insert(7, "S")
    t.insert(8, "SR")
    t.insert(6, "SL")
    let
      p  = t.root.search(5).target
      n  = t.root.search(3).target
      s  = t.root.search(7).target
      sr = t.root.search(6).target
      sl = t.root.search(8).target
    p.paint(RED)
    n.paint(BLACK)
    s.paint(BLACK)
    sl.paint(BLACK)
    sr.paint(BLACK)
    n.repair
    assert(p.isBLACK)
    assert(s.isRed)
  test "4.2 P is red, S and children are black, N is right child":
    t.insert(5, "P")
    t.insert(7, "N")
    t.insert(3, "S")
    t.insert(4, "SR")
    t.insert(2, "SL")
    let
      p  = t.root.search(5).target
      n  = t.root.search(7).target
      s  = t.root.search(3).target
      sr = t.root.search(4).target
      sl = t.root.search(2).target
    p.paint(BLACK)
    n.paint(BLACK)
    s.paint(BLACK)
    sl.paint(BLACK)
    sr.paint(BLACK)
    repair(n)
    assert(p.isBLACK)
    assert(s.isRed)

suite "repair: Deletion Case 5 and 6":
  setup:
    let t = initRBTree[int, string]()
  test "5.1 S and SR are black, SL is red and N is left child":
    t.insert(5, "P")
    t.insert(3, "N")
    t.insert(10, "S")
    t.insert(11, "SR")
    t.insert(8, "SL")
    t.insert(4, "NR")
    t.insert(9, "SLR")
    t.insert(7, "SLL")
    let
      p  = t.root.search(5).target
      n  = t.root.search(3).target
      s  = t.root.search(10).target
      sl = t.root.search(8).target
      slr = t.root.search(9).target
      sll = t.root.search(7).target
      sr = t.root.search(11).target
    p.paint(RED)
    n.paint(BLACK)
    s.paint(BLACK)
    sl.paint(RED)
    sll.paint(BLACK)
    slr.paint(BLACK)
    sr.paint(BLACK)
    n.repair
    assert(sl.parent == nil)
    assert(sl.isRed)
    assert(sl.left == p)
    assert(sl.right == s)

    assert(s.parent == sl)
    assert(s.isBlack)
    assert(s.left == slr)
    assert(s.right == sr)

    assert(p.parent == sl)
    assert(p.isBlack)
    assert(p.left == n)
    assert(p.right == sll)

    assert(sll.parent == p)
    assert(sll.isBlack)
    assert(slr.parent == s)
    assert(slr.isBlack)

  test "5.2 S and SL are black, SR is red and N is right child":
    t.insert(5, "P")
    t.insert(8, "N")
    t.insert(1, "S")
    t.insert(3, "SR")
    t.insert(0, "SL")
    t.insert(6, "NL")
    t.insert(4, "SRR")
    t.insert(2, "SRL")
    let
      p  = t.root.search(5).target
      n  = t.root.search(8).target
      s  = t.root.search(1).target
      sr = t.root.search(3).target
      srr = t.root.search(4).target
      srl = t.root.search(2).target
      sl = t.root.search(0).target
    p.paint(RED)
    n.paint(BLACK)
    s.paint(BLACK)
    sr.paint(RED)
    srl.paint(BLACK)
    srr.paint(BLACK)
    sl.paint(BLACK)
    n.repair
    assert(sr.parent == nil)
    assert(sr.isRed)
    assert(sr.left == s)
    assert(sr.right == p)

    assert(s.parent == sr)
    assert(s.isBlack)
    assert(s.left == sl)
    assert(s.right == srl)

    assert(p.parent == sr)
    assert(p.isBlack)
    assert(p.left == srr)
    assert(p.right == n)

    assert(srr.parent == p)
    assert(srr.isBlack)
    assert(srl.parent == s)
    assert(srl.isBlack)
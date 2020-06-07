import strformat
import strutils
import logging
import options
export options

type
  Comparable* = concept o
    `cmp`(o, o) is int

  RBColor = bool

  RBNode*[K: Comparable, T] = ref object
    parent: RBNode[K, T]
    no: int
    left: RBNode[K, T]
    right: RBNode[K, T]
    color: bool
    key: K
    value: T

  RBTree*[K: Comparable, T] = ref object
    count: int
    depth: int
    root: RBNode[K, T]
  
  RBDir {.pure.} = enum
    LEFT = false
    RIGHT = true

const
  RED = false
  BLACK = true


# RBNode
proc paint(n: RBNode, c: RBColor) {.inline.} = n.color = c
proc isRed(n: RBNode): bool {.inline.} = (n != nil and n.color == RED)
proc isBlack(n: RBNode): bool {.inline.} = (n == nil or n.color == BLACK)

proc `$`*(n: RBNode): string =
  let pno = if n.parent != nil: $(n.parent.no) else: "nil"
  let lno = if n.left != nil: $(n.left.no) else: "nil"
  let rno = if n.right != nil: $(n.right.no) else: "nil"
  fmt"RBNode(no: {n.no}, parent: {pno}, left: {lno}, right: {rno}, key: {$ n.key}, value: {$ n.value})"

proc trace*(node: RBNode, depth: int = 0) =
  if node.right != nil: node.right.trace(depth+1)
  else: echo " ".repeat(depth*2 + 2), "+ [ ]"
  let c = if node.isRed: "-" else: "+"
  echo " ".repeat(depth*2), fmt"{c} [{node.no}. {node.key}: {node.value}]"
  if node.left != nil: node.left.trace(depth+1)
  else: echo " ".repeat(depth*2 + 2), "+ [ ]"

proc trace*(t: RBTree) =
  t.root.trace()

# Tree
proc initRBTree*[K, T](): RBTree[K, T] =
  RBTree[K, T](count: 0, depth: 0, root: nil)

proc initRBNode*[K, T](t: RBTree[K, T], p: RBNode[K, T], key: K, value: T): RBNode[K, T] =
  t.count += 1
  RBNode[K, T](parent: p, no: t.count, key: key, value: value, color: RED)

proc isLeft(n: RBNode): bool =
  assert(n.parent != nil, "Parent is nil")
  n.parent.left == n

proc rotate(n: RBNode, dir: RBDir): RBNode =
  when not defined(release): log(lvlDebug, fmt"[rotate {n.no} to {dir}]")
  var pivot: RBNode
  if dir == RBDir.LEFT:
    assert(n.right != nil, "Pivot is nil")
    pivot = n.right
    n.right = pivot.left
    pivot.left = n
  else:
    assert(n.left != nil, "Pivot is nil")
    pivot = n.left
    n.left = pivot.right
    pivot.right = n

  # pivot.color = n.color
  # n.color = RED

  block:
    if n.parent != nil:
      if n.isLeft:
        n.parent.left = pivot
      else:
        n.parent.right = pivot
    pivot.parent = n.parent
    n.parent = pivot

  pivot

proc flipColors(n: RBNode) =
  n.color = not n.color
  n.left.color = not n.left.color
  n.right.color = not n.right.color

proc balance(t: RBTree, node: RBNode) =
  var
    n = node
    p = n.parent

  if p.isBlack:
    when not defined(release):
      log(lvlDebug, "[Case 2: parent is black]")
    # Nothing to do
    return

  let g = p.parent
  let u = if p.isLeft: g.right else: g.left
  if p.isRed:
    if u != nil and u.isRed:
      when not defined(release):
        log(lvlDebug, "[Case 3: If P and U are red]")
      # Make P,U,G reversed
      g.flipColors()
      # Rerun on G recursively to preserve rules
      t.balance(g)
    else:
      # Case 4: P is red and U is black
      when not defined(release):
        log(lvlDebug, "[Case 4: P is red and U is black]")
      # - step 1: It makes the new node on the outside if it's on the inside
      # - step 2: Rotate G to oposite side
      if p.isLeft:
        if not n.isLeft:
          # N is right of left of G
          discard p.rotate(RBDir.LEFT)
          swap(n, p)
        # N is left of left of G
        discard g.rotate(RBDir.RIGHT)
      else:
        if n.isLeft:
          # N is left of right of G
          discard p.rotate(RBDir.RIGHT)
          swap(n, p)
        # N is right of right of G
        discard g.rotate(RBDir.LEFT)
      p.paint(BLACK)
      g.paint(RED)
  # Replace root
  while t.root.parent != nil:
    t.root = t.root.parent

proc insert*[K, T](t: RBTree[K, T], p: RBNode[K, T], key: K, value: T) =
  if p == nil:
    t.root = t.initRBNode(nil, key, value)
    return
  let cmp = key.cmp(p.key)
  if cmp == 0:
    p.value = value
    return
  else:
    if cmp < 0:
      if p.left == nil:
        p.left = t.initRBNode(p, key, value)
        balance(t, p.left)
      else:
        t.insert(p.left, key, value)
    else:
      if p.right == nil:
        p.right = t.initRBNode(p, key, value)
        balance(t, p.right)
      else:
        t.insert(p.right, key, value)

proc insert*[K, T](t: RBTree[K, T], key: K, value: T) =
  t.insert(t.root, key, value)
  # The root is always black
  when not defined(release):
    if t.root.isRed:
      log(lvlDebug, "[Case 1: The target node is root]")
  t.root.paint(BLACK)

proc get[K, T](p: RBNode[K, T], key: K): Option[T] =
  if p == nil: none(T)
  elif key == p.key: some(p.value)
  elif key < p.key:
    if p.left != nil: p.left.get(key) else: none(T)
  else:
    if p.right != nil: p.right.get(key) else: none(T)
  
proc `[]`*[K, T](t: RBTree[K, T], key: K): Option[T] =
  t.root.get(key)


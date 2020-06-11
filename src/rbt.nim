import strformat
import logging
import strutils
import options
export options

type
  Comparable* = concept o
    `cmp`(o, o) is int

  RBColor = bool

  RBNode[K: Comparable, T] = ref object
    parent: RBNode[K, T]
    no: int
    left: RBNode[K, T]
    right: RBNode[K, T]
    color: bool
    key: K
    value: T

  RBTree*[K: Comparable, T] = ref object
    ## Red-black tree
    count*: int
    depth: int
    root: RBNode[K, T]

  RBDir {.pure.} = enum
    LEFT = false
    RIGHT = true


  EdgeDir {.pure.} = enum
    None
    Left
    Right

  SearchResult[K, T] = tuple
    ## Found node  => (Left|Right, parent, target)
    ## Not found   => (Left|Right, parent,    nil)
    ## Found root  => (      None,    nil, target)
    ## Root is nil => (      None,    nil,    nil)
    edge: EdgeDir
    parent: RBNode[K, T]
    target: RBNode[K, T]

const
  RED = false
  BLACK = true

# RBDir
proc opposite(d: RBDir): RBDir {.inline.} =
  if d == RBDir.LEFT: RBDir.RIGHT else: RBDir.LEFT

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
  if node == nil: return
  node.right.trace(depth+1)
  let c = if node.isRed: "-" else: "+"
  echo " ".repeat(depth*2), fmt"{c} [{$node.no}. {$node.key}: {$node.value}]"
  node.left.trace(depth+1)

proc trace*(t: RBTree) =
  t.root.trace()
  echo ""

# Tree
proc initRBTree*[K, T](): RBTree[K, T] =
  RBTree[K, T](count: 0, depth: 0, root: nil)

proc initRBNode*[K, T](t: RBTree[K, T], p: RBNode[K, T], key: K, value: T): RBNode[K, T] =
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
    let v = pivot.left
    n.right = v
    if v != nil:
      v.parent = n
    pivot.left = n
  else:
    assert(n.left != nil, "Pivot is nil")
    pivot = n.left
    let v = pivot.right
    n.left = v
    if v != nil:
      v.parent = n
    pivot.right = n

  swap(n.color, pivot.color)

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

proc search[K, T](node: RBNode[K, T], key: K): SearchResult[K, T] {.inline.} =
  ## Search for key from specified node
  var
    n = node
    p: RBNode[K, T] = if n != nil: n.parent else: nil
    rt = EdgeDir.None
  while n != nil:
    let c = key.cmp(n.key)
    if c == 0:
      break
    p = n
    if c < 0:
      n = n.left
      rt = EdgeDir.Left
    else:
      n = n.right
      rt = EdgeDir.Right
  (rt, p, n)

# Insertion
proc balance(t: RBTree, node: RBNode) =
  var
    n = node
    p = n.parent
  if p.isBlack:
    when not defined(release):
      log(lvlDebug, "[Insertion Case 2: parent is black]")
    # Nothing to do
    return
  let g = p.parent
  let u = if p.isLeft: g.right else: g.left
  if p.isRed:
    if u != nil and u.isRed:
      when not defined(release):
        log(lvlDebug, "[Insertion Case 3: If P and U are red]")
      g.flipColors()
      t.balance(g)
    else:
      when not defined(release):
        log(lvlDebug, "[Insertion Case 4: P is red and U is black]")
      let dir = if p.isLeft: RBDir.RIGHT else: RBDir.LEFT
      if p.isLeft != n.isLeft:
        # - step 1: It makes the new node on the outside if it's on the inside
        discard p.rotate(dir.opposite)
      # - step 2: Rotate G to oposite side
      discard g.rotate(dir)

  # Replace root
  while t.root.parent != nil:
    t.root = t.root.parent

proc insert*[K, T](t: RBTree[K, T], key: K, value: T) {.inline.} =
  ## See: https://en.wikipedia.org/wiki/Red%E2%80%93black_tree#Insertion
  var (rt, p, n) = t.root.search(key)
  if n != nil:
    n.value = value
    return
  case rt
  of EdgeDir.None:
    n = t.initRBNode(nil, key, value)
    t.root = n
  of EdgeDir.Left:
    n = t.initRBNode(p, key, value)
    p.left = n
  of EdgeDir.Right:
    n = t.initRBNode(p, key, value)
    p.right = n
  t.balance(n)

  when not defined(release):
    if t.root.isRed:
      log(lvlDebug, "[Case 1: The target node is root]")
  # The root is always black
  t.root.paint(BLACK)
  t.count += 1

# Deletion
proc getSibling[K, T](n: RBNode[K, T]): RBNode[K, T] =
  if n.isLeft: n.parent.right else: n.parent.left

proc repairCase6[K, T](node: RBNode[K, T], isLeft: bool) {.inline.} =
  when not defined(release): log(lvlDebug, "[Deletion Case 6]")
  let p = node.parent
  let (edgeTo, sc) = if isLeft:
    (RBDir.LEFT, p.right.right)
  else:
    (RBDir.RIGHT, p.left.left)
  discard p.rotate(edgeTo)
  if sc != nil:
    sc.color = BLACK

proc repair[K, T](node: RBNode[K, T]) =
  if node == nil: return
  var n = node
  while true:
    var p = n.parent
    if p == nil:
      # Deletion Case 1
      n.paint(BLACK)
      when not defined(release): log(lvlDebug, "[Deletion Case 1]")
      return
    var s = n.getSibling
    if s == nil:
      return
    var isLeft = n.isLeft
    var (edgeTo, sc1, sc2) = if isLeft:
      (RBDir.LEFT, s.left, s.right)
    else:
      (RBDir.RIGHT, s.right, s.left)
    if s.isRed:
      # Deletion Case 2
      discard p.rotate(edgeTo)
      when not defined(release): log(lvlDebug, "[Deletion Case 2]")
      return
    if sc1 == nil or sc2 == nil: return
    if p.isBlack and s.isBlack and sc1.isBlack and sc2.isBlack:
      # Deletion Case 3
      s.paint(RED)
      n = p
      when not defined(release): log(lvlDebug, "[Deletion Case 3]")
      continue
    elif p.isRed and s.isBlack and sc1.isBlack and sc2.isBlack:
      when not defined(release): log(lvlDebug, "[Deletion Case 4]")
      swap(p.color, s.color)
    elif s.isBlack and sc1.isRed and sc2.isBlack:
      when not defined(release): log(lvlDebug, "[Deletion Case 5]")
      s = s.rotate(edgeTo.opposite)
      n.repairCase6(isLeft)
    elif s.isBlack and sc2.isRed:
      # Deletion Case 6
      n.repairCase6(isLeft)
    break

proc take*[K, T](t: RBTree[K, T], key: K): Option[T] {.inline.} =
  ## See: https://en.wikipedia.org/wiki/Red%E2%80%93black_tree#Removal
  let (_, _, n) = t.root.search(key)
  if n == nil: return none(T)
  result = some(n.value)
  var m = n.left.search(key).parent
  if m == nil: m = n.right.search(key).parent
  if m == nil: m = n else: (n.key, n.value) = (m.key, m.value)

  when not defined(release):
    log(lvlDebug, fmt"[{n.no}.{n.key} -> {m.no}.{m.key}]")
  var p = m.parent
  var c = if m.left != nil: m.left
    elif m.right != nil: m.right else: nil
  assert(m.left == nil or m.right == nil, "Something wrong: Deleted node has both children")

  # Delete m node
  t.count -= 1
  if p != nil:
    if m.isLeft: p.left = c
    else: p.right = c
    m.parent = nil
  else:
    t.root = c

  if c != nil:
    c.parent = p
    c.paint(BLACK)
    c.repair
    while c.parent != nil: c = c.parent
    t.root = c

proc remove*[K, T](t: RBTree[K, T], key: K) =
  discard t.take(key)

# Put
proc `[]=`*[K, T](t: var RBTree[K, T], key: K, value: T) =
  t.insert(key, value)

# Get
proc `[]`*[K, T](t: RBTree[K, T], key: K): Option[T] =
  let (_, _, n) = t.root.search(key)
  if n != nil:
    some(n.value)
  else:
    none(T)

import strformat
import strutils

type
  Data* = string

  RBNode* = ref object
    parent: RBNode
    no: int
    left: RBNode
    right: RBNode
    isRed: bool
    data: Data
    tree: RBTree

  RBTree* = ref object
    count*: int
    depth*: int
    root: RBNode
  
  RBDir {.pure.} = enum
    LEFT = false
    RIGHT = true


# RBNode
proc `$`*(n: RBNode): string =
  let pno = if n.parent != nil: $(n.parent.no) else: "nil"
  let lno = if n.left != nil: $(n.left.no) else: "nil"
  let rno = if n.right != nil: $(n.right.no) else: "nil"
  fmt"RBNode(no: {n.no}, parent: {pno}, left: {lno}, right: {rno}, data: {$ n.data})"

proc trace*(node: RBNode, depth: int = 0) =
  if node.right != nil: node.right.trace(depth+1)
  else: echo " ".repeat(depth*2 + 2), "(+ "
  let c = if node.isRed: "(- " else: "(+ "
  echo " ".repeat(depth*2), c, $node.no, ".", $node.data
  if node.left != nil: node.left.trace(depth+1)
  else: echo " ".repeat(depth*2 + 2), "(+ "

proc trace*(t: RBTree) =
  t.root.trace()

# Tree
proc initRBTree*(): RBTree =
  RBTree(count: 0, depth: 0, root: nil)

proc initRBNode*(t: RBTree, p: RBNode, no: int, data: Data, isRed: bool = true): RBNode =
  RBNode(parent: p, no: no, data: data, isRed: isRed, tree: t)

proc isLeft(n: RBNode): bool =
  assert(n.parent != nil, "Parent is nil")
  n.parent.left == n

proc rotate(n: RBNode, dir:RBDir) =
  when not defined(release): echo fmt"[rotate {n.no} to {dir}]"
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

  if n.parent != nil:
    if n.isLeft:
      n.parent.left = pivot
    else:
      n.parent.right = pivot
  pivot.parent = n.parent
  n.parent = pivot

proc balance(t: RBTree, node: RBNode) =
  var
    n = node
    p = n.parent

  if n.parent == nil:
    # Case 1: If the target node is root, it's repainted black
    when not defined(release):
      echo "[Case 1: The target node is root, make it black]"
    n.isRed = false
    return
  if p.isRed == false:
    # Case 2: If the parent is black, nothing to do
    when not defined(release):
      echo "[Case 2: parent is black, nothing to do]"
    return
  let g = p.parent
  let u = if p.isLeft: g.right else: g.left
  if p.isRed:
    if u != nil and u.isRed:
      # Case 3: If P and U are red, G,P,U are reversed
      when not defined(release): echo "[Case 3: P and U are red, now reversing]"
      p.isRed = false
      u.isRed = false
      g.isRed = true
      # Rerun on G recursively to preserve rules
      t.balance(g)
    else:
      # Case 4: P is red and U is black
      when not defined(release): echo "[Case 4: P is red and U is black]"
      # - step 1: It makes the new node on the outside if it's on the inside
      # - step 2: Rotate G to oposite side
      if p.isLeft:
        if not n.isLeft:
          # N is right of left of G
          p.rotate(RBDir.LEFT)
          swap(n, p)
        # N is left of left of G
        g.rotate(RBDir.RIGHT)
      else:
        if n.isLeft:
          # N is left of right of G
          p.rotate(RBDir.RIGHT)
          swap(n, p)
        # N is right of right of G
        g.rotate(RBDir.LEFT)
      p.isRed = false
      g.isRed = true
  # Replace root
  while t.root.parent != nil:
    t.root = t.root.parent

proc insert*(t: RBTree, data: Data, node: RBNode=nil) =
  var p = if node == nil: t.root else: node
  if p == nil:
    t.root = t.initRBNode(nil, t.count, data)
    t.count += 1
    when not defined(release): echo "---- before:"; t.root.trace()
    balance(t, t.root)
    when not defined(release): echo "---- after:"; t.root.trace()
  else:
    if data < p.data:
      if p.left == nil:
        p.left = t.initRBNode(p, t.count, data)
        t.count += 1

        when not defined(release): echo "---- before:"; t.root.trace()
        balance(t, p.left)
        when not defined(release): echo "---- after:"; t.root.trace()
      else:
        t.insert(data, p.left)
    else:
      if p.right == nil:
        p.right = t.initRBNode(p, t.count, data)
        t.count += 1
        when not defined(release): echo "---- before:"; t.root.trace()
        balance(t, p.right)
        when not defined(release): echo "---- after:"; t.root.trace()
      else:
        t.insert(data, p.right)

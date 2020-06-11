# Red-black tree

Red-black tree implementation for learning.
It probably works but isn't optimized.

## Usage

### Initialize

Any comparable type can be used as key.

```
# string key and string value
let t1 = initRBTree[string, string]()

# float64 key and uint64 value
let t2 = initRBTree[float64, uint64]()

type 
  GreatKey = object
    id: int
  Record = object
    name: string
    data: string
proc cmp(a: GreatKey, b: GreatKey): int = cmp(a.id, b.id)

# GreateKey as key and Record as value
let t3 = initRBTree[GreatKey, Record]()
```

### Insertion

```
t["the key"] = "the value"

# or
t.insert("the key", "the value")
```

### Getting value

Optional value is returned.

```
if t["the key"].isSome:
  assert(t["the key"].get == "the value")
```

### Overwriting

Inserting with same key is overwriting.
```
t["the key"] = "the value"
```

### Removal

```
t.remove("the key")
assert(t["the key"].isNone)
```

### Taking (Getting and removal)

```
echo t.take("the key")
assert(t["the key"].isNone)
```

### Traverse (Iteration)

It's iterator.

```
for k, v in t.traverse:
  echo (k, v)
```

## Example

See `src/example.nim`.

```
$ nimble run example
  Verifying dependencies for rbt@0.1.0
   Building rbt/example using c backend
[Insert]
inserted (ZRQ: plegh)
inserted (FXK: ncjxo)
inserted (YHI: yttpr)
inserted (HQZ: boyvd)
inserted (BKY: xerbw)
inserted (IZK: hkuxb)
inserted (KZY: pvlzl)
inserted (JWV: vutyb)
inserted (JOS: mkfaw)
inserted (WFL: ztoah)
inserted (UIS: ggxkw)
count: 11

[Trace]
    + [ZRQ: plegh]
  + [YHI: yttpr]
        - [WFL: ztoah]
      + [UIS: ggxkw]
        - [KZY: pvlzl]
    - [JWV: vutyb]
      + [JOS: mkfaw]
+ [IZK: hkuxb]
    + [HQZ: boyvd]
  + [FXK: ncjxo]
    + [BKY: xerbw]

[Get]
ZRQ: Some("plegh")
FXK: Some("ncjxo")
YHI: Some("yttpr")
HQZ: Some("boyvd")
BKY: Some("xerbw")
IZK: Some("hkuxb")
KZY: Some("pvlzl")
JWV: Some("vutyb")
JOS: Some("mkfaw")
WFL: Some("ztoah")
UIS: Some("ggxkw")

[Traverse]
("BKY", "xerbw")
("FXK", "ncjxo")
("HQZ", "boyvd")
("IZK", "hkuxb")
("JOS", "mkfaw")
("JWV", "vutyb")
("KZY", "pvlzl")
("UIS", "ggxkw")
("WFL", "ztoah")
("YHI", "yttpr")
("ZRQ", "plegh")

[Delete]
count: 0

[Use object as key or value]
((id: 4), (name: "bb", data: "yy"))
((id: 5), (name: "cc", data: "zz"))

```

## Test

See `tests/*.nim`.

```
$ nimble test
```

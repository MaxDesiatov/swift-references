//
//  main.swift
//  swift-references
//
//  Created by Max Desiatov on 08/12/2018.
//  Copyright © 2018 Max Desiatov. All rights reserved.
//

import Reference

struct Value {
  var x = 42
}

var value1 = Value()
var value2 = value1
value2.x = 5
print(value2.x)

let classReference1 = ClassReference(value1)
let classReference2 = classReference1
classReference2.value.x = 5
print(classReference1.value)

let closureReference1 = ClosureReference(value1)
var closureReference2 = closureReference1
closureReference2.value.x = 5
print(closureReference1.value)

private struct PropertyReferenceRetainer {
  var child: Reference<PropertyReferenceRetainer>?
  var parent: WeakReference<PropertyReferenceRetainer>?
}

func f() {
  for _ in (0..<1_000_000) {
    var parent = Reference(PropertyReferenceRetainer())
    var child = Reference(PropertyReferenceRetainer())
    parent.value.child = child
    child.value.parent = WeakReference(parent)
  }
}

func test() {
  f()
  print("allocations finished 1")

  f()
  print("allocations finished 2")
}

test()

print("test finished")

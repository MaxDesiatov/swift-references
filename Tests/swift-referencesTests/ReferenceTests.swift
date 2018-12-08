//
//  ReferenceTests.swift
//  ReferenceTests
//
//  Created by Max Desiatov on 08/12/2018.
//  Copyright © 2018 Max Desiatov. All rights reserved.
//

import XCTest
@testable import Reference

private struct Value {
  var x = 42
}

private let count = 1_000_000

private class ClosureRetainer {
  var x = 0
  var closure: (() -> ())?

  init() {
    closure = {
      self.x += 1
    }
  }
}

private class PropertyRetainer {
  var child: PropertyRetainer?
  var parent: PropertyRetainer?
}

private struct PropertyReferenceRetainer {
  var child: Reference<PropertyReferenceRetainer>?
  var parent: WeakReference<PropertyReferenceRetainer>?
}

class ReferenceTests: XCTestCase {
  func testClassReference() {
    let classReference1 = ClassReference(Value())
    let classReference2 = classReference1
    classReference2.value.x = 5

    XCTAssertEqual(classReference1.value.x, classReference2.value.x)
  }

  func testClosureReference() {
    let closureReference1 = ClosureReference(Value())
    var closureReference2 = closureReference1
    closureReference2.value.x = 5

    XCTAssertEqual(closureReference1.value.x, closureReference2.value.x)
  }

  func testImmutableClassReference() {
    let classReference1 = Reference(Value())
    var classReference2 = classReference1
    classReference2.value.x = 5

    XCTAssertEqual(classReference1.value.x, classReference2.value.x)
  }

  func testClosureRetainer() {
    var retainer = ClosureRetainer()
    weak var testReference = retainer

    retainer = ClosureRetainer()
    XCTAssertNotNil(testReference)
  }

  func testPropertyRetainer() {
    var parent = PropertyRetainer()
    var child = PropertyRetainer()
    weak var testParentReference = parent
    weak var testChildReference = child
    parent.child = child
    child.parent = parent

    parent = PropertyRetainer()
    child = PropertyRetainer()

    XCTAssertNotNil(testParentReference)
    XCTAssertNotNil(testChildReference)
  }

  func testPropertyReferenceRetainer() {
    var parent = Reference(PropertyReferenceRetainer())
    var child = Reference(PropertyReferenceRetainer())
    let testParentReference = WeakReference(parent)
    let testChildReference = WeakReference(child)
    parent.value.child = child
    child.value.parent = WeakReference(parent)

    parent = Reference(PropertyReferenceRetainer())
    child = Reference(PropertyReferenceRetainer())

    XCTAssertNil(testParentReference.value)
    XCTAssertNil(testChildReference.value)
  }

  func testClassReferencePerformance() {
    measure {
      _ = (1...count).map { _ in ClassReference(Value()) }
    }
  }

  func testClosureReferencePerformance() {
    measure {
      _ = (1...count).map { _ in ClosureReference(Value()) }
    }
  }

  func testImmutableClassReferencePerformance() {
    measure {
      _ = (1...count).map { _ in Reference(Value()) }
    }
  }
}

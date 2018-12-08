//
//  Reference.swift
//  Reference
//
//  Created by Max Desiatov on 08/12/2018.
//  Copyright © 2018 Max Desiatov. All rights reserved.
//

public final class ClassReference<T> {
  public var value: T

  public init(_ value: T) {
    self.value = value
  }
}

public struct ClosureReference<T> {
  private let setter: (T) -> ()
  private let getter: () -> T

  public var value: T {
    get {
      return getter()
    }
    set {
      setter(newValue)
    }
  }

  public init(_ value: T) {
    var value = value

    getter = { value }
    setter = { value = $0 }
  }
}

public struct Reference<T> {
  fileprivate let reference: ClassReference<T>

  public var value: T {
    get {
      return reference.value
    }
    set {
      reference.value = newValue
    }
  }

  public init(_ value: T) {
    reference = ClassReference(value)
  }
}

public struct WeakReference<T> {
  private weak var reference: ClassReference<T>?

  public var value: T? {
    get {
      return reference?.value
    }
    set {
      guard let v = newValue else {
        reference = nil
        return
      }

      reference?.value = v
    }
  }

  public init(_ strong: Reference<T>) {
    self.reference = strong.reference
  }
}

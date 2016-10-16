import Foundation

public enum List<T> {
    public typealias Supplier<T> = () -> List<T>
    case Cons(T, Supplier<T>)
    case Nil
}

public func cons<T>(_ value: T, _ list: List<T>) -> List<T> {
    return .Cons(value) { list }
}

public func lazyCons<T>(_ value: T, _ f: @escaping () -> List<T>) -> List<T> {
    return .Cons(value, f)
}

public func lazyCons<T>(_ value: T, _ f: @escaping @autoclosure () -> List<T>) -> List<T> {
    return .Cons(value, f)
}

public func iterate<T>(_ v: T, _ f: @escaping (T) -> T?) -> List<T> {
    return lazyCons(v) { () in
        guard let value = f(v) else {
            return .Nil
        }
        return iterate(value, f)
    }
}

extension List {
    public var car: T? {
        switch self {
        case let .Cons(car, _):
            return car
        case .Nil:
            return nil
        }
    }
    public var cdr: List<T> {
        switch self {
        case let .Cons(_, cdr):
            return cdr()
        case .Nil:
            return .Nil
        }
    }
    public func take(_ n: Int) -> List<T> {
        if n > 0 {
            if let v = car {
                return lazyCons(v, self.cdr.take(n - 1))
            }
        }
        return .Nil
    }
    public func filter(_ f: @escaping (T) -> Bool) -> List<T> {
        if let car = car {
            if f(car) {
                return lazyCons(car, self.cdr.filter(f))
            } else {
                return self.cdr.filter(f)
            }
        }
        return .Nil
    }
    public func map<U>(_ f: @escaping (T) -> U) -> List<U> {
        if let car = car {
            return lazyCons(f(car), self.cdr.map(f))
        }
        return .Nil
    }
    public func reduce<R>(_ initial: R, _ f: @escaping (R, T) -> R) -> R {
        var result = initial
        for value in self {
            result = f(result, value)
        }
        return result
    }
}

public struct ListIterator<T> : IteratorProtocol {
    public typealias Element = T
    
    init(_ list: List<T>) {
        _list = list
    }
    
    mutating public func next() -> Element? {
        let car = _list.car
        _list = _list.cdr
        return car
    }
    var _list: List<T>
}

extension List : Sequence {
    public func makeIterator() -> ListIterator<T> {
        return ListIterator(self)
    }
}

private func toList<T: IteratorProtocol>(g: T) -> List<T.Element>{
    var g = g
    if let value = g.next() {
        return lazyCons(value, toList(g: g))
    }
    return .Nil
}

extension List {
    internal init<S : Sequence>(_ s: S) where T == S.Iterator.Element {
        self = toList(g: s.makeIterator())
    }
}

extension List: ExpressibleByArrayLiteral {
    public typealias Element = T
    
    /// Create an instance initialized with `elements`.
    public init(arrayLiteral elements: Element...) {
        self = List(elements)
    }
}

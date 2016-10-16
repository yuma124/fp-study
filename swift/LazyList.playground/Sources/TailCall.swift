import Foundation

public class TailCall<T> {
    public typealias Call = () -> TailCall
    private let apply: Call?
    private let isComplete: Bool
    private let result: T?
    
    private init(isComplete: Bool, result: T?) {
        self.apply = nil
        self.isComplete = isComplete
        self.result = result
    }
    
    private init(apply: @escaping Call, isComplete: Bool, result: T?) {
        self.apply = apply
        self.isComplete = isComplete
        self.result = result
    }
    
    public static func call(_ apply: @escaping Call) -> TailCall<T> {
        return TailCall(apply: apply, isComplete: false, result: nil)
    }
    
    public static func done(_ value: T) -> TailCall<T> {
        return TailCall(isComplete: true, result: value)
    }
    
    public func invoke() -> T? {
        return iterate(self){
            print("iterate")
            return $0.apply?()
            }.filter{
            print("filter")
                return $0.isComplete
            }.car?.result
    }
}


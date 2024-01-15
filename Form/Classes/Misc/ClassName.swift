import Foundation

public protocol ClassName {
    static var className: String { get }
}

public extension ClassName {
    
    static var className: String {
        return String(describing: Self.self)
    }
}

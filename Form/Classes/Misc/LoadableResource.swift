import UIKit

public protocol LoadableResource {
    static var bundle: Bundle { get }
}

public extension LoadableResource {

    static var bundle: Bundle {
        guard let anyClass = Self.self as? AnyClass else {
            fatalError("Unexpected error occurred while loading bundle for class")
        }
        return Bundle(for: anyClass)
    }
}

public extension LoadableResource where Self: UIView {

    static var nib: UINib {
        return UINib(nibName: String(describing: Self.self), bundle: bundle)
    }
}

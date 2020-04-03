//
//  Extensions.swift
//  WV Connector
//
//  Created by Sage Conger on 2/6/20.
//

import UIKit

@discardableResult
public func with<T>(_ object: T, closure: (T) throws -> Void) rethrows -> T {
    try closure(object)
    return object
}

@objc final class ClosureSleeve: NSObject {
    private let closure: () -> Void

    init (_ closure: @escaping () -> Void) {
        self.closure = closure
        super.init()
    }

    @objc final func invoke () {
        closure()
    }
}

extension UIControl {
    final func addAction(for controlEvents: UIControl.Event, action: @escaping () -> Void) {
        let sleeve = ClosureSleeve(action)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(
            self,
            String(format: "[%d]", Int.random(in: 0..<Int.max)),
            sleeve,
            objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
        )
    }
}

extension UIView {
    final var usesAutoLayout: Bool {
        get {
            translatesAutoresizingMaskIntoConstraints == false
        }
        set {
            translatesAutoresizingMaskIntoConstraints = !newValue
        }
    }
}

extension TimeZone {
    static let gmt = TimeZone(secondsFromGMT: 0)
}

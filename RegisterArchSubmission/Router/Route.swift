protocol Route {
    static var name: String { get }
}

extension Route {
    static var name: String { String(describing: self) }
}

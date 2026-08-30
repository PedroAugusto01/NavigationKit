/// Convenience base class that implements the `children`/`onFinish` storage `Coordinator`
/// requires, so subclasses only need to override `start()`.
open class BaseCoordinator: Coordinator {
    public var children: [Coordinator] = []
    public var onFinish: (() -> Void)?

    public init() {}

    open func start() {
        fatalError("\(Self.self) must override start()")
    }
}

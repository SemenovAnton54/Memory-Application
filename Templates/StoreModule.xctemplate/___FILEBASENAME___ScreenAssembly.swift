//___FILEHEADER___

import Swinject

struct ___VARIABLE_productName:identifier___ScreenAssembly: Assembly {
    func assemble(container: Container) {
        container.register(___VARIABLE_productName:identifier___ScreenFactory.self) { resolver in
            ___VARIABLE_productName:identifier___ScreenFactory(
                dependencies: try resolver.autoresolve(___VARIABLE_productName:identifier___ScreenFactory.Dependencies.init)
            )
        }
    }
}

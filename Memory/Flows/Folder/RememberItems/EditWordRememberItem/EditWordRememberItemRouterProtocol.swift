//
//  EditWordRememberItemRouterProtocol.swift
//  Memory
//

protocol EditWordRememberItemRouterProtocol {
    func close()
    func imagePicker(text: String?, completion: @escaping ([ImageType]) -> Void)
}

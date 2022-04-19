//
//  BindableType.swift
//  Combine_MVVM_Sample
//
//  Created by Chiang Kevin on 2022/4/19.
//

protocol BindableType{
    associatedtype ViewModelType
    
    var vm: ViewModelType! { get set }
    var cancelBag: CancelBag { get set }
    
    func bindViewModel()
}

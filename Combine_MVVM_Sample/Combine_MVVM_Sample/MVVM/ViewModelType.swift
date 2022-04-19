//
//  ViewModelType.swift
//  Combine_MVVM_Sample
//
//  Created by Chiang Kevin on 2022/4/19.
//

import Combine

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input, _ cancelBag: CancelBag) -> Output
}

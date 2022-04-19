//
//  CancelBag.swift
//  Combine_MVVM_Sample
//
//  Created by Chiang Kevin on 2022/4/19.
//

import Combine

final class CancelBag {
    var subscriptions = Set<AnyCancellable>()
    
    /// https://developer.apple.com/documentation/combine/anycancellable
    /// As apple mentioned: An AnyCancellable instance automatically calls cancel() when deinitialized.
    ///
    /// You can skip calling this function in normal usage
    func cancel() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
}

extension AnyCancellable {
    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}

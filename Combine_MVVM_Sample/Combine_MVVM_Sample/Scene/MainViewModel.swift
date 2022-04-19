//
//  MainViewModel.swift
//  Combine_MVVM_Sample
//
//  Created by Chiang Kevin on 2022/4/19.
//

import Foundation
import Combine

class MainViewModel {
    
    let maxSeconds: Int
    
    private var timer: Timer?
    private var currentSeconds: Int = 0
    
    init(maxSeconds: Int) {
        self.maxSeconds = maxSeconds
    }
}

// MARK: - ViewModelType

extension MainViewModel: ViewModelType {
    
    struct Input {
        let startTrigger: AnyPublisher<Void, Never>
        let stopTrigger: AnyPublisher<Void, Never>
    }
    
    final class Output {
        @Published var isLoading = false
        @Published var timerString = ""
    }
    
    func transform(_ input: Input, _ cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.startTrigger
            .sink { [weak self] _ in
                guard let self = self else { return }
                output.timerString = "Timer: \(self.maxSeconds)s"
                
                self.timer?.invalidate()
                self.startTimer(output)
            }
            .store(in: cancelBag)
        
        input.stopTrigger
            .sink { [weak self] _ in
                output.timerString = "Timer: 0s"
                output.isLoading = false
                
                self?.timer?.invalidate()
            }
            .store(in: cancelBag)
        
        return output
    }
}

// MARK: - Private Functions

private extension MainViewModel {
    
    func startTimer(_ output: Output) {
        self.currentSeconds = 0
        
        output.isLoading = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            guard let self = self else { return }
            self.currentSeconds += 1
            
            let remainSeconds = self.maxSeconds - self.currentSeconds
            output.timerString = "Timer: \(remainSeconds)s"
            
            if remainSeconds == 0 {
                output.isLoading = false
                timer.invalidate()
            }
        })
    }
}


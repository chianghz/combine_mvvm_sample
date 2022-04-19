//
//  MainViewController.swift
//  Combine_MVVM_Sample
//
//  Created by Chiang Kevin on 2022/4/19.
//

import UIKit
import Combine

class MainViewController: UIViewController, BindableType {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var timerLabel: UILabel!
    
    // MARK: Actions
    
    @IBAction func onStartButtonClicked(_ sender: Any) {
        vmStartTrigger.send()
    }
    
    @IBAction func onStopButtonClicked(_ sender: Any) {
        vmStopTrigger.send()
    }
    
    // MARK: Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    // MARK: - BindableType
    
    var vm: MainViewModel!
    
    var cancelBag = CancelBag()
    
    private let vmStartTrigger = PassthroughSubject<Void, Never>()
    private let vmStopTrigger = PassthroughSubject<Void, Never>()
    
    func bindViewModel() {
        self.vm = MainViewModel(maxSeconds: 5)
        let input = MainViewModel.Input(startTrigger: vmStartTrigger.eraseToAnyPublisher(),
                                        stopTrigger: vmStopTrigger.eraseToAnyPublisher())
        let output = vm.transform(input, cancelBag)
        
        output.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                isLoading ? self?.indicator.startAnimating() : self?.indicator.stopAnimating()
            }
            .store(in: cancelBag)
        
        output.$timerString
            .receive(on: DispatchQueue.main)
            .sink { [weak self] timerString in
                self?.timerLabel.text = timerString
            }
            .store(in: cancelBag)
    }
}

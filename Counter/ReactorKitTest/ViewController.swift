//
//  ViewController.swift
//  ReactorKitTest
//
//  Created by seungwooKim on 2023/10/24.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift
    
final class ViewController: UIViewController, StoryboardView {
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func bind(reactor: ViewReactor) {
        // Action
        plusButton.rx.tap
//            .debug("🐞1")
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
//            .debug("🐞2")
            .map{ ViewReactor.Action.increase } // ????
//            .debug("🐞3")
            .bind(to: reactor.action) // bind는 RxCocoa에 있음.
            .disposed(by: disposeBag)
        
        minusButton.rx.tap
            .map { ViewReactor.Action.decrease } // ????
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state
            .debug("👍1")
            .map { $0.value }
            .debug("👍2")
            .distinctUntilChanged()
            .debug("👍3")
            .map {"\($0)"}
            .debug("👍4")
            .bind(to: valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
//        reactor.state
//            .map { $0.alertMessage }
//            .distinctUntilChanged()
//            .compactMap { $0 }
//            .subscribe { [weak self] message in
//                let alertController = UIAlertController(
//                    title: nil,
//                    message: message,
//                    preferredStyle: .alert
//                )
//                alertController.addAction(UIAlertAction(
//                    title: "OK",
//                    style: .default,
//                    handler: nil
//                ))
//                self?.present(alertController, animated: true)
//            }
//            .disposed(by: disposeBag)
        
        reactor.pulse(\.$alertMessage)
            .debug("🐻1")
            .compactMap { $0 }
            .debug("🐻2")
            .subscribe { [weak self] message in
                let alertController = UIAlertController(
                    title: nil,
                    message: message,
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(
                    title: "OK",
                    style: .default,
                    handler: nil
                ))
                self?.present(alertController, animated: true)
            }
            .disposed(by: disposeBag)
    }
}


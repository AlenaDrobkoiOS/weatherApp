//
//  AlertService.swift
//  weatherApp
//
//  Created by Alena Drobko on 08.10.2023.
//

import RxSwift

/// Alerts types: warning or error
enum AlertType {
    case warning(_ message: String)
    case error(_ error: Error)
    
    var info: (title: String, message: String) {
        switch self {
        case .warning(let message):
            return (Localizationable.Global.warning.localized, message)
        case .error(let error):
            return (Localizationable.Global.error.localized, error.localizedDescription)
        }
    }
}

/// Alert Service protocol
protocol AlertServiceType: Service {
    var show: PublishSubject<AlertType> { get }
}

/// Service that helps with showing alert
final class AlertService: AlertServiceType {
    
    var show: PublishSubject<AlertType> = PublishSubject()
    
    private let bag = DisposeBag()
    
    init() {
        show.asObservable()
            .bind { [weak self] alert in
                self?.showAlert(title: alert.info.title, message: alert.info.message)
            }
            .disposed(by: bag)
    }
    
    fileprivate func showAlert(title: String, message: String? = nil) {
        let confirmAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        confirmAlert.addAction(UIAlertAction(title: Localizationable.Global.ok.localized,
                                             style: .cancel,
                                             handler: { _ in }))
        UIApplication.getTopViewController()?.present(confirmAlert, animated: true, completion: nil)
    }
}

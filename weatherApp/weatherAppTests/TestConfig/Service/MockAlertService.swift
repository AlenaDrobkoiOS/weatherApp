//
//  MockAlertService.swift
//  weatherAppTests
//
//  Created by Alena Drobko on 08.10.23.
//

import Foundation
import RxSwift
@testable import weatherApp

class MockAlertService: AlertServiceType {
    var show: PublishSubject<AlertType> = PublishSubject()
    
    func showAlert(title: String, message: String? = nil) {}
}

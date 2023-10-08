//
//  WeatherDetailViewModel.swift
//  weatherAppTests
//
//  Created by Alena Drobko on 08.10.23.
//

import XCTest
import RxSwift
import RxCocoa
@testable import weatherApp

class WeatherDetailViewModelTests: XCTestCase {
    
    var viewModel: WeatherDetailViewModel!
    var disposeBag: DisposeBag!
    
    var dismissTapped = PublishRelay<Void>()
    var dismissed = PublishRelay<Void>()
    
    var headerInfo = BehaviorSubject<HeaderInfo>(value: .init())
    var detailInfo = BehaviorSubject<WeatherDetailInfoViewModel>(value: .init())
    var footerInfo = BehaviorSubject<FooterViewInfo>(value: .init())
    
    override func setUp() {
        super.setUp()
        
        disposeBag = DisposeBag()
        
        viewModel = WeatherDetailViewModel(injections:
                .init(serviceHolder: TestConfiguration.getServiceHolder(),
                      city: City(id: 1, name: "City1", country: "Country1"),
                      historyInfo: nil))
        
        setupOutput()
    }
    
    func setupOutput() {
        let input = BaseWeatherDetailViewModel.Input(
            dismissTapped: dismissTapped.asObservable(),
            dismissed: dismissed.asObservable(),
            disposeBag: disposeBag)
        
        viewModel.transform(input, outputHandler: setupInput(input:))
    }
    
    func setupInput(input: BaseWeatherDetailViewModel.Output) {
        disposeBag.insert(
            input.headerInfo.asObservable().bind(to: headerInfo),
            input.detailInfo.asObservable().bind(to: detailInfo),
            input.footerInfo.asObservable().bind(to: footerInfo)
        )
    }
    
    override func tearDown() {
        viewModel = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func testHeaderInfo() {
        // Given
        let expectation = XCTestExpectation(description: "Header Info")
        
        // When
        headerInfo.subscribe(onNext: { headerInfo in
            // Then
            XCTAssertEqual(headerInfo.title, "City1 Country1")
            XCTAssertEqual(headerInfo.leftButtonState, SideButtonState.modal)
            expectation.fulfill()
        }).disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testWeatherDetail() {
        // Given
        let expectation = XCTestExpectation(description: "Weather Detail")
        
        // When
        detailInfo.subscribe(onNext: { weatherDetail in
            // Then
            XCTAssertEqual(weatherDetail.description, "Clear") // Assuming the description from mock data
            XCTAssertEqual(weatherDetail.temperature, "25.0") // Assuming the temperature from mock data
            expectation.fulfill()
        }).disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFooterInfo() {
        // Given
        let expectation = XCTestExpectation(description: "Footer Info")
        
        // When
        footerInfo.subscribe(onNext: { footerInfo in
            // Then
            XCTAssertEqual(footerInfo.city, "City1")
            XCTAssertNotNil(footerInfo.date)
            expectation.fulfill()
        }).disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testDismissal() {
        // Given
        let dismissExpectation = XCTestExpectation(description: "Dismiss Tapped")
        let dismissedExpectation = XCTestExpectation(description: "Dismissed")
        
        // When
        viewModel.dismissTapped.subscribe(onNext: { _ in
            dismissExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.dismissed.subscribe(onNext: { _ in
            dismissedExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        dismissTapped.accept(())
        dismissed.accept(())
        
        wait(for: [dismissExpectation, dismissedExpectation], timeout: 5.0)
    }
}

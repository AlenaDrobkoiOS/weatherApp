//
//  HistoricalViewModelTests.swift
//  weatherAppTests
//
//  Created by Alena Drobko on 08.10.23.
//

import Foundation
import XCTest
import RxSwift
import RxCocoa
@testable import weatherApp

class HistoricalViewModelTests: XCTestCase {
    
    var viewModel: HistoricalViewModel!
    var disposeBag: DisposeBag!
    
    var backTapped = PublishRelay<Void>()
    var itemSelected = PublishRelay<IndexPath>()
    
    var tableItems = BehaviorSubject<[HistoricalInfo]>(value: [])
    var headerInfo = BehaviorSubject<HeaderInfo>(value: .init())
    
    override func setUp() {
        super.setUp()
        
        disposeBag = DisposeBag()
        
        
        viewModel = HistoricalViewModel(injections:
                .init(serviceHolder: TestConfiguration.getServiceHolder(),
                      city: City(id: 1, name: "City1", country: "Country1")))
        setupOutput()
    }
    
    func setupOutput() {
        let input = BaseHistoricalViewModel.Input(
            backTapped: backTapped.asObservable(),
            itemSelected: itemSelected.asObservable(),
            disposeBag: disposeBag)
        
        viewModel.transform(input, outputHandler: setupInput(input:))
    }
    
    func setupInput(input: BaseHistoricalViewModel.Output) {
        disposeBag.insert(
            input.tableItems.asObservable().bind(to: tableItems),
            input.headerInfo.asObservable().bind(to: headerInfo)
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
            XCTAssertEqual(headerInfo.title, "City1\nHISTORICAL")
            XCTAssertEqual(headerInfo.leftButtonState, SideButtonState.left)
            expectation.fulfill()
        }).disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchHistory() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch History")
        
        // When
        tableItems.asObservable().subscribe(onNext: { history in
            // Then
            XCTAssertEqual(history.count, 2) // Assuming 2 historical items are returned from the mock service
            expectation.fulfill()
        }).disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testItemSelection() {
        // Given
        let expectation = XCTestExpectation(description: "Item Selection")
        let indexPath = IndexPath(row: 0, section: 0)
        
        // When
        viewModel.openDetails.subscribe(onNext: { cityInfo in
            // Then
            XCTAssertEqual(cityInfo.city.id, 1) // Assuming the first city has an id of 1
            XCTAssertEqual(cityInfo.historicalInfo.weatherInfo.description, "Sunny") // Assuming the description of the historical item
            expectation.fulfill()
        }).disposed(by: disposeBag)
        
        itemSelected.accept(indexPath)
        
        wait(for: [expectation], timeout: 5.0)
    }
}

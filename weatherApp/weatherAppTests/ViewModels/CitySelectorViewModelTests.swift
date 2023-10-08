//
//  CitySelectorViewModelTests.swift
//  weatherAppTests
//
//  Created by Alena Drobko on 08.10.23.
//

import XCTest
import RxSwift
import RxCocoa
@testable import weatherApp

class CitySelectorViewModelTests: XCTestCase {
    
    var viewModel: CitySelectorViewModel!
    var disposeBag: DisposeBag!
    
    var addTapped = PublishRelay<Void>()
    var citySelected = PublishRelay<IndexPath>()
    var tableItems = PublishRelay<[CityCellModel]>()
    
    override func setUp() {
        super.setUp()
        
        disposeBag = DisposeBag()
        
        viewModel = CitySelectorViewModel(injections:
                .init(serviceHolder: TestConfiguration.getServiceHolder()))
        setupOutput()
    }
    
    func setupOutput() {
        let input = BaseCitySelectorViewModel.Input(
            addTapped: addTapped.asObservable(),
            citySelected: citySelected.asObservable(),
            disposeBag: disposeBag)
        
        viewModel.transform(input, outputHandler: setupInput(input:))
    }
    
    func setupInput(input: BaseCitySelectorViewModel.Output) {
        disposeBag.insert(
            input.tableItems.asObservable().bind(to: self.tableItems)
        )
    }
    
    override func tearDown() {
        viewModel = nil
        disposeBag = nil
        
        super.tearDown()
    }
    
    func testFetchCities() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch Cities")

        // When
        tableItems.subscribe(onNext: { tableItems in
            // Then
            XCTAssertEqual(tableItems.count, 2, "Expected 2 cities")
            expectation.fulfill()
        })
        .disposed(by: disposeBag)

        viewModel.reload.onNext(())

        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCitySelection() {
        // Given
        let expectation = XCTestExpectation(description: "City Selection")
        let indexPath = IndexPath(row: 0, section: 0)
        
        // When
        viewModel.openDetails.subscribe(onNext: { cityInfo in
            // Then
            XCTAssertEqual(cityInfo.city.id, 1) // Assuming the first city has an id of 1
            expectation.fulfill()
        })
        .disposed(by: disposeBag)
        
        citySelected.accept(indexPath)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testAddButtonTapped() {
        // Given
        let expectation = XCTestExpectation(description: "Add Button Tapped")
        
        // When
        viewModel.openSearch.subscribe(onNext: { _ in
            // Then
            expectation.fulfill()
        })
        .disposed(by: disposeBag)
        
        addTapped.accept(())
        
        wait(for: [expectation], timeout: 5.0)
    }
}

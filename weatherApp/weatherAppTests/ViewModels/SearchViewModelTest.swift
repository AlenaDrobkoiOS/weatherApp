//
//  SearchViewModelTest.swift
//  weatherAppTests
//
//  Created by Alena Drobko on 08.10.23.
//

import XCTest
import RxSwift
import RxCocoa
@testable import weatherApp

class SearchViewModelTests: XCTestCase {

    var viewModel: SearchViewModel!
    var disposeBag: DisposeBag!
    
    var cancelTapped = PublishRelay<Void>()
    var citySelected = PublishRelay<IndexPath>()
    var textUpdated = PublishRelay<String?>()
    var dismissed = PublishRelay<Void>()
    
    var tableItems = PublishRelay<[CityCellModel]>()
    var isLoading = PublishRelay<Bool>()
    
    override func setUp() {
        super.setUp()
        
        disposeBag = DisposeBag()
        
        viewModel = SearchViewModel(injections: .init(serviceHolder: TestConfiguration.getServiceHolder()))
        setupOutput()
    }

    func setupOutput() {
        let input = BaseSearchViewModel.Input(
            cancelTapped: cancelTapped.asObservable(),
            citySelected: citySelected.asObservable(),
            textUpdated: textUpdated.asObservable(),
            dismissed: dismissed.asObservable(),
            disposeBag: disposeBag)
        
        viewModel.transform(input, outputHandler: setupInput(input:))
    }
    
    func setupInput(input: BaseSearchViewModel.Output) {
        disposeBag.insert(
            input.tableItems.asObservable().bind(to: tableItems),
            input.isLoading.asObservable().bind(to: isLoading)
        )
    }

    override func tearDown() {
        viewModel = nil
        disposeBag = nil
        
        super.tearDown()
    }
    
    func testTableItemsUpdate() {
        // Given
        let expectation = XCTestExpectation(description: "Table Items Update")
        
        // When
        tableItems.subscribe(onNext: { cityCellModels in
            // Then
            XCTAssertEqual(cityCellModels.count, 1) // Assuming 1 city is returned from the mock service
            expectation.fulfill()
        })
        .disposed(by: disposeBag)
        
        textUpdated.accept("City")
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testLoadingState() {
        // Given
        let expectation = XCTestExpectation(description: "Loading State")
        
        // When
        isLoading.take(1).subscribe(onNext: { loading in
            // Then
            XCTAssertEqual(loading, true) // Assuming loading state is true during the search
            expectation.fulfill()
        })
        .disposed(by: disposeBag)
        
        textUpdated.accept("City")
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCitySelection() {
        // Given
        let expectation = XCTestExpectation(description: "City Selection")
        let indexPath = IndexPath(row: 0, section: 0)
        
        // When
        viewModel.openDetails.subscribe(onNext: { cityInfo in
            // Then
            XCTAssertEqual(cityInfo.city.name, "CITY1") // Assuming the first city's name is "City1"
            XCTAssertNotNil(cityInfo.historicalInfo) // Historical info should not be nil for the selected city
            expectation.fulfill()
        })
        .disposed(by: disposeBag)
        
        textUpdated.accept("City")
        citySelected.accept(indexPath)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testDismissTapped() {
        // Given
        let expectation = XCTestExpectation(description: "Cancel Tapped")
        
        // When
        viewModel.dismissed.subscribe(onNext: {
            // Then
            expectation.fulfill()
        })
        .disposed(by: disposeBag)
        
        dismissed.accept(())
        
        wait(for: [expectation], timeout: 5.0)
    }
}

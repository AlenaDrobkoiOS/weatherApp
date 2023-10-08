//
//  SynchronizationServiceTests.swift
//  weatherAppTests
//
//  Created by Alena Drobko on 08.10.23.
//

import XCTest
import CoreData
@testable import weatherApp

class SynchronizationServiceTests: XCTestCase {
    
    var dataController: DataController!
    var synchronizationService: SynchronizationSerice!
    var cityModelDAO: CityModelDAO!
    var historyActivityDAO: GenericDAO<HistoricalInfo, WeatherInfoCREntity>!
    
    // Create a test city and historical information
    let city = City(id: 1, name: "TestCity", country: "TestCountry")
    let weather = WeatherDetailInfoViewModel(iconID: "01d",  description: "Sunny",
                                             windSpeeped: "10 m/s", humidity: "60%",
                                             temperature: "25°C")
    var historicalInfo: HistoricalInfo {
        return .init(weatherInfo: weather, date: Date())
    }
    var cityInfo: CityInfo {
        return .init(city: city, history: [historicalInfo])
    }
    
    override func setUp() {
        super.setUp()
        
        dataController = DataController {
            // Initialization completion closure, if needed
        }
        historyActivityDAO = GenericDAO<HistoricalInfo, WeatherInfoCREntity>(context: dataController.mainContext)
        cityModelDAO = CityModelDAO(context: dataController.mainContext,
                                    historyDAO: historyActivityDAO)
        synchronizationService = SynchronizationSerice(historyActivityDAO: historyActivityDAO,
                                                       cityDAO: cityModelDAO)
        
        historyActivityDAO.deleteAll()
        cityModelDAO.deleteAll()
    }
    
    
    override func tearDown() {
        historyActivityDAO.deleteAll()
        cityModelDAO.deleteAll()
        
        super.tearDown()
    }
    
    func testAddCityInfoAndRetrieve() {
        let expectation = XCTestExpectation(description: "Add City Info and Retrieve History")
        
        synchronizationService.addCityInfo(cityInfo) {
            // After adding city info, fetch city history
            self.synchronizationService.getCityHistory(for: self.city) { historicalInfoArray in
                // Assert the fetched historicalInfoArray
                XCTAssertNotNil(historicalInfoArray)
                XCTAssertEqual(historicalInfoArray?.count, 1)
                
                // Additional assertions can be made based on the expected historical data
                let retrievedHistoricalInfo = historicalInfoArray?.first
                XCTAssertEqual(retrievedHistoricalInfo?.weatherInfo.description, "Sunny")
                
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetAllCities() {
        let expectation = XCTestExpectation(description: "Get All Cities")
        
        synchronizationService.addCityInfo(cityInfo) {
            // After adding city info, get all cities
            self.synchronizationService.getCities { cityInfoArray in
                // Assert the fetched cityInfoArray
                XCTAssertNotNil(cityInfoArray)
                XCTAssertEqual(cityInfoArray?.count, 1)
                
                // Additional assertions can be made based on the expected city data
                let retrievedCity = cityInfoArray?.first
                XCTAssertEqual(retrievedCity?.city.name, "TestCity")
                
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testUpdateCityInfo() {
        let expectation = XCTestExpectation(description: "Update City Info")
        
        synchronizationService.addCityInfo(cityInfo) {
            // After adding city info, update city info
            let updatedCity = City(id: 1, name: "UpdatedCity", country: "UpdatedCountry")
            let weather = WeatherDetailInfoViewModel(iconID: "01d", description: "Sunny",
                                                     windSpeeped: "10 m/s", humidity: "60%",
                                                     temperature: "25°C")
            let updatedHistoricalInfo = HistoricalInfo( weatherInfo: weather, date: Date())
            let updatedCityInfo = CityInfo(city: updatedCity, history: [updatedHistoricalInfo]) // Use the new historicalInfo instance for the updated city
            
            self.synchronizationService.addCityInfo(updatedCityInfo) {
                // After updating city info, fetch city history
                self.synchronizationService.getCityHistory(for: updatedCity) { historicalInfoArray in
                    // Assert the fetched historicalInfoArray
                    XCTAssertNotNil(historicalInfoArray)
                    XCTAssertEqual(historicalInfoArray?.count, 2)
                    
                    expectation.fulfill()
                }
            }
        }
    }
}

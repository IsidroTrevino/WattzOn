//
//  AleTest.swift
//  AleTest
//
//  Created by Ale Peña on 01/12/24.
//

import XCTest
@testable import WattzOn

class HomeViewModelTests: XCTestCase {

    var homeViewModel: HomeViewModel!

    override func setUp() {
        super.setUp()
        homeViewModel = HomeViewModel()
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "TotalWatts")
        defaults.removeObject(forKey: "TotalAhorro")
        defaults.removeObject(forKey: "Periodos")
        defaults.removeObject(forKey: "Kwh")
        defaults.removeObject(forKey: "ReceiptUploaded")
    }

    override func tearDown() {
        homeViewModel = nil
        super.tearDown()
    }

    func testProcessTextWithEmptyData() {
        let sampleText = ""

        let expectation = XCTestExpectation(description: "Wait for processText to complete")
        homeViewModel.processText(sampleText)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(self.homeViewModel.periodos.isEmpty)
            XCTAssertTrue(self.homeViewModel.kwh.isEmpty)
            XCTAssertTrue(self.homeViewModel.importe.isEmpty)
            XCTAssertEqual(self.homeViewModel.consumoEnergetico.consumo, 0.0)
            XCTAssertEqual(self.homeViewModel.consumoEnergetico.ahorro, 0.0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testIncrementSavings() {
        homeViewModel.consumoEnergetico.ahorro = 10.0

        homeViewModel.incrementSavings(by: 5.0)

        XCTAssertEqual(homeViewModel.consumoEnergetico.ahorro, 15.0)
    }
}

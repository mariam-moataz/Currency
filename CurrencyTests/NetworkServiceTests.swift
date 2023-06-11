//
//  NetworkServiceTests.swift
//  NetworkServiceTests
//
//  Created by Mariam Moataz on 11/06/2023.
//

import XCTest
import RxSwift
@testable import Currency

final class NetworkServiceTests: XCTestCase {

    
    var networkService: NetworkService!
    var disposeBag: DisposeBag!
    
    override func setUp(){
        networkService = NetworkService.shared
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        networkService = nil
        disposeBag = nil
    }

    func testFetchData() {
        let expectation = self.expectation(description: "Fetch data expectation")
        let base = EndPoints.base
        let url = base.fullPath
        let currencyResponse = CurrencyResponse(success: true)
        
        networkService.fetchData(url: url )?.subscribe(onNext: { response in
           XCTAssertNotNil(response)
           XCTAssertEqual(response.success, currencyResponse.success)
           expectation.fulfill()
       }, onError: { error in
           XCTFail("Unexpected error: \(error)")
       })
       .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

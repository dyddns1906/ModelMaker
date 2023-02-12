//
//  ModelMakerTests.swift
//  ModelMakerTests
//
//  Created by Yongun Lim on 2023/02/05.
//

import XCTest
@testable import ModelMaker

final class ModelMakerTests: XCTestCase {

    var maker = ModelMaker()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
//        let jsonString = """
//        {
//            "name": "John Doe",
//            "age": 35,
//            "address": [{
//                "street": "1 Main Street",
//                "city": "San Francisco",
//                "state": "CA",
//                "zipCode": "94109"
//            },
//            {
//                "street": "2 Main Street",
//                "city": "Palermo",
//                "state": "rampedosa",
//                "zipCode": "10621"
//            }]
//        }
//        """
        
        maker = ModelMaker()
        
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGenerateSwiftModelFromJson() {
//        let expectedResult = """
//        struct Address: Codable {
//            let street: String
//            let city: String
//            let state: String
//            let zipCode: String
//        }
//
//        struct NewModel: Codable {
//            let name: String
//            let age: Int
//            let address: [Address]
//        }
//        """
        
        let expectedResult = """
        import Foundation
        
        struct NewModel: Codable {
            var address: Address
            var name: String
        }

        struct Address: Codable {
            var street: String
        }
        """
        
        let jsonString = """
        {
            "name": "John Doe",
            "address": [{
                "street": "1 Main Street",
            },
            {
                "street": "3 Main Street",
            }]
        }
        """
        
        let result = maker.generateSwiftModel(from: jsonString)
        XCTAssertEqual(result, expectedResult)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testTypeCheck() {
        var result = ""
        let value: Any = 1.25
        let dummy: Any = "\(value)"
        if dummy is Int {
            result = "Int"
        } else if dummy is Double {
            result = "Double"
        }
        
        print(result)
    }
}

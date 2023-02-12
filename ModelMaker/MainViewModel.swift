//
//  MainViewModel.swift
//  ModelMaker
//
//  Created by Yongun Lim on 2023/02/05.
//

import Foundation
import Combine

class MainViewModel {
    struct Input {
        var rootName: CurrentValueSubject<String, Never>
        var jsonString: CurrentValueSubject<String, Never>
        var actionConvert: PassthroughSubject<Void, Never>
    }
    struct Output {
        var result: CurrentValueSubject<String, Never>
    }
    
    var input: Input
    var output: Output
    
    let rootName = CurrentValueSubject<String, Never>("")
    let jsonString = CurrentValueSubject<String, Never>("")
    let actionConvert = PassthroughSubject<Void, Never>()
    let dictionary = CurrentValueSubject<Dictionary<String, Any?>?, Never>(nil)
    let result = CurrentValueSubject<String, Never>("")
    
    var storeBag = Set<AnyCancellable>()
    
    private var modelMaker = ModelMaker()
    
    init() {
        input = Input(rootName: rootName,
                      jsonString: jsonString,
                      actionConvert: actionConvert)
        output = Output(result: result)
        
        setupBinding()
    }
}

extension MainViewModel {
    private func setupBinding() {
        
        let testContent = """
    {
      "person": {
        "firstName": "John",
        "lastName": "Doe",
        "age": 30,
        "email": "john.doe@example.com",
        "address": {
          "street": "123 Main St",
          "city": "Anytown",
          "state": "CA",
          "zip": "12345"
        },
        "phoneNumbers": [
          {
            "type": "home",
            "number": "555-555-1234"
          },
          {
            "type": "work",
            "number": "555-555-5678"
          }
        ]
      }
    }
    """
        jsonString.send(testContent)
        
        rootName
            .filter { !$0.isEmpty }
            .sink { value in
                self.modelMaker.rootName = value
            }.store(in: &storeBag)
        
        let _ = actionConvert
            .withLatestFrom(jsonString)
            .map { self.modelMaker.generateSwiftModel(from: $0) }
            .sink { [weak self] value in
                self?.result.send(value)
            }.store(in: &storeBag)
    }
}


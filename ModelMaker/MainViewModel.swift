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
        var jsonString: CurrentValueSubject<String, Never>
    }
    struct Output {
        var result: CurrentValueSubject<String, Never>
    }
    
    var input: Input
    var output: Output
    
    let jsonString = CurrentValueSubject<String, Never>("")
    let dictionary = CurrentValueSubject<Dictionary<String, Any?>?, Never>(nil)
    let result = CurrentValueSubject<String, Never>("")
    
    
    init() {
        input = Input(jsonString: jsonString)
        output = Output(result: result)
        setupBinding()
    }
}

extension MainViewModel {
    private func setupBinding() {
        let _ = jsonString
            .map { $0.toDictionary() }
            .sink { [weak self] dic in
                self?.dictionary.send(dic)
            }
        
        let _ = dictionary
    }
}


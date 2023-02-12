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
        "manage": {
            "dummy": false,
            "reRegistered": false,
            "webReserved": false,
            "registDateTime": "2023-01-25T16:12:34",
            "firstAdvertisedDateTime": "2023-01-25T16:25:53",
            "modifyDateTime": "2023-01-30T14:25:01",
            "subscribeCount": 9.24,
            "viewCount": 52
        },
        "category": {
            "type": "CAR",
            "manufacturerCd": "001",
            "manufacturerName": "현대",
            "modelCd": "140",
            "modelName": "i30 (PD)",
            "gradeCd": "002",
            "gradeName": "1.6 터보",
            "yearMonth": "202301",
            "formYear": "2024",
            "domestic": true,
            "importType": null,
            "originPrice": 2208,
            "manufacturerEnglishName": "Hyundai",
            "modelGroupCd": "001",
            "modelGroupName": "i30",
            "modelGroupEnglishName": "i30",
            "gradeDetailCd": "004",
            "gradeDetailName": "스포츠 에센스 에디션",
            "jatoVehicleId": 810804820190701,
            "warranty": {
                "userDefined": false,
                "companyName": null,
                "bodyMonth": 36,
                "bodyMileage": 60000,
                "transmissionMonth": 60,
                "transmissionMileage": 100000
            }
        },
        "advertisement": {
            "type": "CAR",
            "price": 700,
            "status": "ADVERTISE",
            "warrantyStyleColor": null,
            "trust": [],
            "hotMark": [],
            "oneLineText": null,
            "salesStatus": null,
            "advertisementType": "NORMAL",
            "diagnosisCar": false
        },
        "contact": {
            "userId": "fjsekf1",
            "userType": "REPEAT",
            "no": "01033311303",
            "address": "서울 서대문구",
            "contactType": "MOBILE"
        },
        "spec": {
            "type": "CAR",
            "mileage": 10,
            "displacement": 1591,
            "transmissionName": "오토",
            "fuelCd": "001",
            "fuelName": "가솔린",
            "colorName": "검정색",
            "customColor": null,
            "bodyName": "준중형차"
        },
        "photos": [],
        "condition": {
            "accident": {
                "recordView": false
            },
            "inspection": {
                "formats": []
            },
            "seizing": {
                "seizingCount": null,
                "pledgeCount": null
            }
        },
        "partnership": {
            "brand": null,
            "testdrive": {
                "active": false
            }
        },
        "contents": {
            "text": "설명글은 인사말 / 차량상태 / 차주정보 등을 입력하시면 됩니다."
        },
        "vehicleType": "CAR",
        "vehicleId": 28683549,
        "vehicleNo": "33서4299"
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


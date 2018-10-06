//
//  DailyProgram.swift
//  ConditionController
//
//  Created by Vincenzo Olivito on 19/07/2018.
//  Copyright © 2018 vincenzoOlivito. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapperAdditions
import ObjectMapper_Realm

class DailyProgram: Object, Mappable{
    
    var daily_program =  List<Int>()

    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        //daily_program
    }
}

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

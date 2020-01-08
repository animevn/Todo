import Foundation

struct Tag:Codable, Equatable{
    
    var detail:String
    
    static func ==(lhs: Tag, rhs: Tag) -> Bool {
        return lhs.detail == rhs.detail
    }
}

struct Todo:Codable, Equatable{
    
    var detail:String
    var tag:Tag?
    var dueDate:Date
    var done:Bool
    var doneDate:Date?
    
    static func ==(lhs: Todo, rhs: Todo) -> Bool {
        return lhs.detail == rhs.detail && lhs.dueDate == lhs.dueDate && lhs.tag == rhs.tag
    }
}


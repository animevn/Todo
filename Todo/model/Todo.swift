import Foundation

struct Todo:Equatable, Codable{

    let detail:String
    let tag:Tag?
    let duedate:Date
    let done:Bool
    let donedate:Date?

    static func defaultDoneDate()->Date{
        Date().addingTimeInterval(24 * 60 * 60)
    }

    static func ==(lhs:Todo, rhs:Todo)->Bool{
        lhs.detail == rhs.detail && lhs.tag! == rhs.tag && lhs.duedate == rhs.duedate
    }
}

import Foundation

struct Tag:Codable, Equatable{
    let detail:String
}

struct Todo:Codable, Equatable{
    let detail:String
    let tag:Tag?
    let dueDate:Date
    let done:Bool
    let doneDate:Date?

    static func defaultDuedate()->Date{
        Date().addingTimeInterval(24 * 60 * 60)
    }
}

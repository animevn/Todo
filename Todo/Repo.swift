import Foundation

class Repo:Codable{
    
    var todoList = [Todo]()
    var tagList = [Tag?]()
    
    func defaultDueDate()->Date{
        return Date().addingTimeInterval(24*60*60)
    }
    
    func addTag(detail:String){
        if !detail.isEmpty{
            tagList = tagList + [Tag(detail: detail)]
        }
    }
    
    func addTodo(todo:Todo){
        todoList = todoList + [todo]
    }
    
    func deleteTodo(todo:Todo?){
        guard let todo = todo else {return}
        todoList = todoList.filter{$0 != todo}
    }
    
    func doneTodo(todo:Todo){
        deleteTodo(todo: todo)
        let newTodo = Todo(detail: todo.detail,
                           tag: todo.tag,
                           dueDate: todo.dueDate,
                           done: true,
                           doneDate: Date())
        addTodo(todo: newTodo)
    }
}

private let appSupportFolder:URL = {
    let url = FileManager().urls(for: FileManager.SearchPathDirectory.applicationSupportDirectory,
                                 in: FileManager.SearchPathDomainMask.userDomainMask).first!
    if !FileManager().fileExists(atPath: url.path){
        do{
            try FileManager().createDirectory(at: url, withIntermediateDirectories: false)
        }catch{
            print("create folder error")
        }
    }
    return url
}()

private let saveFile = appSupportFolder.appendingPathComponent("saves")

extension Repo{
    
    private func saveData(repo:Repo)->Data{
        var data = Data()
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            data = try encoder.encode(repo)
        }catch{
            print("encode error")
        }
        return data
    }
    
    func saveRepo(repo:Repo){
        let string = String(data: saveData(repo: repo), encoding: .utf8)
        do {
            try string?.write(to: saveFile, atomically: true, encoding: .utf8)
        }catch{
            print("save file error")
        }
    }
    
    private func loadData()->Data{
        var string = ""
        do{
            string = try String(contentsOf: saveFile, encoding: .utf8)
        }catch{
            print("load error")
        }
        print(string)
        return Data(string.utf8)
    }
  
    func loadRepo()->Repo{
        let data = loadData()
        var repo = Repo()
        do{
            repo = try JSONDecoder().decode(Repo.self, from: data)
        }catch{
            print("decode error")
        }
        return repo
    }
}





















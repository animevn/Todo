import Foundation

class TodoList:Codable{

    var todoList:[Todo] = [Todo]()
    var tagList:[Tag] = [Tag]()

    func newTag(string:String){
        if !string.isEmpty{
            tagList = tagList + [Tag(string: string)]
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
        let newTodo = Todo(
                detail: todo.detail,
                tag: todo.tag,
                duedate: todo.duedate,
                done: true,
                donedate: Date())
        addTodo(todo: newTodo)
    }

    func sortTodoList(){
        todoList = todoList.sorted{
            $0.duedate.compare($1.duedate) == ComparisonResult.orderedAscending
        }
    }

    private func decodeData(data:Data)->TodoList{
        var todoList = TodoList()
        do{
            try todoList = JSONDecoder().decode(TodoList.self, from: data)
        }catch let error{
            print(error)
        }
        return todoList
    }

    func loadSaveUserDefault()->TodoList{
        guard let data = UserDefaults.standard.data(forKey: "save") else {return TodoList()}
        return decodeData(data: data)
    }

    private func encodeData(todoList:TodoList)->Data{
        var data = Data()
        do{
            try data = JSONEncoder().encode(todoList)
        }catch let error{
            print(error)
        }
        return data
    }

    func saveToUserDefault(todoList:TodoList){
        let data = encodeData(todoList: todoList)
        UserDefaults.standard.set(data, forKey: "save")
    }

}

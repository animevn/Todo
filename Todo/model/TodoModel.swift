import Foundation

struct TodoModel:Codable{
    var todoList = [Todo]()
    var tagList = [Tag]()

    mutating func newTag(string:String){
        if !string.isEmpty {
            tagList = tagList + [Tag(detail: string)]
        }
    }

    mutating func addTodo(todo:Todo){
        todoList = todoList + [todo]
    }

    mutating func deleteTodo(todo:Todo?){
        guard let todo = todo else {return}
        todoList = todoList.filter{$0 != todo}
    }

    mutating func doneTodo(todo:Todo){
        deleteTodo(todo: todo)
        let newTodo = Todo(
                detail: todo.detail,
                tag: todo.tag,
                dueDate: todo.dueDate,
                done: true,
                doneDate: Date())
        addTodo(todo: newTodo)
    }

    mutating func sortTodoList(){
        todoList = todoList.sorted{
            $0.dueDate.compare($1.dueDate) == ComparisonResult.orderedAscending
        }
    }

    func save(todoModel:TodoModel){
        guard let data = try? JSONEncoder().encode(todoModel) else {return}
        UserDefaults.standard.set(data, forKey: "save")
    }

    func load()->TodoModel{
        guard let data = UserDefaults.standard.data(forKey: "save") else {return TodoModel()} 
        return (try? JSONDecoder().decode(TodoModel.self, from: data)) ?? TodoModel()
    }

}










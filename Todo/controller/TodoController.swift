import UIKit
import MGSwipeTableCell

class TodoController:UITableViewController{

    private var todoModel = TodoModel()
    private var todo:Todo?

    deinit {
        print("The class \(type(of: self)) was remove from memory")
    }

    private func load(){
        todoModel = todoModel.load()
    }

    private func sortTodoList(){
        todoModel.sortTodoList()
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sortTodoList()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
              let destination = segue.destination as? EditController else {return}
        destination.todoModel = todoModel
        destination.delegate = self
        if identifier == "new_todo"{
            destination.todo = nil
            destination.title = "New Todo"
        }else if identifier == "edit_todo"{
            destination.todo = todo
            destination.title = "Edit Todo"
        }
    }
}

extension TodoController{

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoModel.todoList.count
    }

    private func updateCell(cell:UITableViewCell, indexPath:IndexPath){
        let todo = todoModel.todoList[indexPath.row]
        cell.textLabel?.text = todo.detail
        let tag = todo.tag?.detail ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd - MMM HH:mm"
        let date = dateFormatter.string(from: todo.dueDate)
        cell.detailTextLabel?.text = "\(date) | \(tag)"
        cell.accessoryType = todo.done ? .checkmark : .none
    }

    private func createDeleteAndDoneButtons(cell:MGSwipeTableCell, todo:Todo){
        cell.rightButtons = [
            MGSwipeButton(title: "Delete", backgroundColor: .red, padding: 30, callback: {
                [weak self] _ in
                self?.todoModel.deleteTodo(todo: todo)
                self?.todoModel.save(todoModel: self!.todoModel)
                self?.sortTodoList()
                return true
            })
        ]
        cell.rightExpansion.buttonIndex = 0

        cell.leftButtons = [
            MGSwipeButton(title: "Done", backgroundColor: .green, padding: 30, callback: {
                [weak self] _ in
                self?.todoModel.doneTodo(todo: todo)
                self?.todoModel.save(todoModel: self!.todoModel)
                self?.sortTodoList()
                return true
            })
        ]
        cell.leftExpansion.buttonIndex = 0
    }

    override func tableView(_ tableView: UITableView,
                                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todo", 
                for: indexPath) as! MGSwipeTableCell
        updateCell(cell: cell, indexPath: indexPath)
        createDeleteAndDoneButtons(cell: cell, todo: todoModel.todoList[indexPath.row])
        return cell
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todo = todoModel.todoList[indexPath.row]
        performSegue(withIdentifier: "edit_todo", sender: self)
    }
}

extension TodoController:EditControllerDelegate{
    func onUpdateTodo(todoModel: TodoModel) {
        self.todoModel = todoModel
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }


}














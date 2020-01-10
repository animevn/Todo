import UIKit
import MGSwipeTableCell

class TodoController:UITableViewController{

    private var todoList:TodoList = TodoList()
    private var todo:Todo?

    deinit {
        print("The class \(type(of: self)) was remove from memory")
    }

    private func loadTodoList(){
        todoList = todoList.loadSaveUserDefault()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTodoList()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoList.todoList.count
    }

    private func updateCell(cell:UITableViewCell, indexPath:IndexPath){
        let todo:Todo = todoList.todoList[indexPath.row]
        let tag = todo.tag?.string ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd - MMM HH:mm"
        let date = dateFormatter.string(from: todo.duedate)
        cell.textLabel?.text = todo.detail
        cell.detailTextLabel?.text = "\(date) | \(tag)"
        cell.accessoryType = todo.done ? .checkmark : .none
    }

    private func createDeleteAndDoneButtons(cell:MGSwipeTableCell, todo:Todo){
        cell.rightButtons = [
            MGSwipeButton(title: "Delete", backgroundColor: UIColor.red, padding: 30, callback: {
                [weak self] _ in
                self?.todoList.deleteTodo(todo: todo)
                self?.todoList.saveToUserDefault(todoList: self!.todoList)
                self?.tableView.reloadData()
                return true
            })
        ]
        cell.rightExpansion.buttonIndex = 0
        cell.leftButtons = [
            MGSwipeButton(title: "Done", backgroundColor: UIColor.cyan, padding: 30, callback: {
                [weak self] _ in
                self?.todoList.doneTodo(todo: todo)
                self?.todoList.saveToUserDefault(todoList: self!.todoList)
                self?.tableView.reloadData()
                return true
            })
        ]
        cell.leftExpansion.buttonIndex = 0
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
                withIdentifier: "todo", for: indexPath) as! MGSwipeTableCell
        updateCell(cell: cell, indexPath: indexPath)
        createDeleteAndDoneButtons(cell: cell, todo: todoList.todoList[indexPath.row])
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
              let destination = segue.destination as? EditController else {return}
        destination.todoList = todoList
        if identifier == "new"{
            destination.todo = nil
            destination.title = "New Todo"
        }else if identifier == "edit"{
            destination.todo = sender as? Todo
            destination.title = "Edit Todo"
        }
    }

    @IBAction func addTodo(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "new", sender: sender)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todo = todoList.todoList[indexPath.row]
        performSegue(withIdentifier: "edit", sender: todo)
    }
}

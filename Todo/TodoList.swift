 import UIKit
import MGSwipeTableCell

class TodoList: UITableViewController{

    private var repo:Repo!
    private var todoList = [Todo]()
    private var todo:Todo?
    
    private func start(){
        repo = Repo()
        repo = repo.loadRepo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Todo List"
        start()
    }
    
    private func sortTodoListByDueDate(){
        todoList = repo.todoList
        todoList = todoList.sorted{
            $0.dueDate.compare($1.dueDate) == ComparisonResult.orderedAscending
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sortTodoListByDueDate()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repo.todoList.count
    }
    
    private func updateRowOfList(cell:UITableViewCell, todo:Todo){
        cell.textLabel?.text = todo.detail
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh a dd-MMM-YY"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        let date = dateFormatter.string(from: todo.dueDate)
        cell.detailTextLabel?.text = "\(date) | \(todo.tag?.detail ?? "")"
        cell.accessoryType = todo.done ? .checkmark : .none
    }
    
    private func removeTodo(todo:Todo?){
        repo.deleteTodo(todo: todo)
        sortTodoListByDueDate()
        repo.saveRepo(repo: repo)
    }
    
    private func doneTodo(todo:Todo){
        repo.doneTodo(todo: todo)
        sortTodoListByDueDate()
        repo.saveRepo(repo: repo)
    }
    
    private func createButton(cell:MGSwipeTableCell, todo:Todo){
        cell.rightButtons = [
            MGSwipeButton(title: "Delete", backgroundColor: .red, padding: 30, callback: {
                [weak self] sender in
                self?.removeTodo(todo: todo)
                return true
            })
        ]
        cell.rightExpansion.buttonIndex = 0
        
        cell.leftButtons = [
            MGSwipeButton(title: "Done", backgroundColor: .green, padding: 30, callback: {
                [weak self] sender in
                self?.doneTodo(todo: todo)
                return true
            })
        ]
        cell.leftExpansion.buttonIndex = 0
    }
    
    override func tableView(_ tableView:UITableView,
                            cellForRowAt indexPath:IndexPath)->UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todo",
                                                 for: indexPath) as! MGSwipeTableCell
        updateRowOfList(cell: cell, todo: todoList[indexPath.row])
        createButton(cell: cell, todo: todoList[indexPath.row])
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
                let destination = segue.destination as? TodoDetail else {return}
        
        destination.repo = repo
        
        if identifier == "edit"{
            destination.title = "Edit Todo"
            destination.todo = todo
            todo = nil
        }else if identifier == "new"{
            destination.title = "New Todo"
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todo = todoList[indexPath.row]
        performSegue(withIdentifier: "edit", sender: self)
    }
    
    @IBAction func newTodo(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "new", sender: self)
    }
}


import UIKit

class EditController:UITableViewController{
    
    @IBOutlet weak var tfDetail: UITextField!
    @IBOutlet weak var lbTag: UILabel!
    @IBOutlet weak var lbDuedate: UILabel!
    @IBOutlet weak var dpDate: UIDatePicker!

    var todoList:TodoList!
    var todo:Todo?
    private var tag:Tag?
    private var duedate:Date!

    deinit {
        print("The class \(type(of: self)) was remove from memory")
    }

    private func initVariables(){
        if let todo = todo{
            tag = todo.tag
            duedate = todo.duedate
        }else {
            duedate = Todo.defaultDueDate()
        }
    }

    private func updateDetail(){
        tfDetail.text = "\(todo?.detail ?? "")"
    }

    private func updateTag() {
        lbTag.text = "\(tag?.string ?? "")"
    }

    private func updateDueDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm dd-MMM-yy"
        let date = dateFormatter.string(from: duedate)
        lbDuedate.text = "Duedate: \(date)"
    }

    @objc private func datePickerObserver(){
        duedate = dpDate.date
        updateDueDate()
    }

    private func updateDatePicker(){
        dpDate.datePickerMode = UIDatePicker.Mode.dateAndTime
        dpDate.minimumDate = Date()
        dpDate.date = duedate
        dpDate.addTarget(self, action: #selector(datePickerObserver), for: .valueChanged)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initVariables()
        updateDetail()
        updateTag()
        updateDueDate()
        updateDatePicker()
    }

    private func saveTodoAndReturn(){
        if let detail = tfDetail.text, let duedate = duedate, !detail.isEmpty{
            todoList.deleteTodo(todo: todo)
            todo = Todo(detail: detail, tag: tag, duedate: duedate, done: false, donedate: nil)
            todoList.addTodo(todo: todo!)
            todoList.saveToUserDefault(todoList: todoList)
        }
        navigationController?.popViewController(animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? TagController else {return}
        destination.title = "Tag List"
        destination.todoList = todoList
        destination.tagListener = {[weak self] tag in
            self?.tag = tag
            self?.lbTag.text = "\(tag.string)"
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 1:
            performSegue(withIdentifier: "tag", sender: nil)   
        case 3:
            saveTodoAndReturn()
        default:
            return
        }
    }
}

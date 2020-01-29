import UIKit

protocol EditControllerDelegate:class{
    func onUpdateTodo(todoModel:TodoModel)
}

class EditController:UITableViewController{
    @IBOutlet weak var tfDetail: UITextField!
    @IBOutlet weak var lbTag: UILabel!
    @IBOutlet weak var lbDuedate: UILabel!
    @IBOutlet weak var dpDueDate: UIDatePicker!
    
    var todoModel:TodoModel!
    var todo:Todo?
    var tag:Tag?
    var dueDate:Date!
    weak var delegate:EditControllerDelegate?

    deinit {
        print("The class \(type(of: self)) was remove from memory")
    }

    private func handleTodo(){
        if let todo = todo{
            tag = todo.tag
            dueDate = todo.dueDate
        }else {
            dueDate = Todo.defaultDuedate()
        }
    }

    private func updateDatePicker(){
        dpDueDate.minimumDate = Date()
        dpDueDate.datePickerMode = .dateAndTime
        dpDueDate.date = dueDate
    }

    private func updateUI(){
        tfDetail.text = todo?.detail ?? ""
        lbTag.text = tag?.detail ?? ""
    }

    private func updateDueDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm dd-MMM-YY"
        let date = dateFormatter.string(from: dueDate)
        lbDuedate.text = "Due date: \(date)"
    }

    @IBAction func onDatePickerChanged(_ sender: UIDatePicker) {
        dueDate = sender.date
        updateDueDate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        handleTodo()
        updateDatePicker()
        updateUI()
        updateDueDate()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? TagController,
              segue.identifier == "edit_tag" else {return}
        destination.title = "Tag List"
        destination.todoModel = todoModel
        destination.returnData = {[weak self] tag, todoModel in
            self?.todoModel = todoModel
            self?.tag = tag
            self?.lbTag.text = tag.detail
        }
    }
}

extension EditController{

    private func saveAndReturn(){
        if let detail = tfDetail.text, !detail.isEmpty{
            todoModel.deleteTodo(todo: todo)
            let newTodo = Todo(
                    detail: detail,
                    tag: tag,
                    dueDate: dueDate,
                    done: false,
                    doneDate: nil)
            todoModel.addTodo(todo: newTodo)
            todoModel.save(todoModel: todoModel)
            delegate?.onUpdateTodo(todoModel: todoModel)
        }
    }
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 1:
            performSegue(withIdentifier: "edit_tag", sender: self)
            break
        case 3:
            saveAndReturn()
            break
        default:
            return
        }
    }
}











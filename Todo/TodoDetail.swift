import UIKit

class TodoDetail:UITableViewController{
    
    var todo:Todo?
    var repo:Repo!
    private var dueDate:Date!
    private var tag:Tag?
    
    @IBOutlet weak var tfDetail: UITextField!
    @IBOutlet weak var lbTag: UILabel!
    @IBOutlet weak var lbDueDate: UILabel!
    @IBOutlet weak var dpDatePicker: UIDatePicker!
    
    private func setupDueDate(){
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "HH:mm dd-MMM-YY"
        let date = dateFormater.string(from: dueDate)
        lbDueDate.text = "Due Date: \(date)"
    }
    
    private func setup(){
        if let todo = todo{
            tfDetail.text = todo.detail
            tag = todo.tag
            lbTag.text = "Tag: \(tag?.detail ?? "")"
            dueDate = todo.dueDate
            setupDueDate()
            tfDetail.becomeFirstResponder()
        }else {
            dueDate = repo.defaultDueDate()
            tag = nil
            setupDueDate()
            tfDetail.becomeFirstResponder()
        }
    }
    
    private func setupDatePicker(){
        dpDatePicker.datePickerMode = .dateAndTime
        dpDatePicker.minimumDate = Date()
        dpDatePicker.addTarget(self, action: #selector(datePickerListener), for: .valueChanged)
        dpDatePicker.date = dueDate
    }
    
    @objc private func datePickerListener(){
        dueDate = dpDatePicker.date
        setupDueDate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupDatePicker()
    }
    
    private func saveTodo(){
        if let detail = tfDetail.text, let dueDate = dueDate, !detail.isEmpty{
            repo.deleteTodo(todo: todo)
            let newTodo = Todo(detail: detail,
                               tag: tag,
                               dueDate: dueDate,
                               done: false,
                               doneDate: nil)
            repo.addTodo(todo: newTodo)
        }
        repo.saveRepo(repo: repo)
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? TagList else {return}
        destination.repo = repo
        destination.returnTag = { tag in
            self.tag = tag
            self.lbTag.text = tag.detail
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 1:
            performSegue(withIdentifier: "tag", sender: self)
        case 3:
            saveTodo()
        default:
            return
        }
    }
}

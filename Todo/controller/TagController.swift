import UIKit

class TagController:UITableViewController{

    var todoModel:TodoModel!
    var tag:Tag?
    var returnData:((Tag, TodoModel)->Void)!

    deinit {
        print("The class \(type(of: self)) was remove from memory")
    }

    private func alertNewTag(){
        let alert = UIAlertController(
                title: "Create New Tag", 
                message: "Enter a name for Tag", 
                preferredStyle: .alert)
        let actionOK = UIAlertAction(
                title: "OK",
                style: .default,
                handler: {[weak self] _ in
                    let textField = alert.textFields?.first
                    if let text = textField?.text, !text.isEmpty{
                        self?.todoModel.newTag(string: text)
                        self?.todoModel.save(todoModel: self!.todoModel)
                    }
                    self?.tableView.reloadData()
                })
        let actionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(actionOK)
        alert.addAction(actionCancel)
        alert.addTextField(configurationHandler: nil)
        present(alert, animated: true)
    }

    @IBAction func onButtonAddPressed(_ sender: UIBarButtonItem) {
        alertNewTag()
    }
    
}

extension TagController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoModel.tagList.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tag", for: indexPath)
        cell.textLabel?.text = todoModel.tagList[indexPath.row].detail
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tag = todoModel.tagList[indexPath.row]
        returnData(tag!, todoModel)
        navigationController?.popViewController(animated: true)
    }
}

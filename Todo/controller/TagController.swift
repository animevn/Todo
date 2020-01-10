import UIKit

class TagController:UITableViewController{

    var todoList:TodoList!
    var tag:Tag?
    var tagListener:((Tag)->Void)!

    deinit {
        print("The class \(type(of: self)) was remove from memory")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoList.tagList.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "tag", for: indexPath)
        cell.textLabel?.text = todoList.tagList[indexPath.row].string
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tag = todoList.tagList[indexPath.row]
        tagListener(tag!)
        navigationController?.popViewController(animated: true)
    }

    private func alertNewTag(){
        let alert = UIAlertController(
                title: "Create new tag",
                message: "Enter a name for tag, do not leave empty",
                preferredStyle: .alert)

        let actionOk = UIAlertAction(title: "Ok", style: .default, handler: {
            [weak self] _ in
            let textField = alert.textFields?.first!
            if let text = textField?.text, !text.isEmpty{
                self?.todoList.newTag(string: text)
                self?.todoList.saveToUserDefault(todoList: self!.todoList)
            }
            self?.tableView.reloadData()
        })
        let actionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(actionOk)
        alert.addAction(actionCancel)
        alert.addTextField(configurationHandler:nil)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func addTag(_ sender: UIBarButtonItem) {
        alertNewTag()
    }


    
    
}

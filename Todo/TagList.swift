import UIKit

class TagList:UITableViewController{
    
    var repo:Repo!
    var tag:Tag?
    var returnTag:((Tag)->Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repo.tagList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tag", for: indexPath)
        cell.textLabel?.text = repo.tagList[indexPath.row]?.detail ?? ""
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        returnTag(repo.tagList[indexPath.row]!)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func newTag(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Tag",
                                      message: "Do not leave blank",
                                      preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default, handler: {action in
            let textField = alert.textFields?.first
            if let text = textField?.text{
                self.repo.addTag(detail: text)
                self.repo.saveRepo(repo: self.repo)
            }
            self.tableView.reloadData()
        })
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(actionOK)
        alert.addAction(actionCancel)
        alert.addTextField(configurationHandler: nil)
        present(alert, animated: true, completion: nil)
    }
}











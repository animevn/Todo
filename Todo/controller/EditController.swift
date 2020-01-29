import UIKit

class EditController:UITableViewController{
    @IBOutlet weak var tfDetail: UITextField!
    @IBOutlet weak var lbTag: UILabel!
    @IBOutlet weak var lbDuedate: UILabel!
    @IBOutlet weak var dpDuedate: UIDatePicker!
    
    @IBAction func onDatePickerChanged(_ sender: UIDatePicker) {
    }
}

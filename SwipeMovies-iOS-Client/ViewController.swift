import UIKit

class ViewController: UIViewController {
    
    let userId = 0
    
    @IBOutlet weak var joinGroupText: UITextField!
    @IBOutlet weak var createGroupText: UITextField!
    
    @IBAction func joinGroupButton(_ sender: Any) {
        if let idString = joinGroupText.text, let id = Int(idString) {
            SwipeMoviesApi.getInstance().joinGroup(id, {
                DispatchQueue.main.async {
                    self.joinGroupText.text = ""
                    self.performSegue(withIdentifier: "group", sender: self)
                }
            })
        }
    }
    
    @IBAction func createGroupButton(_ sender: Any) {
        if let name = createGroupText.text {
            SwipeMoviesApi.getInstance().createGroup(name, { (_ group: Group) -> Void in
                SwipeMoviesApi.getInstance().joinGroup(group.id, {
                    DispatchQueue.main.async {
                        self.createGroupText.text = ""
                        self.performSegue(withIdentifier: "group", sender: self)
                    }
                })
            })
        }
    }
    
    @IBAction func showSwipe(_ sender: Any) {
        performSegue(withIdentifier: "swipe", sender: self)
    }
    
    @IBAction func showGroups(_ sender: Any) {
        performSegue(withIdentifier: "group", sender: self)
    }
    
    @IBAction func showMatches(_ sender: Any) {
        performSegue(withIdentifier: "match", sender: self)
    }
    
    @IBAction func tap(_ sender: Any) {
        view.endEditing(true)
        self.view.frame.origin.y = 0
    }
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboadDidShow(keyBoardShowNotification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    @objc func keyboadDidShow(keyBoardShowNotification notification: Notification) {
        if let userInfo = notification.userInfo, let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.frame.origin.y -= keyboardRectangle.height
            })
        }
    }
    
}

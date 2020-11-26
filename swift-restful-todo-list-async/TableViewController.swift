import UIKit

class TableViewController: UITableViewController {
    
    let queue = DispatchQueue(label: "queue1")
    var model = Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queue.async {
            self.download()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.todos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> TableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todo", for: indexPath) as! TableViewCell
        let todo = model.todos[indexPath.row]
        
        cell.title.text = todo.title
        cell.completed.isOn = todo.completed

        return cell
    }
    
    func download() {
        let todoModel = Model()
        
        if let url = URL(string: "http://localhost:3000/todos") {
            if let data = try? Data(contentsOf: url) {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []), let array = json as? [Any] {
                    for obj in array {
                        if let dict = obj as? [String: Any] {
                            let todo = ToDo()
                            
                            todo.title = dict["title"] as! String
                            todo.id = dict["id"] as! Int
                            todo.userId = dict["userId"] as! Int
                            todo.completed = dict["completed"] as! Bool
                            
                            todoModel.todos.append(todo)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.model = todoModel
                        self.tableView.reloadData()
                    }
                }
            } else {
                print("Download failed")
            }
        } else {
            print("Cannot resolve URL")
        }
    }
}



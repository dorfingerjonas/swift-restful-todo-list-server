import UIKit

class TableViewController: UITableViewController {
    
    var model = Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.download()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.todos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todo", for: indexPath)
        
        cell.textLabel?.text = model.todos[indexPath.row].title
        cell.detailTextLabel?.text = model.todos[indexPath.row].completed ? "Completed" : "Not completed"

        return cell
    }
    
    func download() {
        let model = Model()
        
        if let url = URL(string: "https://jsonplaceholder.typicode.com/todos") {
            if let data = try? Data(contentsOf: url) {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []), let array = json as? [Any] {
                    for obj in array {
                        if let dict = obj as? [String: Any] {
                            let todo = ToDo()
                            
                            todo.title = dict["title"] as! String
                            todo.id = dict["id"] as! Int
                            todo.userId = dict["userId"] as! Int
                            todo.completed = dict["completed"] as! Bool
                            
                            model.todos.append(todo)
                        }
                    }
                    
                    self.model = model
                }
            } else {
                print("Download failed")
            }
        } else {
            print("Cannot resolve URL")
        }
    }
}

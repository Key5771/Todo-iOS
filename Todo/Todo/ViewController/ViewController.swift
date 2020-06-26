//
//  ViewController.swift
//  Todo
//
//  Created by 김기현 on 2020/06/25.
//  Copyright © 2020 김기현. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    private let refreshControl = UIRefreshControl()
    
    var todo: [Todo] = []
    var setTodo: [Todo] = []
    var post = Todo(id: nil, text: nil, isDone: false)
    var text: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        getTodo()
    }
    
    @objc func refresh() {
        getTodo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    func getTodo() {
        NetworkRequest.shared.responseTodo(api: .getInfo, method: .get) { (response: Data) in
            self.todo.append(contentsOf: response.data)
            self.setTodo = Array(Set(self.todo))
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }

    @IBAction func addClick(_ sender: Any) {
        let alertController = UIAlertController(title: "Todo 추가", message: "할 일을 추가해주세요", preferredStyle: .alert)

        alertController.addTextField { (textField) in
            textField.placeholder = "할 일을 입력해주세요!"
        }

        let okButton = UIAlertAction(title: "확인", style: .default) { (result) in
            self.post.text = alertController.textFields?[0].text
            
            NetworkRequest.shared.requestTodo(api: .getInfo, method: .post, parameters: self.post) { (err) in
                if let err = err {
                    print("error:\(err)")
                }
            }

            self.tableView.reloadData()
        }

        let cancelButton = UIAlertAction(title: "취소", style: .destructive, handler: nil)

        alertController.addAction(cancelButton)
        alertController.addAction(okButton)

        self.present(alertController, animated: true, completion: nil)
    }
    

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setTodo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListTableViewCell
        
        cell.contentLabel.text = setTodo[indexPath.row].text
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            NetworkRequest.shared.deleteTodo(api: .delete, method: .delete, parameters: self.setTodo[indexPath.row].id!) { (err) in
                if let err = err {
                    print("Error getting DELETE: \(err)")
                }
            }
            
            self.setTodo.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}


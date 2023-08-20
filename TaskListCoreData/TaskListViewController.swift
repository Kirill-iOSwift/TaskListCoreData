//
//  ViewController.swift
//  TaskListCoreData
//
//  Created by Кирилл on 20.08.2023.
//

import UIKit
import CoreData

protocol ITaskViweControllerDeligate {
    func reloadData()
}

class TaskListViewController: UITableViewController {
    
    private let viweContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let cellID = "task"
    private var taskList: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        fetchData()
    }
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearense = UINavigationBarAppearance()
        navBarAppearense.backgroundColor = UIColor(named: "MilkBlue")
        
        navBarAppearense.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearense.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearense
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearense
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc
    private func addNewTask() {
        let newTaskVC = NewTaskViewController()
        newTaskVC.deligate = self
        present(newTaskVC, animated: true)
        
    }
    
    private func fetchData() {
        let fetchRequest = Task.fetchRequest()
        do {
            taskList = try viweContext.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
}
//MARK: - UITavleView Data Sourse

extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
}

//MARK: - TaskViweControllerDeligatefe

extension TaskListViewController: ITaskViweControllerDeligate {
    func reloadData() {
        fetchData()
        tableView.reloadData()
    }
    
    
}


//
//  ViewController.swift
//  TaskListCoreData
//
//  Created by Кирилл on 20.08.2023.
//

import UIKit

final class TaskListViewController: UITableViewController {
    
    //MARK: - Private properties
    
    private let cellID = "task"
    private var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        fetchData()
    }
    
    //MARK: - Private methods
    
    ///Метод настройки NavigationBar
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
    
    ///Метод добавления новой задачи
    @objc
    private func addNewTask() {
        showAlert()
    }
    
    ///Метод получения данных из СoreData
    private func fetchData() {
        StorageManager.shared.fetchData { [unowned self] result in
            switch result {
            case .success(let tasks):
                self.tasks = tasks
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    ///Метод сохранения задачи в CoreData
    private func save(taskName: String){
        StorageManager.shared.create(taskName) { [unowned self] task in
            tasks.append(task)
            tableView.insertRows(at: [IndexPath(row: self.tasks.count - 1, section: 0)], with: .automatic)
        }
    }
//
//    ///Метод изменения title задачи
//    private func updateTask(in indexPath: IndexPath,newTitle task: String) {
//        tasks[indexPath.row].title = task
//        tableView.reloadRows(at: [indexPath], with: .automatic)
//        changeData()
//    }
//
//    ///Метод удаления задачи из CoreData
//    private func deleteTask(task: Task) {
//        viweContext.delete(task)
//        changeData()
//    }
//
//    ///Метод проверки и сохранения изменений в CoreData
//    private func changeData() {
//        if viweContext.hasChanges {
//            do{
//                try viweContext.save()
//            } catch let error {
//                print(error.localizedDescription)
//            }
//        }
//    }
}

//MARK: - Table View Data Sourse

extension TaskListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = tasks[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
    
    //MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = tasks[indexPath.row]
        showAlert(task: task) {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            StorageManager.shared.delete(task)
        }
    }
}

//MARK: - AlertController

private extension TaskListViewController {
    
    func showAlert(task: Task? = nil, completion: (() -> Void)? = nil) {
        let title = task != nil ? "Update Task" : "New Task"
        let alert = UIAlertController.createAlertController(withTitle: title)
        
        alert.action(task: task) { [weak self] taskName in
            if let task = task, let completion = completion {
                StorageManager.shared.update(task, newName: taskName)
                completion()
            } else {
                self?.save(taskName: taskName)
            }
        }
        present(alert, animated: true)
    }
}

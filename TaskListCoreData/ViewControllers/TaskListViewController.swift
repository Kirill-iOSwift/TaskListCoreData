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
    private var taskList: [Task] = []
    private let viweContext = StorageManager.shared.viewContext
    
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
        showAlertNewTask(withTitle: "New Task", andMessage: "Whot do you want to do")
    }
    
    ///Метод получения данных из СoreData
    private func fetchData() {
        let fetchRequest = Task.fetchRequest()
        
        do {
            taskList = try viweContext.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    ///Метод сохранения задачи в CoreData
    private func save(_ taskName: String){
        let task = Task(context: viweContext)
        task.title = taskName
        taskList.append(task)
        
        let cellIndex = IndexPath(row: taskList.count - 1, section: 0)
        tableView.insertRows(at: [cellIndex], with: .automatic)
        changeData()
    }
    
    ///Метод изменения title задачи
    private func updateTask(in indexPath: IndexPath,newTitle task: String) {
        taskList[indexPath.row].title = task
        tableView.reloadRows(at: [indexPath], with: .automatic)
        changeData()
    }
    
    ///Метод удаления задачи из CoreData
    private func deleteTask(task: Task) {
        viweContext.delete(task)
        changeData()
    }
    
    ///Метод проверки и сохранения изменений в CoreData
    private func changeData() {
        if viweContext.hasChanges {
            do{
                try viweContext.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - Table View Data Sourse

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
    
    //MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showAlertChangeTask(withTitle: "Updata Task", andMessage: "What do you want to do?", in: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = taskList[indexPath.row]
            deleteTask(task: task)
            taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

//MARK: - AlertController

private extension TaskListViewController {
    
    func showAlertNewTask(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            save(task)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.placeholder = "New Task"
        }
        present(alert, animated: true)
    }
    
    func showAlertChangeTask(withTitle title: String, andMessage message: String, in indexPath: IndexPath) {
        let task = taskList[indexPath.row]
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] _ in
            guard let task = alert.textFields?.first?.text else { return }
            updateTask(in: indexPath, newTitle: task)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.text = task.title
        }
        present(alert, animated: true)
    }
}

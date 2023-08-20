//
//  NewTaskViewController.swift
//  TaskListCoreData
//
//  Created by Кирилл on 20.08.2023.
//

import UIKit
import CoreData

class NewTaskViewController: UIViewController {
    
    var deligate: ITaskViweControllerDeligate!
    
    private let viweContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private lazy var taskTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "New Task"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        createButtom(
            withTitle: "Save Task",
            andColor: UIColor(named: "MilkBlue") ?? .systemBlue,
            action: UIAction { [unowned self] _ in
            save()
            }
        )
    }()
    
    private lazy var cancelButton: UIButton = {
        createButtom(
            withTitle: "Cancel",
            andColor: UIColor(named: "MilkRed") ?? .systemRed,
            action: UIAction { [unowned self] _ in dismiss(animated: true) }
        )
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews(taskTextField, saveButton, cancelButton)
        setConstraints()
        
        
    }
    
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    private func setConstraints() {
        NSLayoutConstraint.activate([
            taskTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            taskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            taskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
            
        ])
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
            
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
            
        ])
        
    }
    
    private func createButtom(withTitle title: String, andColor color: UIColor, action: UIAction) -> UIButton {
        var attributes = AttributeContainer()
        attributes.font = UIFont.boldSystemFont(ofSize: 18)
        
        var buttunConfiguration = UIButton.Configuration.filled()
        buttunConfiguration.baseBackgroundColor = color
        buttunConfiguration.attributedTitle = AttributedString(title, attributes: attributes)
        let button = UIButton(configuration: buttunConfiguration, primaryAction: action)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button


    }
    
    private func save() {
        let task = Task(context: viweContext)
        task.title = taskTextField.text
        
        if viweContext.hasChanges {
            do{
                try viweContext.save()
            } catch let error {
                print(error.localizedDescription)
            }
            
        }
        deligate.reloadData()
        dismiss(animated: true)
        
    }
}

//
//  AlertController.swift
//  TaskListCoreData
//
//  Created by Кирилл on 26.08.2023.
//

import UIKit

extension UIAlertController {
    
    static func createAlertController(withTitle title: String) -> UIAlertController {
        UIAlertController(title: title, message: "What do you want to do?", preferredStyle: .alert)
    }
    
    func action(task: Task?, completion: @escaping (String) -> Void) {
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let newValue = self?.textFields?.first?.text else { return }
            guard !newValue.isEmpty else { return }
            completion(newValue)
        }
        
        let canselAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(canselAction)
        addTextField { textField in
            textField.placeholder = "New Task"
            textField.text = task?.title
        }
    }
}

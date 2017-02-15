//
//  DetailsVC.swift
//  TaskTracker Offline
//
//  Created by Serhii Pianykh on 2017-02-14.
//  Copyright © 2017 Serhii Pianykh. All rights reserved.
//

import UIKit

class DetailsVC: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var doneSwitch: UISwitch!
    @IBOutlet weak var detailsField: UITextView!
    
    var task: Task?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if task != nil {
            loadData()
        }

    }

    @IBAction func saveBtn(_ sender: UIButton) {
        var task: Task!
        
        task = self.task
        
        if let title = titleField.text {
            task.title = title
        }
        if let details = detailsField.text {
            task.details = details
        }
        task.done=doneSwitch.isOn
        
        ad.saveContext()
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func loadData() {
        if let task = task {
            titleField.text = task.title
            detailsField.text = task.details
            if task.done {
                doneSwitch.isOn = true
            } else {
                doneSwitch.isOn = false
            }
        }
    }

    
}

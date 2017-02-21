//
//  DetailsVC.swift
//  TaskTracker Offline
//  300907406
//  Created by Serhii Pianykh on 2017-02-14.
//  Copyright © 2017 Serhii Pianykh. All rights reserved.
//
//  ViewController with detailed information about selected task. Can be edited

import UIKit

class DetailsVC: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var doneSwitch: UISwitch!
    @IBOutlet weak var detailsField: UITextView!
    
    var task: Task?
    
    //load passed task parameters to view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if task != nil {
            loadData()
        }

    }

    //updating CoreData and going back to ListVC
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
    
    //load passed task parameters
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

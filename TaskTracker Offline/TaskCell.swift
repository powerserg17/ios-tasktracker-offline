//
//  TaskCell.swift
//  TaskTracker Offline
//
//  Created by Serhii Pianykh on 2017-02-14.
//  Copyright © 2017 Serhii Pianykh. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    
    let imgChecked = UIImage(named: "checkbox-checked")
    let imgUnchecked = UIImage(named: "checkbox-unchecked")

    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addTextField: UITextField!
    
    func configureCell(task: Task) {
        titleLabel.text = task.title
        if task.done {
            doneBtn.setImage(imgChecked, for: .normal)
        } else {
            doneBtn.setImage(imgUnchecked, for: .normal)
        }
    }

}

//
//  TaskCell.swift
//  TaskTracker Offline
//
//  Created by Serhii Pianykh on 2017-02-14.
//  Copyright © 2017 Serhii Pianykh. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell, UITextFieldDelegate {
    
    let imgChecked = UIImage(named: "checkbox-checked")
    let imgUnchecked = UIImage(named: "checkbox-unchecked")
    
    var doneTapAction: ((UITableViewCell) -> Void)?
    var saveTapAction: ((UITableViewCell) -> Void)?
    var cancelTapAction: ((UITableViewCell) -> Void)?

    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addTextField: UITextField!
    
    func configureCell(task: Task) {
        if (task.creating) {
            creatingMode()
        } else {
            titleLabel.text = task.title
            if task.done {
                doneBtn.setImage(imgChecked, for: .normal)
                let attributedString = NSMutableAttributedString(string: titleLabel.text!)
                attributedString.addAttribute(NSStrikethroughStyleAttributeName, value: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue), range: NSMakeRange(0, attributedString.length))
                titleLabel.attributedText=attributedString
                titleLabel.textColor = UIColor.lightGray

            } else {
                doneBtn.setImage(imgUnchecked, for: .normal)
                titleLabel.textColor = UIColor.white
            }
        }
    }
    
    func updateStatus(task: Task) {
        if task.done {
            task.done = false
            
        } else {
            task.done = true
        }
        ad.saveContext()
    }
    
    func creatingMode() {
        titleLabel.isHidden = true
        doneBtn.isHidden = true
        addTextField.isHidden = false
        addTextField.text = ""
        saveBtn.isHidden = false
        cancelBtn.isHidden = false
        addTextField.becomeFirstResponder()
    }
    
    func viewMode() {
        titleLabel.isHidden = false
        doneBtn.isHidden = false
        addTextField.isHidden = true
        addTextField.text = ""
        saveBtn.isHidden = true
        cancelBtn.isHidden = true
        addTextField.resignFirstResponder()
    }
    
    func saveChanges(task: Task) {
        task.creating=false
        task.title=addTextField.text!
        viewMode()
        ad.saveContext()
    }
    
    func cancelChanges(task: Task) {
        context.delete(task)
        ad.saveContext()
    }
    
    
    @IBAction func donePressed(_ sender: UIButton) {
        doneTapAction?(self)
    }
    
    
    @IBAction func savePressed(_ sender: UIButton) {
        saveTapAction?(self)
    }

    @IBAction func cancelPressed(_ sender: Any) {
        cancelTapAction?(self)
    }
}

//
//  ViewController.swift
//  TaskTracker Offline
//  300907406
//  Created by Serhii Pianykh on 2017-02-14.
//  Copyright © 2017 Serhii Pianykh. All rights reserved.
//
//  ViewController with all tasks listed

import UIKit
import CoreData

class ListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var controller: NSFetchedResultsController<Task>!
    var creating: Bool = false
    
    //loading data
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        //initialData()
        attemptFetch()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        let task = controller.object(at: (indexPath as NSIndexPath) as IndexPath)
        
        //defining actions for cell closures
        cell.doneTapAction = { (self) in
            cell.updateStatus(task: task)
        }
        cell.saveTapAction = { (self) in
            cell.saveChanges(task: task)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
        cell.cancelTapAction = { (self) in
            cell.cancelChanges(task: task)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        //assigning task parameters to cell by passing cell and object position
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    //calling cell configure for cell
    func configureCell(cell: TaskCell, indexPath: NSIndexPath) {
        let task = controller.object(at: (indexPath as NSIndexPath) as IndexPath)
        cell.configureCell(task: task)
    }
    
    //try fetching data from CoreData storage
    //defining sort parameters
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [titleSort]
    
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        self.controller = controller
        
        do {
            try self.controller.performFetch()
        } catch {
            let error = error as NSError
            print(error)
        }
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    //runs when object changed
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type) {
            //inserting new row to tableview
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            //deleting row from tableview
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
            //updating cell
        case .move:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! TaskCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
            //updating cell (or changing position in case of changing sort)
        case .update:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
    
    //fetching task from array and performing segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = controller.fetchedObjects, objs.count > 0 {
            let task = objs[indexPath.row]
            performSegue(withIdentifier: "DetailsVC", sender: task)
        }
    }
    
    //we have set up Task object as a sender in performSegue. here we check if it's so and sending Task object to next VC
    //if some of cells were in creation mode (with textfield shown) - cell being deleted
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailsVC" {
            if let destination = segue.destination as? DetailsVC {
                if let task = sender as? Task {
                    destination.task = task
                }
            }
        }
    }
    
    //swipe for delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if let objs = controller.fetchedObjects, objs.count > 0 {
            let task = objs[indexPath.row]
            context.delete(task)
            ad.saveContext()
        }
    }
    
    //create new task. setting it to creation mode, so after table view updated textfield gonna be shown
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        if !creating {
            let task = Task(context: context)
            task.title=""
            task.creating=true
            task.details=""
            task.done=false
            ad.saveContext()
        }

    }
    
    //some test data
    func initialData() {
        let task = Task(context: context)
        task.title="Wash dishes"
        task.details=""
        task.done=false
        task.creating=false
        
        let task2 = Task(context: context)
        task2.title="Finish assignment"
        task2.details=""
        task2.done=false
        task2.creating=false
        
        let task3 = Task(context: context)
        task3.title="Find job"
        task3.details=""
        task3.done=false
        task3.creating=false
        
        ad.saveContext()
    }


}


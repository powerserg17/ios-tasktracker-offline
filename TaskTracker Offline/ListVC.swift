//
//  ViewController.swift
//  TaskTracker Offline
//
//  Created by Serhii Pianykh on 2017-02-14.
//  Copyright © 2017 Serhii Pianykh. All rights reserved.
//

import UIKit
import CoreData

class ListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var controller: NSFetchedResultsController<Task>!
    
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
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func configureCell(cell: TaskCell, indexPath: NSIndexPath) {
        let task = controller.object(at: (indexPath as NSIndexPath) as IndexPath)
        cell.configureCell(task: task)
    }
    
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
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .move:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! TaskCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = controller.fetchedObjects, objs.count > 0 {
            let task = objs[indexPath.row]
            performSegue(withIdentifier: "DetailsVC", sender: task)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailsVC" {
            if let destination = segue.destination as? DetailsVC {
                if let task = sender as? Task {
                    destination.task = task
                }
            }
        }
    }
    
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


//
//  GoalsVC.swift
//  goalpostApp
//
//  Created by Miguel Muñoz on 12/4/18.
//  Copyright © 2018 ISA. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class GoalsVC: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    
    var goals: [Goal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.isHidden = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCoreDataObjects()
        tableView.reloadData()
    }

    @IBAction func addGoalBtnWasPressed(_ sender: UIButton) {
        
        guard let createGoalVC = storyboard?.instantiateViewController(withIdentifier: "CreateGoalVC") else {return}
        
        presentDetail(createGoalVC)
        
    }

    func fetchCoreDataObjects(){
        fetch { (complete) in
            if complete {
                if goals.count >= 1 {
                    tableView.isHidden = false
                }else{
                    tableView.isHidden = true
                }
            }
        }
    }
    
}

extension GoalsVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath) as? GoalCell else {return UITableViewCell() }
        
        let goal = goals[indexPath.row]
        
        cell.congifureCell(goal: goal)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (rowAction, indexpath) in
            self.removeGoal(atIndexPath: indexpath)
            self.fetchCoreDataObjects()
            tableView.deleteRows(at: [indexpath], with: .automatic)
        }
        
        let addAction = UITableViewRowAction(style: .normal, title: "ADD 1") { (rowAction, indexPath) in
            
            self.setProgress(atIndexPath: indexPath)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
        addAction.backgroundColor = #colorLiteral(red: 0.5764705882, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
        
        return [deleteAction, addAction]
    }
    
}

extension GoalsVC {
    
    func setProgress(atIndexPath indexPath: IndexPath){
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        let chosenGoal = goals[indexPath.row]
        
        if chosenGoal.goalProgress < chosenGoal.goalCompletionValue{
            chosenGoal.goalProgress = chosenGoal.goalProgress + 1
        }else{
            return
        }
        
        do{
            try managedContext.save()
            print("successfully set progress!")
        }catch{
            debugPrint("could not set progress: \(error.localizedDescription)")
        }
        
    }
    
    func removeGoal(atIndexPath indexpath: IndexPath){
        
    guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        managedContext.delete(goals[indexpath.row])
        
        do{
            try managedContext.save()
            print(" Successfully removed goal!")
        }catch{
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
        
    }
    
    func  fetch(comletion: (_ complete: Bool) -> ()){
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
        
        do{
            
            goals = try managedContext.fetch(fetchRequest) as! [Goal]
            print("Successfully fetched data.")
            comletion(true)
            
        }catch{
            debugPrint("Counld not fetch: \(error.localizedDescription)")
            comletion(false)
        }
        
    }
}

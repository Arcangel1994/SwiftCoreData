//
//  FinishGoalVC.swift
//  goalpostApp
//
//  Created by Miguel Muñoz on 12/5/18.
//  Copyright © 2018 ISA. All rights reserved.
//

import UIKit
import CoreData

class FinishGoalVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var pointstextField: UITextField!
    @IBOutlet weak var createGoalBtn: UIButton!
    
    var goalDescription: String!
    var goalType: GoalType!
    
    func initData(description: String, type: GoalType){
        self.goalDescription = description
        self.goalType = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createGoalBtn.bindToKeyboard()
        
        pointstextField.delegate = self

    }
    
    @IBAction func createGoalBtnWasPressed(_ sender: UIButton) {
        
        if pointstextField.text != "" {
            
            self.save { (complete) in
                if complete {
                    dismiss(animated: true, completion: nil)
                }
            }
            
        }
        
    }
    
    @IBAction func backBtnWasPressed(_ sender: UIButton) {
        
        dismissDetail()
        
    }
    
    func save(completion: (_ finished: Bool) -> () ){
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        let goal = Goal(context: managedContext)
        
        goal.goalDescription = goalDescription
        goal.goalType = goalType.rawValue
        goal.goalCompletionValue = Int32(pointstextField.text!)!
        goal.goalProgress = Int32(0)
        
        do{
            try managedContext.save()
            print("Successfully saved data.")
            completion(true)
        }catch{
            debugPrint("Could not save \(error.localizedDescription)")
            completion(false)
        }
        
    }
    
    
}

//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Chandi Abey  on 8/8/16.
//  Copyright © 2016 Chandi Abey . All rights reserved.
//

import UIKit

class MealTableViewController: UITableViewController {

    //MARK- Properties
    
    var meals = [Meal]()
    
    
    override func viewDidLoad() {
                super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller. special type of bar button with editing behavior built into it. Then added to left side of navigation bar in meal list scene.
        navigationItem.leftBarButtonItem = editButtonItem()
        

        
        if let savedMeals = loadMeals() {
            meals += savedMeals
        }
            //adds any meals that were loaded to the meals array
        else {
            // Load the sample data.
            loadSampleMeals()
        }

    }
    
    func loadSampleMeals() {
        
        //add this code to create a few Meal objects.Make sure names of images match names you write in code.
        
        let photo1 = UIImage(named: "meal1")!
        let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4)!
        
        let photo2 = UIImage(named: "meal2")!
        let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5)!
        
        let photo3 = UIImage(named: "meal3")!
        let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3)!
 
        meals += [meal1, meal2, meal3]
    }

 
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }

 
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MealTableViewCell"

        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MealTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let meal = meals[indexPath.row]

        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating

        return cell
    }
 

    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
    
        if let sourceViewController = sender.sourceViewController as?  MealViewController, meal = sourceViewController.meal {

            
            //checks whether a row in the table view is selected. if it is, that means user has tapped one of the table views cells to edit a meal
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update entry in meals to store the updated meal info. second line reloads appropriate row in table view to display changed data.
                meals[selectedIndexPath.row] = meal
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
                
            }

            else {
                
            
            
            // Add a new meal. computes location in table view where new table view cell representing new meal will be inserted and stores it in a local constant
            let newIndexPath = NSIndexPath(forRow: meals.count, inSection: 0)
            
            //adds new meal to existing list of meals in data model
            meals.append(meal)
                
                //animates addition of new row to table view for the cell that contains info about new meal. .Bottom option shows inserted row slide in from bottom
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                
        
            }
            // Save the meals array whenever a new one is added or an existing one is updated. (inside the outer if statement)
            saveMeals()
        }
    
    }
    
    
    
    
    
   
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
  

    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //delete meal object from meals
            meals.removeAtIndex(indexPath.row)
            // Delete the row from the data source
              saveMeals()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
  

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            //gets executed if meal is being edited, tries to downcast destination VC of segue to a MealViewCotnrollers using forced type cast operator as! If successful gets assigned to mealDetailViewController. if unsuccessful, app crashes at runtime
            let mealDetailViewController =
                segue.destinationViewController as! MealViewController
            
            // Get the cell that generated this segue. This code tries to downcast sender to a MealCell using the optional type cast operator (as?). If the cast is successful, the local constant selectedMealCell gets assigned the value of sender cast as type MealTableViewCell, and the if statement proceeds to execute. If the cast is unsuccessful, the expression evaluates to nil and the if statement isn’t executed.
            if let selectedMealCell = sender as?  MealTableViewCell {
                // fetches the Meal object corresponding to the selected cell in the table view. It then assigns that Meal object to the meal property of the destination view controller, an instance of MealViewController. (You’ll configure MealViewController to display the information from its meal property when it loads.)
                
                
                let indexPath = tableView.indexPathForCell(selectedMealCell)!
                let selectedMeal = meals[indexPath.row]
                mealDetailViewController.meal = selectedMeal
                
            }	
            
            
        }
            
        else if segue.identifier == "AddItem" {
            print("Adding new meal.")
            
        }
    }
   
    
    // MARK: NSCoding
    //method attempt to archive meals array to a specific locations and returns true if its successful. Uses the constant Meal.ArchiveURL defined in meal class to identify where to save information
    func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path!)
        
        //quickly testing if archived
        if !isSuccessfulSave {
            print("Failed to save meals...")
            
        }
    }

    func loadMeals() -> [ Meal ]? {
        
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Meal.ArchiveURL.path!) as? [ Meal]
        
        
    }
    

}

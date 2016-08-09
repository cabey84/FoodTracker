//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Chandi Abey  on 8/1/16.
//  Copyright © 2016 Chandi Abey . All rights reserved.
//

import UIKit

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    //MARK: Properties
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var photoImageView: UIImageView!
   
    @IBOutlet weak var ratingControl: RatingControl!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    /*
     This value is either passed by `MealTableViewController` in `prepareForSegue(_:sender:)`
     or constructed as part of adding a new meal.
     */
    var meal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Handle the text field’s user input through delegate callbacks.self refers to viewcontroller class
        nameTextField.delegate = self
        
        
        // Set each of the views in mealviewcontroller to display data from meal property if meal property is not nil .
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text   = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }

        
        // Enable the Save button only if the text field has a valid Meal name. So save button is disabled until user enters valid name
        checkValidMealName()
        
    }
    
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard. Resign the textfield's first responder status to the delegate
        textField.resignFirstResponder()
        //returning the value true indicates that the text field should respond to the user pressing the Return key by dismissing the keyboard.
        return true
    }
    
    func textFieldDidBeginEditing(textField:  UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func checkValidMealName() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }

    
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        //method allows to read what is entered in text field and do something with it,here we are changing the value of the label
        //calls the checkValidMealName() to check if text field has text in it which enables save button
        checkValidMealName()
        //second line sets title of scene to that text
        navigationItem.title = textField.text

    }
    
    
  

    
    
    
    
    
    // MARK: UIImagePickerControllerDelegate (image picker's implementation)
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: Navigation 
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        //creates a Boolean value that indicates whether view controller that presented this scene is of type UINavigationController. If so, it was presented using the add button. meal scene embedded in its own naive controller
        let isPresentingInAddMealMode = presentingViewController is  UINavigationController
        
        if isPresentingInAddMealMode {
            //before dismissViewController happened anytime cancel method got called, now it only happens when isPresentingInAddMode is true
            dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            //gets executed when meal scene pushed onto navigation stack on top of meal list scene. pops current VC off navigation stack and performs an animation of transition    
            navigationController!.popViewControllerAnimated(true)
        }


    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue:  UIStoryboardSegue , sender: AnyObject?) {
        //identifier operator to check the object referenced by saveButton outlet is same object as sender
        if saveButton === sender {
            //creates constants from current text field text, selected image and rating in scene, ?? nil coalescing operator returns value of an optional if optional has a value or returns a default value otherwise, unwraps the optional string returned by nameTextfield.text but if nil returns empty string
            let name = nameTextField.text ?? ""
            let photo = photoImageView.image
            let rating = ratingControl.rating
            // Set the meal to be passed to MealTableViewController after the unwind segue. This configures the meal property with appropriate values before segue executes.
            meal = Meal(name: name, photo: photo, rating: rating)
        }

    }
    
    
    //MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        //The method asks ViewController to present the view controller defined by imagePickerController.
        presentViewController(imagePickerController, animated: true, completion: nil)
    
    }

}


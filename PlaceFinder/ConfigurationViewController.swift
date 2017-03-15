//
//  ConfigurationViewController.swift
//  PlaceFinder
//
//  Created by Alla Bondarenko on 2017-03-11.
//  Copyright © 2017 SMU Student. All rights reserved.
//

import UIKit
import CoreLocation

class ConfigurationViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    //Button that takes to the next scene (connection to UI)
    @IBOutlet weak var showPlacesButton: UIButton!
    // Inpur field for search parameter (connection to UI)
    @IBOutlet weak var addTerm: UITextField!
    
    // Image Container. Not passed to next screen, added for constraints training purposes
    @IBOutlet weak var pretttyImageView: UIImageView!
    
    //Search Parameter for Yelp API
    var term: String?
    
    // Class to request user's location. Requires string in Plist file to explain a purpose of it's usage to a user
    //https://developer.apple.com/reference/corelocation/cllocationmanager
    
    lazy var locationManager : CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        return manager
    }()

    // View Lifecycle method. Called each time the view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set image to imageContainer
        pretttyImageView.image = UIImage(named: "sunshine")
        //Assign input field a delegate: listening on user's input -> respond to keyboard input
        addTerm.delegate = self
    }
    
    //MARK: - TextFieldDelegate Methods
    
    //comparing if the input field is the one we expect the value from and if so, assign a value to a global variable term
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == addTerm {
            print(addTerm.text ?? "none")
            self.term = addTerm.text
        }
    }
    
    //listening on input resources. If input source is a particular one, we hide keyboard.
    //See more at https://developer.apple.com/reference/uikit/uitextfielddelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == addTerm {
            addTerm.resignFirstResponder()
            return false
        }
        return true
    }
    
    //function that returns user's location
    func getCurrentLocation() -> CLLocation {
        var currentLocation: CLLocation
        
        //performing request to a location manager to get current location
        if let location = locationManager.location {
            //if permission was granted, save location to local variable current location
            currentLocation = location
        } else {
            currentLocation = CLLocation(latitude: 44.7210, longitude: -63.7104)
            //if permission was declined, define some location and assign it to local variable current location
        }
        //return result
        return currentLocation
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    
    //Listening whether the ViewController is going to change (go to the next scene)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // checking on scene change name
        if segue.identifier == "configurationToResultsSegue" {
            //create an instance of destination scene and pass the parameters from Configuration View Controller to ResultsTableViewController
            let destinationViewController = segue.destination as! ResultsTableViewController
            destinationViewController.term = term
            destinationViewController.location = getCurrentLocation()
        }
    }
/*
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did location updates is called")
        //store the user location here to firebase or somewhere
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }
*/
}

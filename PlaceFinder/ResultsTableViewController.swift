//
//  ResultsTableViewController.swift
//  PlaceFinder
//
//  Created by Alla Bondarenko on 2017-03-12.
//  Copyright © 2017 SMU Student. All rights reserved.
//

import UIKit
import CoreLocation

//View Controller that shows results of API call in a table, Conforms to Yelp API COntroller protocol

class ResultsTableViewController: UITableViewController, YelpAPIControllerProtocol {
    
    var api: YelpAPIController!
    //array of Business objects
    var businesses = [Business]()
    //parameters passed from ConfigurationViewCOntroller
    var term: String?
    var location: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestYelp()
    }
    
    func requestYelp(){
        //initialize yelpapicontroller instance
        api = YelpAPIController()
        //assign a delegate
        api.delegate = self
        
        //perform conditional binding to make sure values are not nil
        if let location = location, let term = term {
            api.getBusinessSearch(location: location, term: term)
        }
        
    }
    // MARK: - Table view data source methods

    //Delegate method to define how many sections there are in tableview
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //number of rows in section (see above, there's only one) based on number of businesses
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }

    //MARK: -YELPAPICONTROLLERProtocol 
    
    //Conformance to protocol means a class has to implement all functions in protocol
    func didRecieveAPIResults(results: [[String : Any]]) {
        //DispatchQueue manages the execution of work items, main means main thread.
        //See more at https://developer.apple.com/reference/dispatch/dispatchqueue
        DispatchQueue.main.async(execute: {
            for result in results{
                if let newItem = Business(json: result) {
                    self.businesses.append(newItem)
                }
            }
            //reload cells appending new values
            self.tableView.reloadData()
        })
    }
    
    //delegate method that defines what each cell in table view should consist of. 
    //Index Path consists of section number and row. Since we've defined 1 section, we'll be iterating through businesses array one by one and assigning it's properties appropriately.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! BusinessTableViewCell
        let business = businesses[indexPath.row]
        cell.name.text = business.name
        cell.distance.text = business.distance
        cell.category.text = business.categories
        

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

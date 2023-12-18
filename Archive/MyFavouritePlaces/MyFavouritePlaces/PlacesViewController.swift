//
//  PlacesViewController.swift
//  MyFavouritePlaces
//
//  Created by Yuvaraj Mayank Konjeti on 18/12/23.
//

import UIKit

var places = [[String:String]()]
var currentPlace = -1
let userDefaults = UserDefaults.standard
let keyForPlaces = "myFavouritePlacess"
class PlacesViewController: UITableViewController {

    @IBOutlet var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let favoritePlacess = userDefaults.value(forKey: keyForPlaces) as? [[String:String]]{
            places = favoritePlacess
            table.reloadData()
        }


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
  override func viewDidAppear(_ animated: Bool) {
    if places.count == 1 && places[0].count == 0{
      places.remove(at: 0)
      places.append(["name" : "Ashton Building","lat":"53.406566","lon":"-2.966531"])
      userDefaults.set(places, forKey: keyForPlaces)
    }
    currentPlace = -1
    table.reloadData()
  }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      return places.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        var content =  UIListContentConfiguration.cell()
        if places[indexPath.row]["name"] != nil{
          content.text = places[indexPath.row]["name"]
        }
        cell.contentConfiguration = content
        return cell
    }
    
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    currentPlace = indexPath.row
    performSegue(withIdentifier: "toMap", sender: nil)
  }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            places.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            userDefaults.set(places, forKey: keyForPlaces)
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

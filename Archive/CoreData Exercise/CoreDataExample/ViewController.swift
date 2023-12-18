//
//  ViewController.swift
//  CoreDataExample
//
//  Created by Yuvaraj Mayank Konjeti on 18/12/23.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var contacts: [NSManagedObject] = []
    @IBOutlet weak var myTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        // Do any additional setup after loading the view.
    }
    func fetchData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Contact")
        do {
            contacts = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    func save(firstName: String, lastName: String, phone: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let contact = NSEntityDescription.insertNewObject(forEntityName: "Contact", into:
                                                            managedContext)
        contact.setValue(firstName, forKeyPath: "firstName")
        contact.setValue(lastName, forKeyPath: "lastName")
        contact.setValue(phone, forKeyPath: "phone")
        do {
            try managedContext.save()
            contacts.append(contact)
            print("SAVED")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return contacts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for:indexPath)
        let contact = contacts[indexPath.row]
        let firstName = contact.value(forKeyPath: "firstName") as? String
        let lastName = contact.value(forKeyPath: "lastName") as? String
        let phone = contact.value(forKeyPath: "phone") as? String
        var content = UIListContentConfiguration.cell()
        content.text = "\(firstName ?? "") \(lastName ?? "")"
        content.secondaryText = "\(phone ?? "")"
        cell.contentConfiguration = content
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            delete(indexPath: indexPath)
        }
    }
    @IBAction func addContact(_ sender: Any)  {
        let alert = UIAlertController(title: "New Contact", message: "Add a new contact", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "First Name"
        }
        alert.addTextField { textField in
            textField.placeholder = "Last Name"
        }
        alert.addTextField { textField in
            textField.placeholder = "Phone Number"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self]
            action in
            guard let firstNameField = alert.textFields?[0],
                  let lastNameField = alert.textFields?[1],
                  let phoneField = alert.textFields?[2],
                  let firstName = firstNameField.text,
                  let lastName = lastNameField.text,
                  let phone = phoneField.text else {
                return
            }
            self.save(firstName: firstName, lastName: lastName, phone: phone)
            self.myTable.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    func delete(indexPath: IndexPath) {
        // Delete the object from Core Data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let contactToDelete = contacts[indexPath.row]
        managedContext.delete(contactToDelete)
        do {
            try managedContext.save()
            // Remove the object from the array
            contacts.remove(at: indexPath.row)
            // Remove the table view row
            myTable.deleteRows(at: [indexPath], with: .fade)
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
}


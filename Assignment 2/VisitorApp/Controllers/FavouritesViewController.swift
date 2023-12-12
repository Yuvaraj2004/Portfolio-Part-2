//
//  FavouritesViewController.swift
//  VisitorApp
//
//  Created by Yuvaraj Mayank Konjeti on 24/11/2023.
//

import UIKit
import CoreData

class FavouritesViewController: UIViewController {
    
    @IBOutlet weak var favouritesTableView: UITableView!
    
    var plants: [PlantEntity] = [PlantEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if !PlantDataManager
            .shared
            .getAllPlants().isEmpty {
            plants = PlantDataManager
                .shared
                .getAllPlants()
            
            self.favouritesTableView.reloadData()
        }
        
    }
}

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.plants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath)
        var content = UIListContentConfiguration.subtitleCell()

        let boldFont = UIFont.boldSystemFont(ofSize: 17)

        let familyText = "FAM:"
        let speciesText = "species: \(plants[indexPath.row].species ?? "-")"

        let attributedText = NSMutableAttributedString()
        attributedText.append(NSAttributedString(string: familyText, attributes: [.font: boldFont]))
        attributedText.append(NSAttributedString(string: " \(plants[indexPath.row].family ?? "-")"))
        attributedText.append(NSAttributedString(string: "\n"))
        attributedText.append(NSAttributedString(string: speciesText))

        content.attributedText = attributedText

        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Perform the deletion action here
            deletePlant(at: indexPath)
        }
    }
    
    private func deletePlant(at indexPath: IndexPath) {
        let plant = plants[indexPath.row]
        plants.remove(at: indexPath.row)
        favouritesTableView.deleteRows(at: [indexPath], with: .fade)
        
        PlantDataManager.shared.deletePlant(plant)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}


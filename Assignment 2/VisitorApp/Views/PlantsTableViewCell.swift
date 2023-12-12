//
//  PlantsTableViewCell.swift
//  VisitorApp
//
//  Created by Yuvaraj Mayank Konjeti on 24/11/2023.
//

import UIKit

protocol FavDelegate: AnyObject {
    func setValue(_ isFav: Bool, _ cell: PlantsTableViewCell)
}

class PlantsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var genusLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var infraspecificLabel: UILabel!
    @IBOutlet weak var plantFamilyLabel: UILabel!
    @IBOutlet weak var vernacularLabel: UILabel!
    @IBOutlet weak var cultivarLabel: UILabel!
    
    @IBOutlet weak var favButton: UIButton!
    weak var delegate: FavDelegate?
    
    private var isFav = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // favButton.isHidden = true
    }
    
    @IBAction func favAct(_ sender: Any) {
               let sender = sender as! UIButton
       
                let heartEmpty = UIImage(systemName: "heart")
                let heartFill = UIImage(systemName: "heart.fill")
        
                let image = isFav ? heartFill : heartEmpty
        sender.setImage(image, for: .normal)
        delegate?.setValue(isFav, self)
    }
    
    public func updateIsFavButton(recNum: String) {
        let plant = PlantDataManager
            .shared
            .getPlant(withRecnum: recNum)

        if plant?.recnum == recNum {
            let heartFill = UIImage(systemName: "heart.fill")
            self.favButton.setImage(heartFill, for: .normal)
        } else {
            let heartEmpty = UIImage(systemName: "heart")
            self.favButton.setImage(heartEmpty, for: .normal)
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

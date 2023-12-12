//
//  DetailPlantViewController.swift
//  VisitorApp
//
//  Created by Yuvaraj Mayank Konjeti on 4/12/2023.
//

import UIKit
import MapKit

class DetailPlantViewController: UIViewController {
    
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var genusNameLabel: UILabel!
    @IBOutlet weak var speciesNameLabel: UILabel!
    @IBOutlet weak var infraspecificLabel: UILabel!
    @IBOutlet weak var vernacularLabel: UILabel!
    @IBOutlet weak var cultivarLabel: UILabel!
    @IBOutlet weak var detailPlantMapView: MKMapView!
    @IBOutlet weak var plantImageView: UIImageView!
    
    // MARK: Public props
    
    var lat: String?
    var long: String?
    
    var familyNameValue: String?
    var genusNameValue: String?
    var speciesNameValue: String?
    var infraspecificValue: String?
    var cultivarValue: String?
    var vernacularValue: String?
    
    public var imageFileName: String?
    public var recnum: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        loadPlantImage()
        loadSpecificPlantLocationOnMap()
    }
    
    private func presentAlert() {
        let alert = UIAlertController(title: "Alert!", message: "already added to favourites tab, checkout there now", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "done", style: .default) { _ in
            self.tabBarController?.selectedIndex = 1
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
}












// MARK: Private Methods

extension DetailPlantViewController {

    private func loadData() {
        let boldFont = UIFont.boldSystemFont(ofSize: 17)
        
        let familyText = "Family: " + (familyNameValue ?? "")
        let familyAttributedString = NSMutableAttributedString(string: familyText)
        familyAttributedString.addAttributes([.font: boldFont], range: NSRange(location: 7, length: familyText.count - 7))
        familyNameLabel.attributedText = familyAttributedString
        
        let genusText = "Genus: " + (genusNameValue ?? "")
        let genusAttributedString = NSMutableAttributedString(string: genusText)
        genusAttributedString.addAttributes([.font: boldFont], range: NSRange(location: 6, length: genusText.count - 6))
        genusNameLabel.attributedText = genusAttributedString
        
        let speciesText = "Species: " + (speciesNameValue ?? "")
        let speciesAttributedString = NSMutableAttributedString(string: speciesText)
        speciesAttributedString.addAttributes([.font: boldFont], range: NSRange(location: 8, length: speciesText.count - 8))
        speciesNameLabel.attributedText = speciesAttributedString
        
        let infraspecificText = "Infra: " + (infraspecificValue ?? "")
        let infraspecificAttributedString = NSMutableAttributedString(string: infraspecificText)
        infraspecificAttributedString.addAttributes([.font: boldFont], range: NSRange(location: 6, length: infraspecificText.count - 6))
        infraspecificLabel.attributedText = infraspecificAttributedString
        
        let vernacularText = "Vernacular: " + (vernacularValue ?? "")
        let vernacularAttributedString = NSMutableAttributedString(string: vernacularText)
        vernacularAttributedString.addAttributes([.font: boldFont], range: NSRange(location: 8, length: vernacularText.count - 8))
        vernacularLabel.attributedText = vernacularAttributedString
        
        let cultivarText = "Cultivar: " + (cultivarValue ?? "")
        let cultivarAttributedString = NSMutableAttributedString(string: cultivarText)
        cultivarAttributedString.addAttributes([.font: boldFont], range: NSRange(location: 8, length: cultivarText.count - 8))
        cultivarLabel.attributedText = cultivarAttributedString
    }


    private func loadPlantImage() {
        if let image = imageFileName {
            self.downloadImage(from: URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/ness_images/\(image)")!)
        }
        
    }
    private func loadSpecificPlantLocationOnMap() {
        if lat != "" && long != "" {
            self.detailPlantMapView.isHidden = false
            let lati = Double(lat!)!
            let longi = Double(long!)!
            let initialLocation = CLLocationCoordinate2D(latitude: lati, longitude: longi)
            let region = MKCoordinateRegion(center: initialLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
            detailPlantMapView.setRegion(region, animated: true)
            
            // Display the user's location on the map
            detailPlantMapView.showsUserLocation = true
            
            // Keep the map centered on the user's location
            detailPlantMapView.userTrackingMode = .follow
            
        }
        else {
            self.detailPlantMapView.isHidden = true
        }
    }
    
    private func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            // Update the UI on the main thread
            DispatchQueue.main.async { [weak self] in
                self?.plantImageView.image = UIImage(data: data)
            }
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}

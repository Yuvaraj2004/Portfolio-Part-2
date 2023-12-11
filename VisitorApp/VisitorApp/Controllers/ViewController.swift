//
//  ViewController.swift
//  VisitorApp
//
//  Created by Yuvaraj Mayank Konjeti on 23/11/2023.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var myMap: MKMapView!
    @IBOutlet weak var plantsTableView: UITableView!
    
    // MARK: Private Props
    
    private var plants: [Plant] = [Plant]()
    private var beds: [BedElement]  = [BedElement]()
    private var plantsByBedSection: [String: [Plant]] = [:]
    private var imageWithRecord: [String: String] = [:]
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    private var locationManager = CLLocationManager()
    private var firstRun = true
    private var startTrackingTheUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        
        retriveBedsData()
        retrivePlantsData()
        setupMap()
        
    }
}










// MARK: Private Methods
extension ViewController {
    
    private func setupActivityIndicator() {
        self.view.addSubview(activityIndicator)
        self.activityIndicator.center = self.view.center
        self.view.isUserInteractionEnabled = false
    }
    
    private func setupMap() {
        locationManager.delegate = self as CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        myMap.showsUserLocation = true
    }
    
    // filtering plants using bedID
    private func filterPlantsByBedID(_ plants: [Plant], bedID: String) -> [Plant] {
        return plants.filter { $0.bed == bedID }
    }
    
    // make a plants group by beds
    func groupPlantsByBedSection(_ plants: [Plant]) -> [String: [Plant]] {
        return Dictionary(grouping: plants, by: { $0.bed ?? "" })
    }
    
    
    private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            // Update the UI on the main thread
            
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                completion(UIImage(data: data))
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}

// MARK: Maps callsbacks

extension ViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationOfUser = locations[0]
        let latitude = locationOfUser.coordinate.latitude
        let longitude = locationOfUser.coordinate.longitude
        
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        if firstRun {
            firstRun = false
            let latDelta: CLLocationDegrees = 0.0025
            let lonDelta: CLLocationDegrees = 0.0025
            
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            
            let region = MKCoordinateRegion(center: location, span: span)
            
            self.myMap.setRegion(region, animated: true)
            
            _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector:
                                        #selector(startUserTracking), userInfo: nil, repeats: false)
        }
        if startTrackingTheUser == true {
            myMap.setCenter(location, animated: true)
        }
    }
    
    @objc func startUserTracking(_ location: CLLocationCoordinate2D) {
        if startTrackingTheUser == true {
            myMap.setCenter(location, animated: true)
        }
    }
}

// MARK: tableview callbacks

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.beds.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.beds[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let bedID = beds[section].bedID
        return plantsByBedSection[bedID]?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "plantCell", for: indexPath)
        let bedID = beds[indexPath.section].bedID
        if let plants = plantsByBedSection[bedID] {
            let plant = plants[indexPath.row]
            var content = UIListContentConfiguration.subtitleCell()
            
            content.text = plant.species
            content.secondaryText = plant.genus
            content.image = UIImage(systemName: "photo.fill")
            cell.contentConfiguration = content
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = sb.instantiateViewController(withIdentifier: "DetailPlantViewController") as? DetailPlantViewController
        let bedID = beds[indexPath.section].bedID
        if let plants = plantsByBedSection[bedID] {
            let plant = plants[indexPath.row]
            vc?.species = plant.species
            vc?.lat = plant.latitude
            vc?.long = plant.longitude
            vc?.countryNameValue = plant.country
            vc?.familyNameValue = plant.family
            vc?.imageFileName = imageWithRecord[plant.recnum ?? ""]
            vc?.recnum = plant.recnum
        }
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

// MARK: Fetch the data

extension ViewController {
    
    // MARK: get all plants
    private func retrivePlantsData() {
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        let plantsURL = URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/ness/data.php?class=plants")!
        
        APIManager.shared.fetchData(from: plantsURL) { (_ result: Result<Plants?, Error>) in
            switch result {
            case .success(let success):
                if let plants = success {
                    DispatchQueue.main.async {
                        let bedIDs = self.beds.compactMap { $0.bedID }.sorted()
                        let finalFiteredPlants = plants.plants.filter { $0.bed != "" && bedIDs.contains($0.bed!) }
                        self.plants = finalFiteredPlants
                        for bed in bedIDs {
                            let filteredPlants = self.filterPlantsByBedID(finalFiteredPlants, bedID: bed)
                            let plant = self.groupPlantsByBedSection(filteredPlants)
                            self.plantsByBedSection.merge(dict: plant)
                        }
                        self.getImages()
                        
                        
                    }
                    
                }
                
            case .failure(let failure):
                print("error: \(failure.localizedDescription)")
                
            }
        }
        
    }
    
    // MARK: get all beds
    private func retriveBedsData() {
        let bedsURL = URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/ness/data.php?class=beds")!
        APIManager.shared.fetchData(from: bedsURL) { (_ result: Result<Bed?, Error>) in
            switch result {
            case .success(let success):
                if let beds = success {
                    DispatchQueue.main.async {
                        let filteredBeds = beds.beds.filter { $0.name != nil }
                        self.beds = filteredBeds
                        self.plantsTableView.reloadData()
                    }
                }
                
            case .failure(let failure):
                print("error: \(failure.localizedDescription)")
                
            }
        }
    }
    
    // MARK: get all images
    private func getImages() {
        let imagesURL = URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/ness/data.php?class=images")!
        APIManager.shared.fetchData(from: imagesURL) { (_ result: Result<Images?, Error>) in
            switch result {
            case .success(let success):
                if let images = success {
                    DispatchQueue.main.async { [self] in
                        for image in images.images {
                            for plant in plants {
                                if image.recnum == plant.recnum {
                                    imageWithRecord[plant.recnum!] = image.imgFileName
                                }
                            }
                        }
                        self.plantsTableView.reloadData()
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        self.view.isUserInteractionEnabled = true
                    }
                }
                
            case .failure(let failure):
                print("error: \(failure.localizedDescription)")
            }
        }
    }
}

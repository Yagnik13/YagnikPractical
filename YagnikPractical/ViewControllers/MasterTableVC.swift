//
//  MasterTableVC.swift
//  YagnikPractical
//
//  Created by Yagnik Suthar on 22/11/18.
//  Copyright © 2018 Yagnik Suthar. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MasterTableVC: UITableViewController {
    
    @IBOutlet var tblMaster: UITableView!
    
    var arrLocationModel = [LocationModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDetailFromCoreData()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LocationDetails")
        
        do {
            let people = try managedContext.fetch(fetchRequest)
            
            if people.count > 0 {
                
                //get value from core data
                for obj in people {
                    let name = obj.value(forKey: "name") as! String
                    let iconName = obj.value(forKey: "iconName") as! String
                    let vicnity = obj.value(forKey: "vicinity") as! String
                    let lat = obj.value(forKey: "lat") as! Double
                    let lon = obj.value(forKey: "long") as! Double
                    let objLocationModel = LocationModel(name: name, vicinity: vicnity, iconName: iconName, lat: lat, lon: lon)
                    self.arrLocationModel.append(objLocationModel)
                }
                print(people)
            }else {
                WebService.callAPIWith(lat: "23.0345116", long: "72.5063882", completion: { result in
                    let arrDic = result.map({
                        $0 as! [String:Any]
                    })
                    for obj in arrDic {
                        if let geometry = obj["geometry"] as? [String:Any] {
                            if let location = geometry["location"] as? [String:Any] {
                                if let nameObj = obj["name"] as? String {
                                    if let iConName = obj["icon"] as? String {
                                        if let vicnity = obj["vicinity"] as? String {
                                            let objLocationModel = LocationModel(name: nameObj, vicinity: vicnity, iconName: iConName, lat:  location["lat"] as! Double, lon: location["lng"] as! Double)
                                            
                                            //save value from core data
                                            self.saveInCoreData(iconName: iConName, name: nameObj, long: location["lng"] as! Double, lat: location["lat"] as! Double, vicinity: vicnity)
                                            self.arrLocationModel.append(objLocationModel)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    print(self.arrLocationModel)
                    DispatchQueue.main.async {
                        self.tblMaster.reloadData()
                    }
                })
            }
            
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrLocationModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MasterCell", for: indexPath) as!  MasterTableViewCell
        cell.lblLocation.text = arrLocationModel[indexPath.row].name
        cell.selectionStyle = .blue
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = splitViewController?.viewControllers.last as? DetailsVC
        let coordinate = CLLocationCoordinate2D(latitude: self.arrLocationModel[indexPath.row].lat, longitude: (self.arrLocationModel[indexPath.row].lon))
        if CLLocationCoordinate2DIsValid(coordinate) {
            let point = PinClass(title: (self.arrLocationModel[indexPath.row].name),
                                 locationName: (self.arrLocationModel[indexPath.row].name),
                                 discipline: (self.arrLocationModel[indexPath.row].name), coordinate: coordinate)
            vc?.mapView.addAnnotation(point)
            vc?.mapView.centerCoordinate = coordinate
        }
    }
    
    func fetchDetailFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LocationDetails")
        do {
            let people = try managedContext.fetch(fetchRequest)
            
            if people.count > 0 {
                return
            }
            
            for obj in people {
                let name = obj.value(forKey: "name") as! String
                let iconName = obj.value(forKey: "iconName") as! String
                let vicnity = obj.value(forKey: "vicinity") as! String
                let lat = obj.value(forKey: "lat") as! Double
                let lon = obj.value(forKey: "long") as! Double
                let objLocationModel = LocationModel(name: name, vicinity: vicnity, iconName: iconName, lat: lat, lon: lon)
                self.arrLocationModel.append(objLocationModel)
            }
            print(people)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func saveInCoreData(iconName : String, name : String,long : Double, lat : Double, vicinity : String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "LocationDetails", in: managedContext)!
        
        let objLocationDetail = NSManagedObject(entity: entity,insertInto: managedContext)
        objLocationDetail.setValue(iconName, forKey: "iconName")
        objLocationDetail.setValue(name, forKey: "name")
        objLocationDetail.setValue(long, forKey: "long")
        objLocationDetail.setValue(lat, forKey: "lat")
        objLocationDetail.setValue(vicinity, forKey: "vicinity")
        
        do {
            try context.save()
            print("saved successfully")
        } catch {
            print("Failed saving")
        }
        
    }
    
}

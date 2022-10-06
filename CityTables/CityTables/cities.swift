//
//  cities.swift
//  CityTables
//
//  Created by Nick Meyer on 2/24/22.
//

import Foundation
import UIKit
import CoreData

class cities
{
    // make a singleton
    static let shared = cities()
    
    // handler to the managege object context
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //this is the array to store City entities from the coredata
    var fetchResults =  [City]()
    
    var cityDict = [String: [String]]()
    var citySectionTitles = [String]()
    
    var counter = 0
    
    init()
    {
        initCounter()
    }
    
    func fetchRecord() -> Int {
        // Create a new fetch request using the FruitEntity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        let sort = NSSortDescriptor(key: "cityName", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        var x = 0
        // Execute the fetch request, and cast the results to an array of City objects
        fetchResults = ((try? managedObjectContext.fetch(fetchRequest)) as? [City])!
        
        x = fetchResults.count
        print(x)
        
        // return howmany entities in the coreData
        return x
    }
    
    func deleteSelected(indexPath: IndexPath)
    {
        // delete the selected object from the managed
        // object context
        managedObjectContext.delete(fetchResults[indexPath.row])
        // remove it from the fetch results array
        fetchResults.remove(at:indexPath.row)
        do
        {
            // save the updated managed object context
            try managedObjectContext.save()
        }
        catch
        {
            
        }
    }
    
    func deleteAll()
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        // whole fetchRequest object is removed from the managed object context
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedObjectContext.execute(deleteRequest)
            try managedObjectContext.save()
        }
        catch let _ as NSError {
        }
    }
    
    func editCity(name: String?, desc: String?, img: UIImage)
    {
        for currentCity in fetchResults
        {
            if currentCity.cityName == name
            {
                currentCity.cityDescription = desc
                currentCity.cityImage = NSData(data: img.jpegData(compressionQuality: 0.3)!)
            }
        }
        // this all saves the data to core data
        do{
            try self.managedObjectContext.save()
            let eventRequest: NSFetchRequest<City> = City.fetchRequest()
            do{
                self.fetchResults = try self.managedObjectContext.fetch(eventRequest)
            }catch
            {
                print("Could not load save data: \(error.localizedDescription)")
            }
        }catch{
            print("Error Data Not Saved: \(error.localizedDescription)")
        }
    }
    
    func createCity(name: String?, desc: String?, img: UIImage)
    {
        //create a new entity object
        let ent = NSEntityDescription.entity(forEntityName: "City", in: self.managedObjectContext)
        //add to the manege object context
        let newItem = City(entity: ent!, insertInto: self.managedObjectContext)
        newItem.cityName = name
        newItem.cityDescription = desc
        newItem.cityImage = NSData(data: img.jpegData(compressionQuality: 0.3)!)
        do{
            try self.managedObjectContext.save()
            let eventRequest: NSFetchRequest<City> = City.fetchRequest()
            do{
                self.fetchResults = try self.managedObjectContext.fetch(eventRequest)
            }catch
            {
                print("Could not load save data: \(error.localizedDescription)")
            }
        }catch{
            print("Error Data Not Saved: \(error.localizedDescription)")
        }
    }
    
    func getfetchedResults() -> Array<City>
    {
        return fetchResults
    }
    
    func initCounter()
    {
        counter = UserDefaults.init().integer(forKey: "counter")
    }

    func updateCounter()
    {
        counter += 1
        UserDefaults.init().set(counter, forKey: "counter")
        UserDefaults.init().synchronize()
    }
    
    func createCityDict()
    {
        for curCity in getfetchedResults()
        {
            let firstLetterIndex = curCity.cityName!.index(curCity.cityName!.startIndex, offsetBy: 1)
            let cityKey = String(curCity.cityName![..<firstLetterIndex])
            
            if var cityValues = cityDict[cityKey] {
                cityValues.append(curCity.cityName!)
                cityDict[cityKey] = cityValues
            }else {
                    self.cityDict[cityKey] = [curCity.cityName!]
                }
            
            citySectionTitles = [String](cityDict.keys)
            citySectionTitles = citySectionTitles.sorted(by: { $0 < $1
                
            })
            
            
        }
    }
}

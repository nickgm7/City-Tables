//
//  ViewController.swift
//  CityTables
//
//  Created by Nick Meyer on 2/24/22.
//

import UIKit
import CoreData


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    @IBOutlet weak var cityTable: UITableView!
    //let cityModel: cities = cities()
    // cities.shared
    var arrIndexSection : NSArray = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    override func viewDidLoad()
    {
        super.viewDidLoad()
        cities.shared.createCityDict()
        print(cities.shared.citySectionTitles)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        cityTable.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // calling the model to get the city count
        //return myCityList.getCount()
        
        return cities.shared.fetchRecord()
        /*
        let cityKey = cities.shared.citySectionTitles[section]
        guard let cityValues = cities.shared.cityDict[cityKey] else {return 0}
        
        return cityValues.count
        */
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! CityTableViewCell
        cell.layer.borderWidth = 1.0
        /*
        let cityKey = cities.shared.citySectionTitles[indexPath.section]
        if let cityValues = cities.shared.cityDict[cityKey] {
            cell.cityTitle.text = cityValues[indexPath.row]
            
        }
            
            
         */
       
            
        
        cell.cityTitle.text = cities.shared.getfetchedResults()[indexPath.row].cityName
    
        if let picture = cities.shared.getfetchedResults()[indexPath.row].cityImage
        {
            cell.cityImage.image =  UIImage(data:picture as Data)
        }
        else
        {
            cell.imageView?.image = nil
        }
        
        
        
        return cell
    }
    
    // delete a city
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell.EditingStyle
    {
        return UITableViewCell.EditingStyle.delete
    }
    
    // implement delete function
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            cities.shared.deleteSelected(indexPath: indexPath)
            // reload the table after deleting a row
            self.cityTable.reloadData()
        }
    }
    /*
    func numberOfSections(in tableView: UITableView) -> Int {
        return cities.shared.citySectionTitles.count
    }

    

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return cities.shared.citySectionTitles[section]
    }
    */
    @IBAction func actionOnPlusButton(_ sender: Any)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func addRecord(selectedImage: UIImage)
    {
        // show the alert controller to select an image for the row
        let alertController = UIAlertController(title: "Add City", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { (aciton) in
            
            let name = alertController.textFields?.first?.text
            let desc = alertController.textFields?.last?.text

            if name != "" && desc != ""{
                
                cities.shared.createCity(name: name, desc: desc, img: selectedImage)
                self.cityTable.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        alertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter name of the city..."})
        
        alertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter a short descripion..."})
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }


    @IBAction func deleteAll(_ sender: UIBarButtonItem)
    {
        cities.shared.deleteAll()
        cityTable.reloadData()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        let selectedIndex: IndexPath = self.cityTable.indexPath(for: sender as! UITableViewCell)!
        
        if(segue.identifier == "detailView"){
            if let vc: DetailViewController = segue.destination as? DetailViewController {
                vc.selectedCity = cities.shared.getfetchedResults()[selectedIndex.row].cityName
                vc.selectedCityDesc = cities.shared.getfetchedResults()[selectedIndex.row].cityDescription
                vc.selectedCityImage = cities.shared.getfetchedResults()[selectedIndex.row].cityImage
            }
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLastRow()
    {
        let indexPath = IndexPath(row: cities().getfetchedResults().count - 1, section: 0)
        self.cityTable.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            picker.dismiss(animated: true, completion: {
                self.addRecord(selectedImage: img)
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
 
}


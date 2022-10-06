//
//  DetailViewController.swift
//  CityTables
//
//  Created by Nick Meyer on 2/24/22.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let pickerController = UIImagePickerController()

    var selectedCity:String?
    var selectedCityImage:NSData?
    var selectedCityDesc:String?
    
    
    
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var cityDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set lables and image with variables from viewcontroller
        cityImage.image = UIImage(data: selectedCityImage! as Data)
        cityName.text = selectedCity!
        cityDescription.text = selectedCityDesc!
         // Do any additional setup after loading the view.
     }

    @IBAction func editPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func editRecord(selectedImage: UIImage)
    {
        // show the alert controller to select an image for the row
        let alertController = UIAlertController(title: "Edit City", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Save", style: .default) { (aciton) in
            let desc = alertController.textFields?.last?.text

            if desc != ""{
                
                cities.shared.editCity(name: self.selectedCity, desc: desc, img: selectedImage)
                self.cityImage.image = selectedImage
                self.cityDescription.text = desc
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter a short descripion..."})
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    override func didReceiveMemoryWarning() {
         super.didReceiveMemoryWarning()
         // Dispose of any resources that can be recreated.
     }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            picker.dismiss(animated: true, completion: {
                self.editRecord(selectedImage: img)
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }

}

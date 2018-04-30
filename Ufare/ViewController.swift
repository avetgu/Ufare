//
//  ViewController.swift
//  Ufare
//
//  Created by Avery Gu on 4/29/18.
//  Copyright © 2018 Gu. All rights reserved.
//

import UIKit
import GooglePlaces

class ViewController: UIViewController {
    
    @IBOutlet weak var pickupTextField: UITextField!
    @IBOutlet weak var dropoffTextField: UITextField!
    @IBOutlet weak var compareButton: UIButton!
    @IBOutlet var loadingView: UIView!
    
    var whichTextField: UITextField!
    var pickupAddress: String = ""
    var dropoffAddress: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoadingScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        enableDisableButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFares" {
            let destination = segue.destination as! FareVC
            destination.pickupAddress = self.pickupAddress
            destination.dropoffAddress = self.dropoffAddress
        }
    }
    
    func showLoadingScreen(){
        loadingView.bounds.size.width = view.bounds.width
        loadingView.bounds.size.height = view.bounds.height
        loadingView.center = view.center
        
        loadingView.alpha = 1
        view.addSubview(loadingView)
        UIView.animate(withDuration: 30, delay: 0.03, options: [], animations: {self.loadingView.alpha = 1}) { (success) in
            self.hideLoadingScreen()
        }
    }
    
    func hideLoadingScreen() {
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.loadingView.transform = CGAffineTransform(translationX: 0, y: 10) }) { (success) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.loadingView.transform = CGAffineTransform(translationX: 0, y: -800)
                })
        }
    }
    
    func enableDisableButton(){
        if pickupTextField.text == "" || dropoffTextField.text == "" {
            compareButton.isEnabled = false
        }
        if pickupTextField.text != "" && dropoffTextField.text != "" {
            compareButton.isEnabled = true
        }
    }
    
    //MARK:- Pickup IBAction FUNCTIONS
    @IBAction func pickupTextFieldDidBeginEditing(_ sender: UITextField) {
        whichTextField = pickupTextField
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    //MARK:- Dropoff IBAction FUNCTIONS
    @IBAction func dropoffTextFieldDidBeginEditing(_ sender: UITextField) {
        whichTextField = dropoffTextField
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
}

//MARK:- GooglePlaces EXTENSION
extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let nullAttributedString = NSAttributedString(string: "null")
        
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress ?? "null")")
        print("Place attributions: \(place.attributions ?? nullAttributedString)")
        dismiss(animated: true, completion: nil)
        
        if whichTextField == pickupTextField {
            self.pickupTextField.text = place.formattedAddress
            pickupAddress = place.formattedAddress!
            print("****PICKUP ADDRESS: \(pickupAddress)")
        } else {
            self.dropoffTextField.text = place.formattedAddress
            dropoffAddress = place.formattedAddress!
            print("****DROPOFF ADDRESS: \(dropoffAddress)")
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}


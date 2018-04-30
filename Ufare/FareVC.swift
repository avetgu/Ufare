//
//  FareVC.swift
//  Ufare
//
//  Created by Avery Gu on 4/29/18.
//  Copyright © 2018 Gu. All rights reserved.
//

import UIKit
import CoreLocation

class FareVC: UIViewController {

    @IBOutlet weak var pickupAddressLabel: UILabel!
    @IBOutlet weak var dropoffAddressLabel: UILabel!
    
    @IBOutlet weak var uberPoolFareLabel: UILabel!
    @IBOutlet weak var uberXFareLabel: UILabel!
    @IBOutlet weak var uberXLFareLabel: UILabel!
    @IBOutlet weak var uberBlackFareLabel: UILabel!
    @IBOutlet weak var uberSUVFareLabel: UILabel!
    @IBOutlet weak var uberWAVFareLabel: UILabel!
    
    @IBOutlet weak var lyftLineFareLabel: UILabel!
    @IBOutlet weak var lyftFareLabel: UILabel!
    @IBOutlet weak var lyftPlusFareLabel: UILabel!
    @IBOutlet weak var lyftPremierFareLabel: UILabel!
    @IBOutlet weak var lyftLuxFareLabel: UILabel!
    @IBOutlet weak var lyftLuxSUVFareLabel: UILabel!
    
    
    //var locationData: LocationData ? class or struct
    var pickupCoordinates: CLLocationCoordinate2D!
    var dropoffCoordinates: CLLocationCoordinate2D!
    var pickupAddress: String = ""
    var dropoffAddress: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickupAddressLabel.text = pickupAddress.uppercased()
        dropoffAddressLabel.text = dropoffAddress.uppercased()
        forwardGeocoding(address: pickupAddress, completion: { coordinate in
            self.pickupCoordinates = coordinate
            print("****PICKUP COORDINATES: \(self.pickupCoordinates)")
        })
        forwardGeocoding(address: dropoffAddress, completion: { coordinate in
            self.dropoffCoordinates = coordinate
            print("****DROPOFF COORDINATES: \(self.dropoffCoordinates)")
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if pickupCoordinates != nil && dropoffCoordinates != nil {
            getUberFares(pickupCoordinates: pickupCoordinates, dropoffCoordinates: dropoffCoordinates)
            getLyftFares(pickupCoordinates: pickupCoordinates, dropoffCoordinates: dropoffCoordinates)
        }
    }
    
    func forwardGeocoding(address: String, completion: @escaping (CLLocationCoordinate2D) -> Void) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error!)
                return
            }
            if placemarks!.count > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                completion(coordinate!)
            }
        })
    }
    
    func getUberFares(pickupCoordinates: CLLocationCoordinate2D, dropoffCoordinates: CLLocationCoordinate2D){
        let uberData: UberData = UberData(pickupLatitude: String(pickupCoordinates.latitude), pickupLongitude: String(pickupCoordinates.longitude), dropoffLatitude: String(dropoffCoordinates.latitude), dropoffLongitude: String(dropoffCoordinates.longitude))
        
        uberData.getFareEstimates(completion: { uberFares in
            self.uberPoolFareLabel.text = (uberFares.uberPool == "" ? "NA" : uberFares.uberPool)
            self.self.uberXFareLabel.text = (uberFares.uberX == "" ? "NA" : uberFares.uberX)
            self.uberXLFareLabel.text = (uberFares.uberXL == "" ? "NA" : uberFares.uberXL)
            self.uberBlackFareLabel.text = (uberFares.uberBlack == "" ? "NA" : uberFares.uberBlack)
            self.uberSUVFareLabel.text = (uberFares.uberSUV == "" ? "NA" : uberFares.uberSUV)
            self.uberWAVFareLabel.text = (uberFares.uberWAV == "" ? "NA" : uberFares.uberWAV)
        })
    }
    
    func getLyftFares(pickupCoordinates: CLLocationCoordinate2D, dropoffCoordinates: CLLocationCoordinate2D){
        let lyftData: LyftData = LyftData(pickupLatitude: String(pickupCoordinates.latitude), pickupLongitude: String(pickupCoordinates.longitude), dropoffLatitude: String(dropoffCoordinates.latitude), dropoffLongitude: String(dropoffCoordinates.longitude))
        
        lyftData.getFareEstimates(completion: { lyftFares in
            self.lyftLineFareLabel.text = (lyftFares.lyftLine == "" ? "NA" : lyftFares.lyftLine)
            self.lyftFareLabel.text = (lyftFares.lyft == "" ? "NA" : lyftFares.lyft)
            self.lyftPlusFareLabel.text = (lyftFares.lyftPlus == "" ? "NA" : lyftFares.lyftPlus)
            self.lyftPremierFareLabel.text = (lyftFares.lyftPremier == "" ? "NA" : lyftFares.lyftPremier)
            self.lyftLuxFareLabel.text = (lyftFares.lyftLux == "" ? "NA" : lyftFares.lyftLux)
            self.lyftLuxSUVFareLabel.text = (lyftFares.lyftLuxSUV == "" ? "NA" : lyftFares.lyftLuxSUV)
        })
    }
}

































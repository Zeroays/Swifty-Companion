//
//  IntraViewController.swift
//  
//
//  Created by Vasu Rabaib on 11/28/19.
//

import UIKit

class IntraViewController: UIViewController {
    
    var userData: APIUserData?
    
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var intraLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var intraPhoto: UIImageView!
    @IBOutlet weak var levelProgressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.displayImage()
        self.displayName()
        self.displayIntra()
        self.displayLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    @IBAction func enterNewIntra(_ sender: UIButton) {
        self.displayName()
        self.dismiss(animated: true, completion: nil)
    }
    
    func displayName() {
        displayNameLabel.text = userData!.displayname
    }
    
    func displayIntra() {
        intraLabel.text = userData!.login
    }
    
    func displayLocation() {
        if let loc = userData!.location {
            locationLabel.text = loc
        } else {
            locationLabel.text = "Unavailable"
        }
    }
    
    func displayImage() {
        let imgLink = userData!.image_url
        let url = URL(string: imgLink)
        let data = try? Data(contentsOf: url!)

        if let imageData = data {
            let photo = UIImage(data: imageData)
            intraPhoto.image = photo
        }
    }
    
}

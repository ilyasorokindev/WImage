//
//  ViewController.swift
//  WImageExample
//
//  Created by Ilya Sorokin on 09.11.2020.
//

import UIKit
import WImage

class ViewController: UIViewController {

    @IBOutlet weak var imageViewBottom: UIImageView!
    @IBOutlet weak var imageViewTop: UIImageView!
    @IBOutlet weak var `switch`: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setButtomImage()
    }

    @IBAction func onSwitch(_ sender: Any) {
        if self.switch.isOn {
            WImage.shared.load(url: Constants.url1, completion: { image in
                self.imageViewTop.image = image
            })
        } else {
            self.imageViewTop.image = nil
        }
        self.setButtomImage()
    }
    
    private func setButtomImage() {
        WImage.shared.load(url: Constants.url2, width: self.switch.isOn ? self.view.frame.width : 100.0, priority: Priority.normal, completion: { image in
            self.imageViewBottom.image = image
        })
    }
}


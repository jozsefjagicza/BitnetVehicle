//
//  ViewController.swift
//  BitnetVehicle
//
//  Created by József Jagicza on 2021. 04. 08..
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var splashView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.removeSplashView()
    }


    func removeSplashView() {
        UIView.animate(withDuration: 2, delay: 3, options: .transitionCurlDown, animations: {
            self.splashView.alpha = 0
        }) { _ in
            self.splashView.removeFromSuperview()
        }
    }
}


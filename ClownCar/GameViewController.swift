//
//  GameViewController.swift
//  ClownCar
//
//  Created by Elombe Kisala on 10/23/16.
//  Copyright © 2016 LiveLombs. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds

class GameViewController: UIViewController, GADBannerViewDelegate {
    
    
    @IBOutlet var bannerView: GADBannerView!
    
    
    var min = 4
    
    var tryAgain = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        
        
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-2382471766301173/1740184444"
        bannerView.rootViewController = self
        bannerView.load(request)
        
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //Rate My App
    override func viewDidAppear(_ animated: Bool) {
        runAlert()
    }
    
    func runAlert() {
        
        let neverShow = UserDefaults.standard.bool(forKey: "neverShow")
        
        print(neverShow)
        
        var numLaunch = UserDefaults.standard.integer(forKey: "numLaunch") + 1
        
        if !neverShow && numLaunch == min || numLaunch >= (min + tryAgain + 1) {
            
            showRateMe()
            
            numLaunch = min + 1
            
        }
        
        UserDefaults.standard.set(numLaunch, forKey: "numLaunch")
        
    }
    
    func showRateMe() {
        
        let alert = UIAlertController(title: "Rate Us", message: "Thanks for playing Clown Car", preferredStyle: UIAlertControllerStyle.alert)
        
        let link = URL(string: "itms-apps://itunes.apple.com/app/id1168437116")
        
        let rateAction = UIAlertAction(title: "Rate This App", style: UIAlertActionStyle.default) { (alertAction) in
            
            UIApplication.shared.openURL(link!)
            
        }
        
        let neverAction = UIAlertAction(title: "No Thanks", style: UIAlertActionStyle.default) { (alertAction) in
            
            UserDefaults.standard.set(true, forKey: "neverShow")
            
        }
        
        let maybeAction = UIAlertAction(title: "Maybe Later", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(rateAction)
        
        alert.addAction(neverAction)
        
        alert.addAction(maybeAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
}


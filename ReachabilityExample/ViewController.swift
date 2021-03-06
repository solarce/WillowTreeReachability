//
//  ViewController.swift
//  Reachability
//
//  Created by Erik LaManna on 8/28/15.
//  Copyright © 2015 WillowTree, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NetworkStatusSubscriber {
   
    @IBOutlet weak var connectionStatusLight: UIView!
    @IBOutlet weak var connectionStatusFlagLabel: UILabel!
    
    var reachability: Monitor?
    var reachabilitySubscription: NetworkStatusSubscription?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        self.reachability?.stopMonitoring()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.connectionStatusLight.layer.borderWidth = 1.0 / UIScreen.mainScreen().scale
        self.connectionStatusLight.layer.cornerRadius = 10.0
        self.connectionStatusLight.layer.borderColor = UIColor.blackColor().CGColor
        self.connectionStatusLight.backgroundColor = UIColor.whiteColor()
        
        self.reachability = Monitor(withURL: NSURL(string: "http://www.willowtreeapps.com")!)
        
        // Use the following for generic internet reachability
        // self.reachability = Reachability()
        
        self.reachability?.startMonitoring()
        
        
        self.reachabilitySubscription = self.reachability?.addReachabilitySubscriber(self)
        
        if let reachability = self.reachability {
            self.networkStatusChanged(reachability.reachabilityStatus)
        }
        
    }
    
    func networkStatusChanged(status: ReachabilityStatus) {
        dispatch_async(dispatch_get_main_queue()) {
            switch status {
            case .NotReachable:
                self.connectionStatusLight.backgroundColor = UIColor.redColor()
            case .ViaWifi, .ViaCellular:
                self.connectionStatusLight.backgroundColor = UIColor.greenColor()
            default:
                self.connectionStatusLight.backgroundColor = UIColor.whiteColor()
            }
            self.connectionStatusFlagLabel.text = status.description
        }

    }
}


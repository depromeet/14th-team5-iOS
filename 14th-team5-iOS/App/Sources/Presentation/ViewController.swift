//
//  ViewController.swift
//  App
//
//  Created by Kim dohyun on 11/15/23.
//

import UIKit


public class ViewController: UIViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        #if DEV
        print("load view DEV")
        self.view.backgroundColor = .purple
        #elseif PRD
        print("load view PRD")
        self.view.backgroundColor = .brown
        #endif
        
    }
}

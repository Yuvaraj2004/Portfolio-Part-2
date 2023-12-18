//
//  ViewController.swift
//  UserDefaultsTest
//
//  Created by Yuvaraj Mayank Konjeti on 18/12/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let userName = UserDefaults.standard.string(forKey: "name") {
            print("Previously saved username is \"\(userName)\"")
        } else {
            print("No username previously saved")
        }
        UserDefaults.standard.set("Hello", forKey: "name")
    }


}


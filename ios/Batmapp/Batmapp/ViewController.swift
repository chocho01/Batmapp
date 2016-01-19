//
//  ViewController.swift
//  Batmapp
//
//  Created by Martin Choraine on 19/01/2016.
//  Copyright © 2016 Martin Choraine. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var PasswordInput: UITextField!
    @IBOutlet weak var EmailInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onConnexionBtnClick(sender:AnyObject) {
        if(PasswordInput.text != nil && EmailInput.text != nil){
            print(PasswordInput.text)
            print(PasswordInput.text)
            let parameters: [String:AnyObject] = ["user": EmailInput.text!, "password": PasswordInput.text!]
            Alamofire.request(.POST, "http://batmapp.martin-choraine.fr/api/login", parameters: parameters).responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
            }
        }
    }

}


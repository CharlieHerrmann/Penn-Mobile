//
//  ViewController.swift
//  PennMobile
//
//  Created by Charlie Herrmann on 9/20/19.
//  Copyright © 2019 Charlie Herrmann. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        parseUrl(theUrl: "http://api.pennlabs.org/dining/venues")
    }
    func parseUrl(theUrl:String) {
        let url = URL(string: theUrl)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil{
                print("error, \(String(describing: error))")
                DispatchQueue.main.asyncAfter(deadline: .now() ){
                    
                }
            }
            else{
                do{
                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                    for(key, value) in parsedData{
                        print("\(key)")
                        if let venue:[String:Any] = value as?[String:Any]{
                            for (key,value) in venue {
                                if let hello:[[String:Any]] = value as?[[String:Any]]{
                                    for dict in hello{
                                        for(key,value) in dict{
                                            if(key == "name"){
                                                print(value)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                catch let error as NSError{
                    print(error)
                    DispatchQueue.main.asyncAfter(deadline:.now()){
                        
                    }
                }
            }
            
        }.resume()
    }


}


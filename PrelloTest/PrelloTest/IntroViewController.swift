//
//  IntroViewController.swift
//  PrelloTest
//
//  Created by antonio yaphiar on 11/16/17.
//  Copyright © 2017 Antonio. All rights reserved.
//
import UIKit

class IntroViewController: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: Any){
        if(checkForm()){
            WebService.shared.login(nameTF.text!, passTF.text!, completion: { (APIResponse) in
                if(APIResponse["_data"] != nil){
                    let highscore = APIResponse["_data"]?["token"]
                    let userDefaults = UserDefaults.standard
                    userDefaults.setValue(highscore, forKey: "token")
                    userDefaults.synchronize()
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "lovelistVC")
                    self.present(vc!, animated: true)
                }else{
                    let alert = UIAlertController(title: "Login fail", message: APIResponse["_message"] as? String , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    
    func checkForm() -> Bool{
        var prob : Bool = true
        var msg : String = ""
        if(prob && (nameTF.text == "")){
            msg = "Email atau Username tidak boleh kosong"
            prob = false
        }
        if(prob && ((nameTF.text?.characters.count)! < 4)){
            msg = "Email atau Username tidak valid"
            prob = false
        }
        if(prob && (passTF.text == "")){
            msg = "Password tidak boleh kosong"
            prob = false
        }
        if(prob && ((nameTF.text?.characters.count)! < 4)){
            msg = "Password tidak valid"
            prob = false
        }
        
        if(prob){
            return true
        }else{
            let alert = UIAlertController(title: "Data form tidak lengkap", message: msg , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
    }
    
    
}

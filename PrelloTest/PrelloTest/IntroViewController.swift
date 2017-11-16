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
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        hideKeyboardWhenTappedAround()
        
        let myColor = UIColor.init(rgb: 0x00C6BA)
        loginButton.layer.borderColor = myColor.cgColor
        loginButton.layer.borderWidth = 1.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: Any){
        if(WebService.shared.isInternetAvailable()){
            if(checkForm()){
                WebService.shared.login(nameTF.text!, passTF.text!, completion: { (APIResponse) in
                    if(APIResponse["_data"] != nil){
                        let token = APIResponse["_data"]?["token"]
                        let userDefaults = UserDefaults.standard
                        userDefaults.setValue(token ?? "", forKey: "token")
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
        }else{
            let alert = UIAlertController(title: "No internet", message: "Mohon nyalakan internet anda terlebih dahulu", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

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
        if(prob && ((passTF.text?.characters.count)! < 6)){
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
    
    @IBAction func forgotPassClick(_ sender: Any) {
        notReady()
    }
    
    @IBAction func signInClick(_ sender: Any) {
        notReady()
    }
    @IBAction func facebookButtonClicked(_ sender: Any) {
        notReady()
    }
    @IBAction func twitterButtonClick(_ sender: Any) {
        notReady()
    }
    
    func notReady(){
        let alert = UIAlertController(title: "Fitur belum tersedia", message: "Still in development" , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension UIViewController {
    
    // func set for dissmiss keyboard on click
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

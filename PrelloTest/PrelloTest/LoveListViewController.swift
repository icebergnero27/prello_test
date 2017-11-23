//
//  LoveListViewController.swift
//  PrelloTest
//
//  Created by antonio yaphiar on 11/23/17.
//  Copyright © 2017 Antonio. All rights reserved.
//

import UIKit

class LoveListViewcontroller: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    var data : Array<Dictionary<String,AnyObject>> = []  ;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        hideKeyboardWhenTappedAround()
        
        fetchData()
        
    }
    
    func fetchData(){
        if(WebService.shared.isInternetAvailable()){
            
                WebService.shared.loveList( completion: { (APIResponse) in
                    if(APIResponse["_data"] != nil){
                        self.data = APIResponse["_data"] as!  Array<Dictionary<String,AnyObject>>
                        self.tableView.reloadData()

                    }
                })
            
        }else{
            let alert = UIAlertController(title: "No internet", message: "Mohon nyalakan internet anda terlebih dahulu", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        let cell = self.tableView?.dequeueReusableCell(withIdentifier: "loveListCell")
        
        let temp = data[indexPath.row];
        if let titleLabel = cell?.viewWithTag(1) as? UILabel{
            let temp = data[indexPath.row] as? [String : AnyObject]
            titleLabel.text = temp?["name"] as! String
        }
        if let priceLabel = cell?.viewWithTag(2) as? UILabel{
            priceLabel.text = temp["price"] as! String
        }

        return cell!;
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }


}

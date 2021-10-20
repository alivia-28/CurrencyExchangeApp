//
//  ViewController.swift
//  CurrencyExchangeApp
//
//  Created by Alivia Guin on 10/19/21.
//

import UIKit
import SwiftyJSON
import SwiftSpinner
import Alamofire

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let baseURL = "https://free.currconv.com/api/v7/convert?q="
    let apiKey = "19cf7165bd4dfe1867fb"
    var currencies = ["USD", "CAD", "EUR", "JPY", "INR"]

    
    @IBOutlet weak var from: UITextField!
    @IBOutlet weak var to: UITextField!
    @IBOutlet weak var pickerFrom: UIPickerView!
    @IBOutlet weak var pickerTo: UIPickerView!
    @IBOutlet weak var lblValue: UILabel!
    
    override func viewDidLoad() {
        
        pickerFrom.delegate = self
        pickerFrom.dataSource = self
        pickerTo.delegate = self
        pickerTo.dataSource = self
        super.viewDidLoad()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerFrom.tag == 1 {
            return currencies.count
        }
        if pickerTo.tag == 2 {
            return currencies.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerFrom.tag == 1 {
            return currencies[row]
            
        }
        if pickerTo.tag == 2 {
            return currencies[row]
            
        }
        return ""
    }
    
    @IBAction func getConvertedValue(_ sender: Any) {
        if from.text == "" || to.text == "" {
            return
        }
        let src : String = (from.text?.uppercased())!
        let dst : String = (to.text?.uppercased())!
        
        getCurrencyValue(src, dst)
    }
    
    func getCurrencyValue(_ src : String, _ dst : String) {
        let url = baseURL + src + "_" + dst + "&compact=ultra&apiKey=" + apiKey
        SwiftSpinner.show("Converting the currency")
        
        AF.request(url).responseJSON { response in
            SwiftSpinner.hide()
            
            if (response.error != nil) {
                print(response.error!)
                return
            }
            
            print(url)
            
            let convertedValue = JSON(response.data!)
            
            if (convertedValue.isEmpty) {
                self.lblValue.text = "Error occured at our end!"
                return
            }
            let key = src + "_" + dst
            let rate = convertedValue[key]
            print(rate)
            
            self.lblValue.text = " \(src) = \(rate) \(dst) "
            
        }
    }


}


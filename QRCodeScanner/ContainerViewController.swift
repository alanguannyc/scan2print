//
//  ContainerViewController.swift
//  QRCodeScanner
//
//  Created by Alan on 5/3/19.
//  Copyright © 2019 Shangguan. All rights reserved.
//

import UIKit
import RealmSwift

protocol DisplayQRcodeResultPro: NSObjectProtocol {
    func displayQRCodeResult(_ Text: String)
    
    func hideKeyboard()
}

class ContainerViewController: UIViewController, DisplayQRcodeResultPro {
    let realm = try! Realm()
    
    
    @IBOutlet weak var ResultLabel: UILabel!
    @IBOutlet weak var CopyNumField: UITextField!
    
    @IBOutlet weak var PlusOneCP: UILabel!
    @IBOutlet weak var MinusOneCP: UILabel!
    

    
    weak var delegate : DisplayQRcodeResultPro?
    
    func displayQRCodeResult(_ Text: String) {
        print(Text)
        ResultLabel.text = Text
    }
    
    func hideKeyboard() {
        CopyNumField.resignFirstResponder()
        self.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ContainerViewSegue") {
            let vc = segue.destination as! QRViewController
            vc.ResultDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        let tap = UITapGestureRecognizer(target: self, action: #selector(ContainerViewController.MinusLabelTapped(sender:)))
        MinusOneCP.isUserInteractionEnabled = true
        MinusOneCP.addGestureRecognizer(setGesture())
        
        PlusOneCP.isUserInteractionEnabled = true
        PlusOneCP.addGestureRecognizer(setGesture())
    }
    
    @objc func MinusLabelTapped(sender: UITapGestureRecognizer){
        
        var cpNum = Int(CopyNumField.text ?? "0") ?? 0
        if (sender.view?.tag == 100){
            
                cpNum += 1
                CopyNumField.text = String(describing: cpNum)
            
            
        } else {
            if (cpNum != 0) {
                cpNum -= 1
                CopyNumField.text = String(describing: cpNum)
            }
        }
        
        
    }

    func setGesture() -> UITapGestureRecognizer {
        
        var myRecognizer = UITapGestureRecognizer()
        
        myRecognizer = UITapGestureRecognizer(target: self, action: #selector(ContainerViewController.MinusLabelTapped(sender:)))
        return myRecognizer
    }
    
    @IBAction func AddCPButtenPressed(_ sender: Any) {
        var cpNum = Int(CopyNumField.text!)!
        cpNum = cpNum + (sender as! UIButton).tag
    
        CopyNumField.text = String(describing: cpNum)
    }
    
    @IBAction func SaveButtonPressed(_ sender: Any) {
        
        saveQRcode()
    }
    
    func saveQRcode(){
        let qrcode = QRCode()
        if let content = ResultLabel.text, let number = CopyNumField.text {
            qrcode.content = content
            qrcode.number = Int(number)!
            
            try! realm.write {
                realm.add(qrcode)
            }
            
        }
        
        
        
    }
    
}

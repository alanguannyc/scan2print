//
//  ContainerViewController.swift
//  QRCodeScanner
//
//  Created by Alan on 5/3/19.
//  Copyright © 2019 Shangguan. All rights reserved.
//

import UIKit
protocol DisplayQRcodeResultPro: NSObjectProtocol {
    func displayQRCodeResult(_ Text: String)
}

class ContainerViewController: UIViewController, DisplayQRcodeResultPro {
    @IBOutlet weak var ResultLabel: UILabel!
    var vc = QRViewController()
    
    weak var delegate : DisplayQRcodeResultPro?
    
    func displayQRCodeResult(_ Text: String) {
        print(Text)
        ResultLabel.text = Text
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ContainerViewSegue") {
            let vc = segue.destination as! QRViewController
            vc.ResultDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    


}

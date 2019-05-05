//
//  ViewController.swift
//  QRCodeScanner
//
//  Created by Alan on 4/30/19.
//  Copyright © 2019 Shangguan. All rights reserved.
//

import UIKit
import RealmSwift

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var QRCodeListTableView: UITableView!
    
    let realm = try! Realm()
    var qrcodes : Results<QRCode>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        QRCodeListTableView.dataSource = self
        QRCodeListTableView.delegate = self
        QRCodeListTableView.rowHeight = UITableView.automaticDimension
        QRCodeListTableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        qrcodes = realm.objects(QRCode.self).sorted(byKeyPath: "date")
        QRCodeListTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Swift 4.2 onwards
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return qrcodes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Formate Date
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz" // This formate is input formated .
//        let formateDate = dateFormatter.date(from:"2018-02-02 06:50:16 +0000")!
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Output Formated
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "qrcodecell") as! QRCodeTableViewCell
        if let code = qrcodes?[indexPath.row]{
            
            cell.CodeLabel.text = code.content
            cell.CPNumLabel.text = String(describing: code.number)
            cell.DateLabel.text = dateFormatter.string(from: code.date)
        }
        
        return cell
    }

//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
//
//
//
//
//
//
//    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, success) in
            let id = self.qrcodes![indexPath.row].id
            let codeToDelete = self.qrcodes!.filter("id == %@",id)
            try! self.realm.write {
                self.realm.delete(codeToDelete)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            //            self.QRCodeListTableView.reloadData()
            
            UIView.transition(with: self.QRCodeListTableView, duration: 1.0, options: .curveEaseOut , animations: {self.QRCodeListTableView.reloadData()}, completion: nil)
        }
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            //            self.qrcodes.remove(at: indexPath.row)
            let id = self.qrcodes![indexPath.row].id
            let codeToDelete = self.qrcodes!.filter("id == %@",id)
            try! self.realm.write {
                self.realm.delete(codeToDelete)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            //            self.QRCodeListTableView.reloadData()
            
            UIView.transition(with: self.QRCodeListTableView, duration: 1.0, options: .curveEaseOut , animations: {self.QRCodeListTableView.reloadData()}, completion: nil)
            
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let share = UITableViewRowAction(style: .default, title: "Print") { (action, indexPath) in
            // share item at indexPath
            print("I want to share: \(self.qrcodes![indexPath.row])")
        }
        let printAction = UIContextualAction(style: .normal, title: "Print") { (action, view, success) in
            self.showAlertWithTextField()
        }
        
        printAction.backgroundColor = UIColor.brown
        
        return UISwipeActionsConfiguration(actions: [printAction])
    }
    
    
    func showAlertWithTextField() {
        let alertController = UIAlertController(title: "Input a number to print", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Print", style: .default) { (_) in
            if let txtField = alertController.textFields?.first, let text = txtField.text {
                // operations
                print("Text==>" + text)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "1"
            
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}


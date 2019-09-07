//
//  ViewController.swift
//  TestProject
//
//  Created by Shubham Vinod Kamdi on 05/09/19.
//  Copyright © 2019 Shubham Vinod Kamdi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var parentCellText: UITextField!
    @IBOutlet weak var childCellCount: UITextField!
    var data: Array <DataSource> = []
    var childArray: Array <child> = []
    var index: Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        parentCellText.delegate = self
        childCellCount.delegate = self
        for i in 0..<2{
            self.childArray.append(child(childName: "CHILD \(i + 1)"))
            if i == 1{
                self.data.append(DataSource(isExpanded: false, parentTitle: "Section 1", childArray: childArray))
                childArray = []
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }


}

struct  DataSource {
    
    var isExpanded: Bool!
    var parentTitle: String!
    var childArray: Array <child>!
    
    init(isExpanded: Bool, parentTitle: String!, childArray: Array <child>!){
            self.isExpanded = isExpanded
            self.parentTitle = parentTitle
            self.childArray = childArray
    }
}

struct child{
    
    var childName: String!
    
    init(childName: String){
        self.childName = childName
    }
}

extension ViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 20{
            if !(textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! && !parentCellText.text!.isEmpty{
                let count = Int(textField.text!)!
                for i in 0..<count {
                    childArray.append(child(childName: "CHILD \(i + 1)"))
                    if(i == count - 1){
                        data.append(DataSource(isExpanded: false, parentTitle: self.parentCellText.text, childArray: self.childArray))
                        childArray = []
                        tableView.reloadData()
                        view.endEditing(true)
                    }
                }
            }
        
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data[section].isExpanded{
            return data[section].childArray.count + 1
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ParentCell") as! ParentCell
            if data[indexPath.section].isExpanded{
                cell.plussImage.backgroundColor = UIColor.cyan
            }else{
                cell.plussImage.backgroundColor = UIColor.black
            }
            cell.parentLabel.text = data[indexPath.section].parentTitle
            return cell
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChildCell") as! ChildCell
            cell.childLabel.text = data[indexPath.section].childArray[indexPath.row - 1].childName
            return cell
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            if data[indexPath.section].isExpanded{
                data[indexPath.section].isExpanded = false
            }else{
                data[indexPath.section].isExpanded = true
            }
            let section = IndexSet.init(integer: indexPath.section)
            self.tableView.reloadSections(section, with: .automatic)
        }
        
        
    }
    
}

class ParentCell: UITableViewCell{
    @IBOutlet weak var plussImage: UIImageView!
    @IBOutlet weak var parentLabel: UILabel!
}

class ChildCell: UITableViewCell{
    @IBOutlet weak var childLabel: UILabel!
}

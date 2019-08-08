//
//  ViewController.swift
//  TodList
//
//  Created by Ganesh Achary on 08/08/19.
//  Copyright © 2019 Ganesh Achary. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let itemArray = ["Find Mike", "Buy Milk", "Buy Rice"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell =  tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
      cell.textLabel?.text = itemArray[indexPath.row]
      return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}


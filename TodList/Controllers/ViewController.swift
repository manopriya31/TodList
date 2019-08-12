//
//  ViewController.swift
//  TodList
//
//  Created by Ganesh Achary on 08/08/19.
//  Copyright © 2019 Ganesh Achary. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UITableViewController {
     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
   // let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
       print(dataFilePath)
        
        // Do any additional setup after loading the view.
//        let newItem1 = Item()
//        newItem1.title = "Buy Chocolate"
//        itemArray.append(newItem1)
//
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggs"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Buy Bread"
//        itemArray.append(newItem3)
       
        loadItems()
        
//        if let items = defaults.array(forKey: "TodoListArray") as?  [Item] {
//            itemArray = items
//        }
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell =  tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
      
        // Ternary Operator ==>
        // value = condition ? valueodtrue : valueoffalse
        
        cell.accessoryType = item.done ? .checkmark : .none
      
//        if item.done == true{
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
      return cell
    }
    
    //MARK - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
//        if itemArray[indexPath.row].done == false{
//            itemArray[indexPath.row].done = true
//        }
//        else{
//            itemArray[indexPath.row].done = false
//        }
        // To remove the data from the context and from the list
       // context.delete(itemArray[indexPath.row])
       // itemArray.remove(at: indexPath.row)
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
    }

    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle:.alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newitem = Item(context: self.context)
            newitem.title = textfield.text!
            newitem.done = false
            newitem.parentCategory = self.selectedCategory
            self.itemArray.append(newitem)
            
           // self.defaults.setValue(self.itemArray, forKey: "TodoListArray")
           
            self.saveItems()
            
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create New"
            textfield = alertTextfield
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        
        do {
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
            try context.save()
        } catch {
           print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(),predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate])
//        request.predicate = compoundPredicate
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        do{
          itemArray = try context.fetch(request)
        }
        catch{
            print("error fetching data")
        }
        tableView.reloadData()
    }
}

extension ViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        loadItems(with: request,predicate: predicate)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

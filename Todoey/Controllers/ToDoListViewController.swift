//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // in order to use UserDeafolt
    
    let defaults = UserDefaults.standard
    
   override func viewDidLoad() {
        super.viewDidLoad()
       
      loadItem()
 
    }

    //MARK: - TableView DataSourse Method
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary operator ==>
        //value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    // MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        
//        context.delete(itemArray[indexPath.row])
       // itemArray.remove(at: indexPath.row)
   
       itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
       /*
        if itemArray[indexPath.row].done == false {
            itemArray[indexPath.row].done = true
        } else {
            itemArray[indexPath.row].done = false
        } */
        
        saveItems()
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
  //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //create local variable
        
        var textField = UITextField()
        
        // Create the alert controller.
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the Add Item button on our UIalert
          
            
            var newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            self.itemArray.append(newItem)
            self.saveItems()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            print(alertTextField.text)
            // add local variable to extending the scope of alertTextField to AddButtonPressed
            textField = alertTextField
            
            
        
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK: - Model Manipulation methods
    
    func saveItems() {
        
        
       
       do {
          
           try context.save()
            
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItem(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
       //
        do {
         itemArray = try context.fetch(request)
        } catch {
            print("Error fatching data from context \(error)")
        }
        tableView.reloadData()
        }

}

//MARK: - Search bar methods

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
       
     loadItem(with: request)
        
    
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItem()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
    

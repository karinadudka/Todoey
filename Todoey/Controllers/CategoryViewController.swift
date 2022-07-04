//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Карина Дудка on 03.07.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
//MARK: - TableView DataSourse Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCategoryCell", for: indexPath)
        
        let category = categories[indexPath.row].name
        
        cell.textLabel?.text = category

    
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
//MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
    }
        
        
        saveCategories()
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
      }
  
    
    //MARK: - Add New Categories
      
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
          
          //create local variable
          var textField = UITextField()
          
          // Create the alert controller.
          let alert = UIAlertController(title: "Add new Todoey Category", message: "", preferredStyle: .alert)
          let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
              // What will happen once the user clicks the Add Item button on our UIalert
             var newCategory = Category(context: self.context)
              newCategory.name = textField.text!
              
              self.categories.append(newCategory)
              self.saveCategories()
              self.tableView.reloadData()
          }
          
          alert.addTextField { (alertTextField) in
              alertTextField.placeholder = "Create new category"
              textField = alertTextField
    }
          
          alert.addAction(action)
          present(alert, animated: true, completion: nil)
          
    }
    
//MARK: - Data Manipulation Methods
   
    func saveCategories() {
         do {
          try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
       //
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fatching data from context \(error)")
        }
        tableView.reloadData()
        }

    
    
}
 


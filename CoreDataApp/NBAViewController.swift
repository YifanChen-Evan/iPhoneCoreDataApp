//
//  NBAViewController.swift
//  CoreDataApp
//
//  Created by 橙子🍊 on 15/04/2022.
//

import UIKit
import CoreData

class NBAViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // define core data objects (context)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // define core data objects (managed object)
    var pManagedObject : Player! = nil
    
    // define core data objects (entity)
    var pEntity : NSEntityDescription! = nil
    
    // define core data objects (fetch results controller)
    var frc : NSFetchedResultsController<NSFetchRequestResult>! = nil

    // define core data functions
    func makeRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NBA")
        
        // define predicates and sorters
        let sorter = NSSortDescriptor(key: "gameName", ascending: true)
        request.sortDescriptors = [sorter]
        
        return request
    }
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()
    
    private var models = [NBA]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "NBA Game List"
        view.addSubview(tableView)
        getAllItems()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Game", message: "Enter new game", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: {[weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
            return
            }
            self?.createItem(name: text)
        }))
        
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.gameName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = models[indexPath.row]
        
        let sheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            
            let alert = UIAlertController(title: "Edit Game", message: "Edit game information", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.gameName
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: {[weak self] _ in
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                    return
                }
                
                self?.updateItem(item: item, newName: newName)
            }))
            
            self.present(alert, animated: true)
        }))
        
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteItem(item: item)
        }))
        present(sheet, animated: true)
    }
    
    // Core Data
    func getAllItems() {
        do {
            models = try context.fetch(NBA.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            print("Core Data Cannot Fetch")
        }
    }

    func createItem(name: String) {
        let newItem = NBA(context: context)
        newItem.gameName = name
        newItem.createdAt = Date()
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
            
        }
    }
    
    func deleteItem(item: NBA) {
        context.delete(item)
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
            print("Core Data Cannot Fetch")
        }
    }
    
    func updateItem(item: NBA, newName: String) {
        item.gameName = newName
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
            print("Core Data Cannot Fetch")
        }
    }

}

//
//  ViewController.swift
//  NamesCoreData
//
//  Created by Abdul Nasir on 12/22/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var people:[NSManagedObject] = []
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
      title = "Students"
        fetchContents()
    }
    @IBAction func addName(_ sender: Any) {
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            
            // unowned self is called capture list
            
        guard let textField = alert.textFields?.first else {return}
        guard let nameToSave = textField.text else {return}
       
        guard let textFieldAge = alert.textFields?.last else {return}
        guard let ageToSave = textFieldAge.text else {return}
          
        saveName(nameToSave: nameToSave,ageToSave:ageToSave )
            self.tableView.reloadData()
        }
       let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
       
        alert.addTextField()
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
       
        present(alert, animated: true, completion: nil)
    
    }
   // Mark: coreData method for append contact in people array
   
    func saveName(nameToSave:String,ageToSave:String){
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
       
        person.setValue(nameToSave, forKey: "name")
        person.setValue(ageToSave, forKey: "age")
        people.append(person)
        saveContext()
    }
   // Mark: coreData method for saving
    func saveContext(){
        do{
            try managedContext.save()
        }catch let error as NSError{
            print("could not save. \(error)")
        }
    }
// Mark: coreData method for fetching the data from persistant container
    func fetchContents () {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
            do{
                people = try managedContext.fetch(fetchRequest)
            } catch (let error as NSError) {
                print("could not save. \(error)")
            }
        }
    }
extension ViewController:UITableViewDelegate,UITableViewDataSource {
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return people.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell") as! TableCell
//    let currentName  = people[indexPath.row]
//    let currentAge = people[indexPath.row]
    
   // cell.textLabel?.text?.first = currentName.value(forKey: "name") as? String
   // cell.textLabel?.text?.last = currentAge.value(forKey: "age") as? String
    cell.nameLabel.text = people[indexPath.row].value(forKey: "name") as? String
    cell.ageLabel.text = people[indexPath.row].value(forKey: "age") as? String
   
    return cell

     }
   // Mark: method to delete from coreData
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        managedContext.delete(people[indexPath.row])
        tableView.reloadData()
        saveContext()
    }
}

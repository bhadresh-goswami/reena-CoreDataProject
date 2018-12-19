//
//  ViewController.swift
//  CoreDataProject
//
//  Created by Mac on 19/12/18.
//  Copyright © 2018 tops. All rights reserved.
//

import UIKit
//step 1
import CoreData

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    @IBOutlet weak var btnDelete: UIButton!
    
    
    
    @IBOutlet weak var txtCourse: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var tblInfo: UITableView!
    //step 2
    //database
    var managedContextObject:NSManagedObjectContext!
    //model data: table's row
    var managedObject:NSManagedObject!
    //list
    var list:[NSManagedObject]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       btnDelete.isHidden = true
    //step 3
    
        let appDel = UIApplication.shared.delegate as! AppDelegate
        self.managedContextObject = appDel.persistentContainer.viewContext
        
        //step call save method
        /*savedata(nm: "bhadresh", c: ".net")
        savedata(nm: "krina", c: "ios")
        savedata(nm: "abhi", c: "ios")
        savedata(nm: "rakesh", c: "ios")*/
        
        listData()
        
    }
    
    //step 4
    func savedata(nm:String, c:String)
    {
        if self.editData == nil
        {
            let infoEntity = NSEntityDescription.entity(forEntityName: "Info", in: self.managedContextObject!)
        
            self.managedObject = NSManagedObject(entity: infoEntity!, insertInto: self.managedContextObject!)
        
            self.managedObject.setValue(nm, forKey: "name")
            self.managedObject.setValue(c, forKey: "course")
        
            do{
                try self.managedContextObject.save()
                print("Data Saved!")
            }
            catch let err as NSError{
                print(err.localizedDescription)
            }
        }
        else
        {
            
            
            self.editData.setValue(nm, forKey: "name")
            self.editData.setValue(c, forKey: "course")
            listData()
            do{
                try self.managedContextObject.save()
                print("Data updates!")
            }
            catch let err as NSError{
                print(err.localizedDescription)
            }
            self.editData = nil
        }
        
    }
    
    
    //step 5
    func listData(){
        
        
        let fetchReq = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Info")
        
        do{
            self.list = try self.managedContextObject.fetch(fetchReq) as! [NSManagedObject]
            for item in self.list{
                print("Name:\(item.value(forKey: "name")!) and Course:\(item.value(forKey: "course")!)")
            }
        }
        catch{
            print("Error in fetch")
        }
        
        tblInfo.reloadData()
        
    }
    
    
    //step 6 table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)
        
        cell.textLabel?.text = "\(self.list[indexPath.row].value(forKey: "name")!)"
        cell.detailTextLabel?.text = "\(self.list[indexPath.row].value(forKey: "course")!)"
        
        
        return cell
    }
    //to update
    var editData:NSManagedObject!
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.editData = self.list[indexPath.row]
        txtCourse.text = "\(self.editData.value(forKey: "course")!)"
          txtName.text = "\(self.editData.value(forKey: "name")!)"
        btnDelete.isHidden = false
    }
    
    
    
    @IBAction func btnDeleteAction(_ sender: UIButton) {
        
        if self.editData != nil{
            do{
                 self.managedContextObject.delete(self.editData)
                try self.managedContextObject.save()
                print("data deleted")
                self.listData()
            }
            catch{
                print("Error in delete")
            }
        }
        btnDelete.isHidden = true
        
    }
    @IBAction func btnSaveAction(_ sender: UIButton) {
        
        savedata(nm: txtName.text!, c: txtCourse.text!)
        listData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


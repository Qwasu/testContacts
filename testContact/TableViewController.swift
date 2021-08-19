//
//  ViewController.swift
//  PhoneContacts
//
//  Created by Павел Горбунов on 19.08.2021.
//


import UIKit
import Contacts

class TableViewController: UITableViewController {
    
    var contacts = [CNContact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status == .denied || status == .restricted {
            presentSettingsAlert()
            return
        }
        
        
        let contactStore = CNContactStore()
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                    CNContactPhoneNumbersKey] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        
        do {
            try contactStore.enumerateContacts(with: request){
                (contact, stop) in
                
                self.contacts.append(contact)
                
            }
            print(contacts)
        } catch {
            print("unable to fetch contacts")
        }
        
        

    }
    
    
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var FNM = ""
        FNM = contacts[indexPath.row].familyName + " " + contacts[indexPath.row].middleName + " " + contacts[indexPath.row].givenName
        
        cell.textLabel?.text = FNM
        cell.detailTextLabel?.text = contacts[indexPath.row].phoneNumbers.first?.value.stringValue
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let number = contacts[indexPath.row].phoneNumbers.first?.value.stringValue{
            
            let formattedNumber = number.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
            print(formattedNumber)
            
            if let url = NSURL(string: ("tel://" + (formattedNumber))) {
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
               
            }
        }
    }
    
    private func presentSettingsAlert() {
        let settingsURL = URL(string: UIApplication.openSettingsURLString)!
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Permission to Contacts", message: "This app needs access to contacts in order to ...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Go to Settings", style: .default) { _ in
                UIApplication.shared.open(settingsURL)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    
}




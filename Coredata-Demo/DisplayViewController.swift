//
//  DisplayViewController.swift
//  Coredata-Demo
//
//  Created by Deepak Tanwar on 03/06/23.
//

import UIKit

protocol DisplayViewProtocol : AnyObject {
    func editProfile(user : User) -> Void
}

class DisplayViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate : DisplayViewProtocol?
    
    private var userData : [User] = []
    private let DBobj = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserData()

    }
    
    func fetchUserData(){
        userData =  DBobj.read()
        reloadTable()
    }
    
    private func reloadTable(){
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    
    
    func deleteRow(index : User, indexRow : Int){
        self.DBobj.delete(user: index)
        self.userData.remove(at: indexRow)
        self.reloadTable()
    }
}

extension DisplayViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "displayTableViewCell") as? displayTableViewCell else {
            return UITableViewCell()
        }
        let data = userData[indexPath.row]
        cell.fullname.text = data.name
        cell.email.text = data.email
        if let image = Helper.Shared.fetchImageFromDocumentDiretory(imageName: data.image){
                cell.imgView.image = image
        } else{
            cell.imgView.image = UIImage(systemName: "person.crop.circle.fill.badge.plus")
        }
        
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
          let TrashAction = UIContextualAction(style: .normal, title:  "Delete", handler: { [weak self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void)  in
             guard let index = self?.userData[indexPath.row]
                      else {  success(false)
                            return
                        }
                    self?.deleteRow(index: index, indexRow : indexPath.row)
                    success(true)
               })
        
               TrashAction.backgroundColor = .red
        
          let UpdateAction = UIContextualAction(style: .normal, title:  "Edit", handler: { [weak self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
              guard let index = self?.userData[indexPath.row] else{return}
              self?.delegate?.editProfile(user: index)
              self?.navigationController?.popViewController(animated: true)
                   success(true)
               })
        
        UpdateAction.backgroundColor = .gray
        return UISwipeActionsConfiguration(actions: [TrashAction,UpdateAction])

    }
    
}
extension DisplayViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    
}

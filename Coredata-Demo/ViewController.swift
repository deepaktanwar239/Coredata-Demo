//
//  ViewController.swift
//  Coredata-Demo
//
//  Created by Deepak Tanwar on 01/06/23.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var addBtn: UIButton!
    
    var updatedImage : String?
    var entityUser : User?
    
    private let dataManagerObj = DataManager()
    var picker:UIImagePickerController? = UIImagePickerController()
    var didImagePic : Bool = false
    var isImageUpdated : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        img.layer.cornerRadius = img.frame.size.height/2
        addGesture()
    }
    

    @IBAction func didTapAddButton(_ sender: UIButton) {
        
        guard let fullname = self.nameTxt.text, !fullname.isEmpty else{
            callAlert(msg: "Please enter fullname")
            return
        }
        guard let email = self.emailTxt.text, !email.isEmpty else{
            callAlert(msg: "Please enter email")
            return
        }
        //check for valid email addresss
        guard let pwd = self.passwordTxt.text, !pwd.isEmpty else{
            callAlert(msg: "Please enter password")
            return
        }
        
        let buttonTitle  =  sender.titleLabel?.text
        
        
        guard didImagePic else{
            callAlert(msg: "Please select image")
            return
        }
                    
        if buttonTitle == "ADD" {
            
            let imageName = UUID().uuidString + ".png"
            let data = UserData(fullname: fullname, email: email
                                , pwd: pwd, img: imageName)
            dataManagerObj.create(data: data)
            saveImageInLocalDirectory(imageName: imageName)
            
        } else if buttonTitle == "UPDATE" {
            
            var  imageName : String?
            if(isImageUpdated) {
                 imageName = UUID().uuidString + ".png"
                 saveImageInLocalDirectory(imageName: imageName!)
                
            }else{
                imageName = updatedImage
            }
            
            let data = UserData(fullname: fullname, email: email
                                , pwd: pwd, img: imageName)
            dataManagerObj.update(data: data, entityUser : entityUser!)
        }
        
        let msg = "Record \(String(describing: buttonTitle ?? "Add  ")) successfuly"
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default,handler: { UIAlertAction in
            self.gonext()
        })
        )
        present(alert, animated: true)
    }


    @IBAction func didShowBtnTap(_ sender: Any) {
        self.gonext()
    }
    
    func gonext(){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "DisplayViewController") as? DisplayViewController else{
            return
        }
        vc.delegate = self
        self.resetData()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func resetData(){
        self.nameTxt.text = ""
        self.emailTxt.text = ""
        self.passwordTxt.text = ""
        didImagePic = false
        isImageUpdated = false
        self.img.image = UIImage(systemName: "person.crop.circle.fill.badge.plus")
        self.addBtn.setTitle("ADD", for: .normal)
    }
   
}
extension ViewController{
    func addGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapGesture))
        img.addGestureRecognizer(tapGesture)
        img.isUserInteractionEnabled = true
        picker?.delegate = self
    }
    
    @objc func tapGesture() {
        let alert = UIAlertController(title: "Profile Picture Options", message: nil, preferredStyle: .actionSheet)
        let gallaryAction = UIAlertAction(title: "Open Photo Gallary", style: .default) { _ in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { UIAlertAction in
            self.cancel()
        }
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
     }
    
    func openGallary(){
        picker?.allowsEditing = false
        picker?.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(picker!, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{
            return
        }
        img.contentMode = .scaleAspectFill
        img.image = pickedImage
        self.didImagePic = true
        self.isImageUpdated = true
        dismiss(animated: true)
    }
    
    func saveImageInLocalDirectory(imageName : String){
        do {
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentsDirectory.appendingPathComponent(imageName)

                    guard let imageData = img.image?.pngData() else{
                        return
                    }
                
            try imageData.write(to: fileURL)
                   
        } catch {
            print("Saving image to Document Directory error::", error)
        }

    }
    
    
    func cancel(){
        
    }
}

extension ViewController : DisplayViewProtocol{
    
    func editProfile(user: User) {
        self.entityUser = user
        self.nameTxt.text = user.name
        self.emailTxt.text = user.email
        self.passwordTxt.text = user.password
        if let image = Helper.Shared.fetchImageFromDocumentDiretory(imageName: user.image){
            self.img.image = image
            updatedImage = user.image
        } else{
            self.img.image = UIImage(systemName: "person.crop.circle.fill.badge.plus")
        }
        self.didImagePic = true
        self.addBtn.setTitle("UPDATE", for: .normal)
    }
    
}

extension ViewController {
    func callAlert(msg : String){
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

//
//  AddPropertyViewController.swift
//  MyHomeBuy
//
//  Created by Vikas on 05/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import MBProgressHUD
import Toast_Swift
class AddPropertyViewController: UIViewController {
    let  imagePicker =  UIImagePickerController()
    var imageArray = [Any]()
    var dropDownArray = [String]()
    var currentIndex = -1
    var currentTextField : UITextField?
    @IBOutlet weak var propertyTableView: UITableView!
    @IBOutlet weak var navigationBarView: UIView!
    let headingText = ["Price" , "Area/size" , "Bedrooms" , "Rest/Bathrooms", "Car parking in Garage" , "Address", "Description" , "Agent Name", "Agent Contact" ]
    let placeHolderText = ["Enter Price" , "Enter Area" , "Bedrooms" , "Rest/Bathrooms", "Car parking in Garage" , "Enter Address", "Enter Description" , "Enter Agent Name", "Enter Agent Contact" ]
    let model = AddPropertyModel()
    var canAdd = true
    @IBOutlet weak var titleLabel: UILabel!
    // dropdownpopup
    
    @IBOutlet var dropDownView: UIView!
    
    @IBOutlet weak var dropDownPickerView: UIPickerView!
    
    // footerview
    @IBOutlet weak var imageCollectioView: UICollectionView!
    
    @IBOutlet var footerView: UIView!
    
    @IBOutlet weak var addPropertyBtn: UIButton!
    var propertyModel = GetPropertyDetailModel(dictionary: ["" : ""])
    let numberFormatter = NumberFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal

        // Do any additional setup after loading the view.
        if(canAdd){
        model.initArray()
        navigationBarView.setBottomShadow()
        propertyTableView.delegate  = self
        propertyTableView.dataSource = self
        propertyTableView.rowHeight = UITableViewAutomaticDimension
        propertyTableView.estimatedRowHeight = 100
        for i in 0..<5 {
            dropDownArray.append("\(i+1)")
        }
        }else{
            titleLabel.text = "Edit Property"
            //requestPropertyAPI()
            
          //  model.price = (propertyModel?.price)!
            if let myInteger = Float((propertyModel?.price)!) {
                let myNumber = NSNumber(value:myInteger)
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = NumberFormatter.Style.decimal
                let price = numberFormatter.string(from: myNumber)
                
                
               // priceLbl.text = "$ \(price!)"
                model.price = price!
            }
            model.area_sqft = (propertyModel?.area_sqft)!
            model.bedrooms = (propertyModel?.bedrooms)!
            model.bathrooms = (propertyModel?.bathrooms)!
            model.car_parking_garage = (propertyModel?.car_parking_garage)!
            model.address = (propertyModel?.address)!
            model.description = (propertyModel?.description)!
            model.agent_name = (propertyModel?.agent_name)!
            model.agent_contact = (propertyModel?.agent_contact)!
             model.propertyId = (propertyModel?.id)!
            if let validimage = propertyModel?.image{
               model.imageUrls = validimage

            }
            if(!model.imageUrls.isEmpty){
               let urlArray =  model.imageUrls.components(separatedBy: ",")
                for url in urlArray {
                imageArray.append(url)
                }
            }
            model.initArray()
            navigationBarView.setBottomShadow()
            propertyTableView.delegate  = self
            propertyTableView.dataSource = self
            propertyTableView.rowHeight = UITableViewAutomaticDimension
            propertyTableView.estimatedRowHeight = 100
            for i in 0..<5 {
                dropDownArray.append("\(i+1)")
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        frostedViewController.panGestureEnabled = true
        addFooterView()
        
    }
    
    func addFooterView(){
        footerView.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 300))
        propertyTableView.tableFooterView = footerView
        imageCollectioView.delegate = self
        imageCollectioView.dataSource = self
        addPropertyBtn.setRadius(10)
        if(canAdd){
        addPropertyBtn.setTitle("ADD PROPERTY DETAILS", for: .normal)
        }else{
        addPropertyBtn.setTitle("EDIT PROPERTY DETAILS", for: .normal)

        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuBtnPressed(_ sender: Any) {
        frostedViewController.presentMenuViewController()
    }
    
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dropDownView.removeFromSuperview()
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        let navController : UINavigationController  = storyboard?.instantiateViewController(withIdentifier: "SlidingNavigationController") as! UINavigationController
        var controller: UIViewController!
        
        controller = storyboard?.instantiateViewController(withIdentifier: "MyHomeViewController") as? MyHomeViewController
        
        navController.viewControllers = [controller]
        
        frostedViewController.contentViewController = navController
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        
        let value = dropDownArray[dropDownPickerView.selectedRow(inComponent: 0)]
        currentTextField?.text = value
        model.dataArray[currentIndex] = value
        dropDownView.removeFromSuperview()
        
        
    }
    
    @IBAction func addPropertyBtnPressed(_ sender: Any) {
        view.endEditing(true)
        if(model.isValidForSubmission() == "OK"){
//            if(imageArray.count <= 0){
//                view.makeToast("Please select atleast one image")
//
//            }else{
            if(canAdd){
                requestAddPropertyAPI()
            }else{
                requestEditPropertyAPI()
            }
                
           // }
        }else{
            view.makeToast(model.isValidForSubmission())
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension AddPropertyViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headingText.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 5 || indexPath.row == 6){
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddPropertyTextViewTableCell", for: indexPath) as! AddPropertyTextViewTableCell;
            cell.nameLbl.text  = headingText[indexPath.row]
            cell.descTextView.placeholder = placeHolderText[indexPath.row]
            cell.descTextView.tag = indexPath.row
            cell.descTextView.setRadius(5)
            cell.descTextView.text = model.dataArray[indexPath.row]
            cell.descTextView.delegate = self
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddPropertyTextFieldTableCell", for: indexPath) as! AddPropertyTextFieldTableCell;
            cell.nameLbl.text  = headingText[indexPath.row]
            if indexPath.row == 0{
               let value = model.dataArray[indexPath.row].replacingOccurrences(of: ",", with: "")
                if let myInteger = Double(value) {
                    let myNumber = NSNumber(value:myInteger)
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = NumberFormatter.Style.decimal
                    let price = numberFormatter.string(from: myNumber)
                    // priceLbl.text = "$ \(price!)"
                    
                    let myPrice = (price! as NSString).doubleValue
                    let strValue = String(format: "%.2f", myPrice)
                    cell.descTextField.text = "\(strValue)"
                    
                   // cell.descTextField.text = "\(price!).00"
                }
                
            }
            else{
            cell.descTextField.text = model.dataArray[indexPath.row]
            }
            cell.descTextField.placeholder = placeHolderText[indexPath.row]
            if(indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4){
                cell.dropDownImageView.isHidden = false
                
            }else{
                cell.dropDownImageView.isHidden = true
                
            }
            if(indexPath.row == 0 || indexPath.row == 1){
                cell.descTextField.keyboardType = .decimalPad
            }else if (indexPath.row == headingText.count-1){
                cell.descTextField.keyboardType = .numberPad
                
            }else if(indexPath.row == headingText.count-2){
                cell.descTextField.keyboardType = .default
            }
            if(indexPath.row == 0){
            cell.descTextField.setLeftLabel("$", UIColor.lightBlue)
            }else{
                cell.descTextField.applyPadding(padding: 5)
            }
            cell.descTextField.tag = indexPath.row
            cell.descTextField.delegate = self
            cell.descTextField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                         for: UIControlEvents.editingChanged)
            cell.descTextField.setRadius(5)
            return cell
        }
    }
    func textFieldDidChange(_ textField: UITextField) {
        if textField.tag == 0 {
            let value = textField.text?.replacingOccurrences(of: ",", with: "")
            if(textField.text?.last == "."){
                return
            }
            if let myInteger = Double(value!) {
                let myNumber = NSNumber(value:myInteger)
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = NumberFormatter.Style.decimal
                let price = numberFormatter.string(from: myNumber)
                // priceLbl.text = "$ \(price!)"
                textField.text = price
            }
        }
        model.dataArray[textField.tag] = textField.text!
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let nsString = NSString(string: textField.text!)
        let newText = nsString.replacingCharacters(in: range, with: string)
        if(!newText.isEmpty){
            let value = Double(newText.replacingOccurrences(of: ",", with: ""))
            guard let validValue = value else{return false}
            print(validValue)
        }
        let arr = newText.components(separatedBy: ".")
        if(arr.count == 2){
            let num = arr.last
            if((num?.count)! >= 3 ){
                return false
            }
        }
        return true
    }
}
extension AddPropertyViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("data \(model.dataArray)")
        
    }
    
    
}

extension AddPropertyViewController : UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentIndex = textField.tag
        currentTextField = textField
        
        if(textField.tag == 2 || textField.tag == 3 || textField.tag == 4){
            view.endEditing(true)
            
            showDropDownPopup()
            return false
        }
        
        return true
        
    }
    func showDropDownPopup(){
        dropDownView.frame = view.frame
        view.addSubview(dropDownView)
        dropDownPickerView.dataSource = self
        dropDownPickerView.delegate = self
        dropDownPickerView.reloadAllComponents()
        
    }
}

extension AddPropertyViewController : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        
        model.dataArray[textView.tag] = textView.text
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
//        if(textView.text == placeHolderText[textView.tag]){
//            textView.text = ""
//        }
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {

         model.dataArray[textView.tag] = textView.text
        
    }
    
}
extension AddPropertyViewController{
    func requestEditPropertyAPI(){
        
        var images = [UIImage]()
        var urls = [String]()
        
        for image in imageArray {
            if let validimage = image as? UIImage{
                images.append(validimage)
            }else{
                urls.append(image as! String)
            }
        }
        var allUrlString = ""
        if(urls.count > 0){
            allUrlString = urls.joined(separator: ",")
        }
        let price = model.price
        let currentPrice = price.replacingOccurrences(of: ",", with: "")
        
        
    let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        let parmDict = ["user_id" : userId ,"method_name" : ApiUrl.METHOD_EDIT_PROPERTY , "price" : currentPrice , "area_sqft" : model.area_sqft , "bedrooms" : model.bedrooms , "bathrooms" : model.bathrooms , "car_parking_garage" : model.car_parking_garage , "address" : model.address , "description" : model.description , "agent_name" : model.agent_name , "agent_contact" : model.agent_contact , "oldimage" : allUrlString ,"property_id" : model.propertyId] as [String : Any]
        //if(!canAdd){
//            view.makeToast("Under Development")
//            return
//        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.uploadMultipleImagesWithData(parmDict, images, {(data) ->() in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.responseOfEditProperty(data)


        }, {(error)-> () in
            print("failure \(error)")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(NETWORK_ERROR)


        },{(progress)-> () in
            print("progress \(progress)")


        })
        
    }
    func responseOfEditProperty(_ userData : Any){
        
        let dictionary = userData as! NSDictionary
        
        let status = dictionary["status"] as? Int
        let msg = dictionary["msg"] as? String
        if(status == 1){
            SharedAppDelegate.window?.makeToast(msg!)
          //  self.view.makeToast(msg!)
            switchController()
        }else{
            self.view.makeToast(msg!)

        }
    }
}

extension AddPropertyViewController{
    func requestAddPropertyAPI(){
        //        method_name":"add_user_Property",
        //        "user_id": "11",
        //        "price": "50",
        //        "area_sqft": "250",
        //        "bedrooms": "2",
        //        "bathrooms": "1",
        //        "car_parking_garage": "0",
        //        "address": "noida",
        //        "description": "near by bus stand",
        //        "agent_name": "upendra",
        //        "agent_contact": "8598787897",
        //        "image":""
        //
        //    }
        
        var images = [UIImage]()
        //var urls = [String]()

        for image in imageArray {
            if let validimage = image as? UIImage{
                images.append(validimage)
            }
//            else{
//                urls.append(image as! String)
//            }
        }
//        var allUrlString = ""
//        if(urls.count > 0){
//            allUrlString = urls.joined(separator: ",")
//        }
        let userId = UserDefaults.standard.object(forKey: USER_ID) as! String
        let parmDict = ["user_id" : userId ,"method_name" : ApiUrl.METHOD_ADD_PROPERTY , "price" : model.price , "area_sqft" : model.area_sqft , "bedrooms" : model.bedrooms , "bathrooms" : model.bathrooms , "car_parking_garage" : model.car_parking_garage , "address" : model.address , "description" : model.description , "agent_name" : model.agent_name , "agent_contact" : model.agent_contact] as [String : Any]

        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.sharedInstance.uploadMultipleImagesWithData(parmDict, images, {(data) ->() in
            MBProgressHUD.hide(for: self.view, animated: true)

            self.responseOfAddProperty(data)

        }, {(error)-> () in
            print("failure \(error)")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(NETWORK_ERROR)


        },{(progress)-> () in
            print("progress \(progress)")


        })
        
    }
    func responseOfAddProperty(_ userData : Any){
        
        let dictionary = userData as! NSDictionary
        
        let status = dictionary["status"] as? Int
        let msg = dictionary["msg"] as? String
        if(status == 1){
            switchController()
        }else{
            
        }
        self.view.makeToast(msg!)
    }
    
    func switchController(){
        let navController : UINavigationController  = self.storyboard?.instantiateViewController(withIdentifier: "SlidingNavigationController") as! UINavigationController
        let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBar") as! UITabBarController
        navController.viewControllers = [tabBarController]
        tabBarController.selectedIndex = 3
        self.frostedViewController.contentViewController = navController
        
    }
}
extension AddPropertyViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count + 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPropertyCollectionCell", for: indexPath) as! AddPropertyCollectionCell
        cell.propertyImageView.isUserInteractionEnabled = false
        cell.propertyImageView.setRadius(5)
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnTapped(_:)), for: .touchUpInside)
        if(imageArray.count == indexPath.row){
            cell.propertyImageView.image = UIImage.init(named: "add_photo")
            cell.deleteBtn.isHidden = true
        }else{
            cell.deleteBtn.isHidden = false
            
            if let validUrl = imageArray[indexPath.row] as? String{
                cell.propertyImageView.sd_setImage(with: URL(string : validUrl), placeholderImage: UIImage.init(named: "add_home_placeholder"))
            }else{
                if let validImage = imageArray[indexPath.row] as? UIImage{
                cell.propertyImageView.image = validImage
                }else{
                  cell.propertyImageView.image = UIImage.init(named: "add_home_placeholder")
                }
            }
            
            
        }
        return cell
        
    }
    
    func deleteBtnTapped(_ btn : UIButton){
        imageArray.remove(at: btn.tag)
        imageCollectioView.reloadData()
       // imageCollectioView.scrollToItem(at: indexPath, at: .right, animated: true)
    }
    
    
    
}
extension AddPropertyViewController : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(imageArray.count  == indexPath.row){
            cameraBtnPressed()
        }
        
        
    }
    func cameraBtnPressed() {
        let actionSheetController = UIAlertController(title: NSLocalizedString("Capture Photo", comment: "nil"), message: "", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: NSLocalizedString("Cancel", comment: "nil"), style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: NSLocalizedString("Camera", comment: "nil"), style: .default) { action -> Void in
            print("Camera")
            self.capturePhotoFromCamera()
        }
        actionSheetController.addAction(saveActionButton)
        
        let deleteActionButton = UIAlertAction(title: NSLocalizedString("Gallery", comment: "nil"), style: .default) { action -> Void in
            print("Gallery")
            self.capturePhotoFromLibrary()
        }
        actionSheetController.addAction(deleteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func capturePhotoFromCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            present(imagePicker, animated: true, completion: nil)
        }else{
            self.view.makeToast(CAMERA_ERROR)
        }
    }
    func capturePhotoFromLibrary(){
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}
extension AddPropertyViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = (collectionView.frame.size.height)
        print("collectionviewheightAndWidth  \(collectionView.frame.size.width)   \(cellSize)")
        return CGSize(width : cellSize , height : cellSize)
    }
}

extension AddPropertyViewController : UINavigationControllerDelegate{
    
}

extension AddPropertyViewController : UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //imageArray.removeAll()
        imagePicker.dismiss(animated: true, completion: nil)
//        imageArray.append((info[UIImagePickerControllerOriginalImage] as? UIImage)!)
        let capturedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        guard let image = capturedImage else{return}
        printImageSize(image , "before")
        let size = CGSize(width: 400, height: 400)
        guard let finalImage = image.resize(size, 0.5) else{return}
        printImageSize(finalImage , "after")
        imageArray.append(finalImage)
        imageCollectioView.reloadData()
        let indexPath = IndexPath(row: imageArray.count, section: 0)
        imageCollectioView.scrollToItem(at: indexPath, at: .right, animated: true)
        
    }
    func printImageSize(_ image : UIImage , _ status : String){
    let data = UIImagePNGRepresentation(image)
        if let data = data{
        print("***** compressed Size \(status) \(data.description) **** ")

        }
        
    }
}


extension AddPropertyViewController : UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dropDownArray.count
    }
    
    
    
}

extension AddPropertyViewController : UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let value = dropDownArray[row]
        return value
    }
}


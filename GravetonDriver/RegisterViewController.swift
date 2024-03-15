//
//  RegisterViewController.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 5/9/23.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {
    
    private lazy var showOrHideButton: UIButton = {
        let button = UIButton()
        button.setTitle("show", for: .normal)
        button.addTarget(self, action: #selector(didTapHideOrShowButton), for: .touchUpInside)
        return button
    }()
        
    private lazy var didTapPolicyAndTerms = UITapGestureRecognizer(target: self, action: #selector(didTapPolicyAndTermsButton))
    
    var policyString = "By Clicking Register, I agree to the Indepndent Contractor Agreement and have read the Graveton Privacy Policy"
    
    var SignUpplaceHolder = ["First Name","Last Name","Email","Social Security #","Phone","must be 18 or over","Create password"]
    
    var DriverplaceHolder = ["First Name","Last Name","Email","Social Security #","Phone","must be 18 or over","Create password","car model","policy number(insurance n.)"]
    
    var iconMenu = ["Register"]
    var number: String = ""

    enum Sections: Int {
        case sectionOne
        case sectionTwo
        case sectionThree
    }
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    private let switchButton = UISwitch()
    private var isDriving:Bool = false
    private var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchButton.addTarget(self, action: #selector(didTapSwitchButton(_:)), for: .valueChanged)
        
        navigationItem.title = "Are you going to be driving?"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: switchButton)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .done, target: self, action: #selector(didTapBackButton))
        
        collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: createCompositionalLayout())
                
        view.addSubview(collectionView)
        
        collectionView.register(ProfilePersonInfoCell.self, forCellWithReuseIdentifier: ProfilePersonInfoCell.reuseIdentifier)
        
        collectionView.register(TextFieldCell.self, forCellWithReuseIdentifier: TextFieldCell.reuseIdentifier)
        
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.reuseIdentifier)
        
        collectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HeaderReusableView.reuseIdentifier)
        
        collectionView.delegate = self
        
        createDataSource()
        reloadData()
    }
    
    func createDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){collectionView,indexPath, item in
            
            switch indexPath.section {
                
            case Sections.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfilePersonInfoCell.reuseIdentifier, for: indexPath) as? ProfilePersonInfoCell else {fatalError()}
                cell.imageView.image = self.image
                cell.cameraButton.addTarget(self, action: #selector(self.didTappedCameraButton), for: .touchUpInside)
                cell.subHeaderLabel.text = "require* if driving,take picture of driver' license"
                return cell
                
            case Sections.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextFieldCell.reuseIdentifier, for: indexPath) as? TextFieldCell else {fatalError(TextFieldCell.reuseIdentifier)}
                
                cell.placeHolderr = item as? String
                cell.textField.delegate = self
                
                if indexPath.item == 3 || indexPath.item == 4 || indexPath.item == 5 {
                    cell.textField.keyboardType = .numberPad
                }else if indexPath.item == 6 {
                    
                    cell.textField.isSecureTextEntry = true
                    cell.textField.rightViewMode = .always
                    cell.textField.rightView = self.showOrHideButton
                }
                
                return cell
                
            case Sections.sectionThree.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.reuseIdentifier, for: indexPath) as? ButtonCell else {fatalError( ButtonCell.reuseIdentifier)}
                
                cell.name.text = item as? String
                
                cell.backgroundColor = .systemBackground
                
                return cell
                
            default: return UICollectionViewCell()
            }
        }
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderReusableView.reuseIdentifier, for: indexPath) as? HeaderReusableView else {fatalError()}
            
            sectionHeader.headerLabel.isUserInteractionEnabled = true
            sectionHeader.headerLabel.addGestureRecognizer(self.didTapPolicyAndTerms)
            
            sectionHeader.headerLabel.setDifferentColor(string: self.policyString, location: 37, length: 32)
            
            return sectionHeader
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        snapShot.appendSections([.sectionOne,.sectionTwo,.sectionThree])
        
        let value = self.isDriving ? [image] : []
        
        let newValue = self.isDriving ? DriverplaceHolder : SignUpplaceHolder
        
        snapShot.appendItems(value,toSection: .sectionOne)
        snapShot.appendItems(newValue,toSection: .sectionTwo)
        snapShot.appendItems(iconMenu,toSection: .sectionThree)
        
        dataSource?.apply(snapShot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout{ sectionIndex, layoutEnvironment in
            
            guard let sectionType = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch sectionType {
                
            case .sectionOne: return self.createProfileSection()
            case .sectionTwo:return self.createTextFieldsSection()
            case .sectionThree:return self.createButtonssSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    
    func createProfileSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    func createTextFieldsSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let nestedHorizontalItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1))
        
        let nestedHorizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let nestedHorizontalItem = NSCollectionLayoutItem(layoutSize: nestedHorizontalItemSize)
        
        let nestedHorizontalGroup  = NSCollectionLayoutGroup.horizontal(layoutSize: nestedHorizontalGroupSize, repeatingSubitem: nestedHorizontalItem, count: 2)
        nestedHorizontalGroup.interItemSpacing = .fixed(30)
        
        let nestedVerticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let nestedVerticalGroup =  NSCollectionLayoutGroup.vertical(layoutSize: nestedVerticalGroupSize, subitems: [nestedHorizontalGroup,layoutItem,layoutItem,nestedHorizontalGroup,layoutItem,layoutItem,layoutItem])
        
        nestedVerticalGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let section = NSCollectionLayoutSection(group: nestedVerticalGroup)
        
        return section
    }
    
    func createButtonssSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top:0, leading:0, bottom:30, trailing: 0)
        
        let layoutSectionFooter = createSectionFooter()
        layoutSection.boundarySupplementaryItems = [layoutSectionFooter]
        
        return layoutSection
    }
    
    func createSectionFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.88), heightDimension: .estimated(50))
        
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        
        return layoutSectionHeader
    }
    
    @objc func didTapPolicyAndTermsButton(){
        
        let taskHistoryVC = TaskHistoryViewController()
        taskHistoryVC.navigationItem.rightBarButtonItem?.isHidden = true
        taskHistoryVC.title = "Privacy Policy"
        
        let storageRef = Storage.storage().reference(withPath: "policy")
        
        storageRef.getData(maxSize:17065) { data, error in
            
            if let data = data {
                
                let decodedData =  try? JSONDecoder().decode(Policy.self, from: data)

                taskHistoryVC.policyString = decodedData?.policy
            }
            
            taskHistoryVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "multiply.circle")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(self.didTapBackXButton))
            
            let settingVCNav = UINavigationController(rootViewController: taskHistoryVC)
            
            self.present(settingVCNav, animated: true)
        }
    }
    
    @objc func didTapBackXButton(){
        dismiss(animated: true)
    }
    
    @objc func didTapBackButton(){
        navigationController?.popViewController(animated: false)
    }
    
    @objc func didTapSwitchButton(_ sender:UISwitch){
        
        self.isDriving = sender.isOn
        self.reloadData()
    }
    
    @objc func didTapSignUpButton(){
        
        var personInfo = PersonInfo()
        
        for item in 0..<collectionView.numberOfItems(inSection: 1){
            
            let indexPath = IndexPath(item: item, section: 1)
            
            let cell = collectionView.cellForItem(at: indexPath) as! TextFieldCell
            
            switch item {
                
            case 0:personInfo.firstName = cell.textField.text!
            case 1:personInfo.lastName = cell.textField.text!
            case 2:personInfo.email = cell.textField.text!.trimmingCharacters(in: .whitespaces)
            case 3:personInfo.ssn = cell.textField.text!
            case 4:personInfo.phone = number
            case 5:personInfo.age = cell.textField.text!
            case 6:personInfo.password = cell.textField.text!
            case 7:personInfo.fullName = cell.textField.text!
            case 8:personInfo.midName = cell.textField.text!

            default: cell.backgroundColor = .systemRed
            }
        }
        
        if isDriving {
            
            if image == nil{navigationItem.title = "missing field"
                return
            }
            
            if personInfo.midName?.count == 0 {return}
        }
        
        if let firstName = personInfo.firstName,firstName.count > 0,let lastName = personInfo.lastName,lastName.count > 0,let email = personInfo.email,email.count > 0,let ssn = personInfo.ssn,ssn.count > 0,let phone = personInfo.phone,phone.count > 0,let age = personInfo.age,age.count > 0,let password = personInfo.password,password.count > 0{
            
            handleRegister(personInfo)
        }
    }
    
    func handleRegister(_ personInfo: PersonInfo){

        Auth.auth().createUser(withEmail: personInfo.email!, password: personInfo.password!) {
            user, error in
            
            if let error = error{self.navigationItem.title = error.localizedDescription
                return
            }
            
            let storageRef = Storage.storage().reference(withPath: "DriverPic/\(personInfo.lastName!)")
            
            if let uploadData = self.image?.pngData(){
             
                storageRef.putData(uploadData, completion: { (metadata, e) in
                    self.processs(personInfo, uid: (user?.user.uid)!)
                })
            }else{
                self.processs(personInfo, uid: (user?.user.uid)!)
            }
        }
    }
    
    func processs(_ personInfo:PersonInfo,uid:String){
        
        let name = "\(personInfo.firstName!) \(personInfo.lastName!)"
        let email = personInfo.email!
        
        UserDefaults.standard.set(email, forKey: "email")
        
        let values:[String:Any] = ["name": name, "email": email,"phone":personInfo.phone!,"age":personInfo.age!,"ssn":personInfo.ssn!,"policyNum":personInfo.midName ?? ""]
        
        self.createAlernController("Login Using",  "username: \(personInfo.email ?? "")\nPassword:\(personInfo.password ?? "")", "Ok",uid)
                        
        self.registerUserIntoDatabase(uid: uid, values: values )
    }
    
    func createAlernController(_ title:String,_ message:String,_ bttonTitle:String,_ uid:String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
        let yesAction = UIAlertAction(title: bttonTitle, style: .destructive) { (action:UIAlertAction!) in
        
            let bankInfoVC = BankInfoViewController()
            bankInfoVC.uid = uid
            self.navigationController?.pushViewController(bankInfoVC, animated: false)
        }
        
        alertController.addAction(yesAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func registerUserIntoDatabase (uid: String, values: [String: Any]) {
        
        Database.database().reference().child("Drivers").child(uid).setValue(values)
    }
    
    @objc func didTappedCameraButton(){
        
        CameraManager.shared.showActionSheet(vc: self)
        CameraManager.shared.imagePickedBlock = { image in
            self.image = image
            self.reloadData()
        }
    }

    func userLogin(){
        
        let taskVC = UINavigationController(rootViewController: TaskViewController())
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(taskVC)
    }
    
    @objc func didTapOutsideOfTextField(){
        view.endEditing(true)
    }
    
    @objc func didTapHideOrShowButton(_ sender: UIButton){
        
        sender.isSelected = !sender.isSelected
        
        let indexPath = IndexPath(item: 6, section: 1)
        
        let cell = collectionView.cellForItem(at: indexPath) as? TextFieldCell
    
        cell?.textField.isSecureTextEntry = sender.isSelected

        if sender.isSelected {
            
            showOrHideButton.setTitle("show", for: .normal)
        }else{
                    
            showOrHideButton.setTitle("hide", for: .normal)
        }
        reloadData()
    }
}

extension RegisterViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.item == 0 {
            
            CameraManager.shared.showActionSheet(vc: self)
            CameraManager.shared.imagePickedBlock = { image in
                
                self.image = image
                self.reloadData()
            }
        }
        
        if indexPath.section == 2 && indexPath.item == 0 {didTapSignUpButton()}
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let SecondindexPath = IndexPath(item: 4, section:1)
        
        let cell = collectionView.cellForItem(at: SecondindexPath) as! TextFieldCell
        
        if SecondindexPath.item == 4 && textField == cell.textField{
            
            let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            
            return checkEnglishPhoneNumberFormat(string: string, str: str)
        }
        return true
    }
    
    func checkEnglishPhoneNumberFormat(string: String?, str: String?) -> Bool{
        
        let indexPath = IndexPath(item: 4, section: 1)
        
        let visibleCell = self.collectionView.cellForItem(at: indexPath) as? TextFieldCell
        
        guard let visibleCell = visibleCell else {fatalError()}
        
        if string == ""{
            
            return true
            
        }else if str!.count < 3{
            
            if str!.count == 1{
                
                visibleCell.textField.text = "("
            }
            
        }else if str!.count == 5{
            
            visibleCell.textField.text = visibleCell.textField.text! + ") "
            
        }else if str!.count == 10{
            
            visibleCell.textField.text = visibleCell.textField.text! + "-"
            
        }else if str!.count > 14{
            
            return false
        }
        
        number += string ?? ""
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        for item in 0..<collectionView.numberOfItems(inSection: 1){
            
            let indexPath = IndexPath(item:item , section: 1)
            
            let cell = collectionView.cellForItem(at: indexPath) as! TextFieldCell
            
            if textField == cell.textField {
                textField.resignFirstResponder()
            }
        }
        return true
    }
}

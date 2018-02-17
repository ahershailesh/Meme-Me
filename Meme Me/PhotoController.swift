//
//  PhotoEditorViewController.swift
//  Meme
//
//  Created by Shailesh Aher on 11/29/17.
//  Copyright © 2017 Shailesh Aher. All rights reserved.
//

import UIKit

class PhotoController: UIViewController, UITextFieldDelegate {
    
    enum PhotoMode {
        case view, edit
    }

    //MARK:- Public Vars
    var mode : PhotoMode = .edit
    var image : UIImage?
    
    //MARK:- Private Vars
    private var pickerDataHandler = PickerViewDataHandler()
    private let pickerController = PickerViewController(nibName: "PickerViewController", bundle: nil)
    
    private var textFieldsArray = [UITextField]()
    private let defaultTextFieldSize = CGSize(width: UIScreen.main.bounds.width, height: 36)
    private var gesture :  UIPanGestureRecognizer?
    
    private var textField : UITextField?
    private var frame : CGRect?
    
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK:- Setter Getter
    private func saveFrame(frame: CGRect) {
        self.frame = frame
    }
    
    private func getFrame() -> CGRect? {
        let tempFrame = self.frame
        self.frame = nil
        return tempFrame
    }
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        gesture = UIPanGestureRecognizer(target: self, action: #selector(userDragged(gesture:)))
        imageView?.image = image
        setupMode(changedMode: mode)
        pickerController.callBack = {
            self.setTextFieldProperties()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = false
    }
    
    //MARK:- View Related Functions
    private func setupMode(changedMode: PhotoMode) {
        changedMode == .edit ? prepareToolBar() : hideViews()
    }
    
    func setTextFieldProperties() {
        textField?.defaultTextAttributes = getAttributes()
        textField?.backgroundColor = pickerController.backgroundColor
    }
    
    private func prepareToolBar() {
        let addTextFieldButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonAction))
        var operationArray : [UIBarButtonItem]
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        if !textFieldsArray.isEmpty {
            let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: nil)
            operationArray = [addTextFieldButton, spacer, shareButton]
        } else {
            operationArray = [spacer, addTextFieldButton, spacer]
        }
        navigationController?.setToolbarHidden(false, animated: true)
        setToolbarItems(operationArray, animated: true)
    }
    
    
    @objc private func prepareEditToolBar() {

        let removeTextFieldButton = UIBarButtonItem(image: UIImage(named: "ic_close_white"), style: .plain, target: self, action: #selector(removeTextField))

        let saveButtonButton = UIBarButtonItem(image: UIImage(named: "ic_save_white"), style: .plain, target: self, action: #selector(saveButton))
        
        let editButton = UIBarButtonItem(image: UIImage(named: "ic_edit_white"), style: .plain, target: self, action: #selector(editButtonTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let operationArray = [removeTextFieldButton, spacer, editButton, spacer, saveButtonButton]
        setToolbarItems(operationArray, animated: true)
    }
    
    private func preparePickerView() {
        if let textField = textField {
            moveTextFieldUp(textField: textField)
            textField.resignFirstResponder()
        }
        self.addChildViewController(pickerController)
        self.view.addSubview(pickerController.view)
        pickerController.didMove(toParentViewController: self)
        
        // 3- Adjust bottomSheet frame and initial position.
        let height : CGFloat = 260
        let width  = view.frame.width
        pickerController.view.frame = CGRect(x: 0,y: self.view.frame.maxY - height,width: width,height: height)
    }
    
    private func removePickerView() {
        pickerController.view.removeFromSuperview()
    }
    
    //MARK:- Private Operation Methods
    @objc private func editButtonTapped() {
        preparePickerView()
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        setToolbarItems([spacer, done, spacer], animated: true)
    }

    @objc private func doneButtonTapped() {
        removePickerView()
        restoreTextField(textField: textField!)
        prepareEditToolBar()
    }
    
    @objc private func removeTextField() {
        textField?.removeFromSuperview()
        prepareToolBar()
    }
    
    @objc private func saveButton() {
        textFieldsArray.append(textField!)
        textField?.isUserInteractionEnabled = false
        textField?.removeGestureRecognizer(gesture!)
        prepareToolBar()
    }
    
    @objc private func share() {
        let activityController = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        present(activityController, animated: true) { [weak self] in
            self?.share()
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func addButtonAction() {
        prepareEditToolBar()
        addTextField()
    }
    
    @objc func saveImage() -> UIImage {
        var memedImage : UIImage
        if !textFieldsArray.isEmpty {
            hideViews()
            UIGraphicsBeginImageContext(self.view.frame.size)
            view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
            memedImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            UIImageWriteToSavedPhotosAlbum(memedImage, self, #selector(imageSaved), nil)
            hideViews(isHidden: false)
        } else {
            memedImage = image!
        }
        return memedImage
    }
    
    private func hideViews(isHidden : Bool = true){
        navigationController?.navigationBar.isHidden = isHidden
        navigationController?.isToolbarHidden = isHidden
    }
    
    private func moveTextFieldUp(textField: UITextField) {
        let info = Notification(name: .UIKeyboardDidShow).userInfo
        let keyboardFrame = ((info?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue)
        saveFrame(frame: textField.frame)
        
        let keyboardHeight = keyboardFrame?.height ?? 300
        let height = UIScreen.main.bounds.height - keyboardHeight
        UIView.animate(withDuration: 0.3) {
            textField.frame = CGRect(origin: CGPoint(x: textField.frame.origin.x, y: height), size: textField.frame.size)
        }
    }
    
    private func restoreTextField(textField: UITextField) {
        if let frame = getFrame() {
            UIView.animate(withDuration: 0.3) {
                textField.frame = frame
            }
        }
    }
    
    private func addTextField() {
        textField = UITextField(frame: CGRect.zero)
        textField?.frame.size = defaultTextFieldSize
        textField?.center = imageView.center
        textField?.textAlignment = .center
        textField?.backgroundColor = UIColor.brown
        textField?.returnKeyType = .done
        textField?.delegate = self
        textField?.isUserInteractionEnabled = true
        textField?.autocapitalizationType = .allCharacters
        textField?.backgroundColor = UIColor.clear
        textField?.textColor = UIColor.white
        textField?.minimumFontSize = 14
        textField?.attributedPlaceholder = NSAttributedString(string: "Add Text", attributes: [
            NSAttributedStringKey.font          : 16,
            NSAttributedStringKey.strokeColor   : UIColor.black,
            NSAttributedStringKey.strokeWidth   : -1.0,
            NSAttributedStringKey.foregroundColor : UIColor.gray])
        textField?.defaultTextAttributes = getAttributes()
        textField?.addGestureRecognizer(gesture!)
        view.addSubview(textField!)
    }
    
    private func getAttributes() -> [String: Any] {
        let attributes = [NSAttributedStringKey.font.rawValue : UIFont(name: pickerController.fontName, size: CGFloat(pickerController.fontSize))!,
                          NSAttributedStringKey.strokeColor.rawValue : UIColor.black,
                          NSAttributedStringKey.strokeWidth.rawValue : -1.0,
                          NSAttributedStringKey.foregroundColor.rawValue : pickerController.foregroundColor
                          ] as [String : Any]
        return attributes
    }
    
    @objc func userDragged(gesture: UIPanGestureRecognizer){
        let loc = gesture.location(in: self.view)
        let center = textField?.center ?? CGPoint.zero
        textField?.center = CGPoint(x: center.x, y: loc.y)
    }
    
    
    @objc func imageSaved(image : UIImage, didFinishSavingWithError error: NSError,contextInfo: Any) {
        mode = .view
        self.image = image
    }
    
    //MARK:- UITextFieldDelegate
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        moveTextFieldUp(textField: textField)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        restoreTextField(textField: textField)
    }
}

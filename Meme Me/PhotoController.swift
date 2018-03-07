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
    
    //MARK:- Private Vars
    private var pickerDataHandler = PickerViewDataHandler()
    private let pickerController = PickerViewController(nibName: "PickerViewController", bundle: nil)
    private var textFieldsArray = [UITextField]()
    private var gesture :  UIPanGestureRecognizer?
    private var textField : UITextField?
    private var frame : CGRect?
    private var defaultTextFieldSize : CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 36)
    }
    private var centerPoint : CGPoint {
        return CGPoint(x: 0, y: UIScreen.main.bounds.height/2)
    }
    
    //MARK:- Public Vars
    var mode : PhotoMode = .edit
    
    //user preferred image to be shown
    var image : UIImage?
    
    //outlet property to show image
    @IBOutlet weak var imageView: UIImageView!
    
    var callBack : Constants.CompletionBlock?
    
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
        imageView.contentMode = .scaleAspectFit
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = false
    }
    
    
    /// This method is overrided to change textfield width and location on rotation.
    ///
    /// - Parameter fromInterfaceOrientation: None.
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        super.didRotate(from: fromInterfaceOrientation)
        textField?.frame.origin = centerPoint
        textField?.frame.size = defaultTextFieldSize
    }
    
    //MARK:- Private Operation Methods
    
    //If textfield is saved, share button will start apearing, button will be : add, share.
    private func prepareToolBar() {
        let addTextFieldButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonAction))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        var operationArray : [UIBarButtonItem]
        if !textFieldsArray.isEmpty {
            let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
            operationArray = [addTextFieldButton, spacer, shareButton]
        } else {
            operationArray = [spacer, addTextFieldButton, spacer]
        }
        navigationController?.setToolbarHidden(false, animated: true)
        setToolbarItems(operationArray, animated: true)
    }
    
    @objc private func addButtonAction() {
        prepareEditToolBar()
        addTextField()
    }
    
    
    /// This function will share pic, using UIActivityViewController.
    @objc private func share() {
        let memedModel = saveMeme()
        let activityController = UIActivityViewController(activityItems: [memedModel.memedImage!], applicationActivities: nil)
        activityController.completionWithItemsHandler = { [weak self] (_,completed,_, _) in
            if completed {
                self?.navigationController?.popViewController(animated: true)
                self?.callBack?(true, memedModel, nil)
            } else {
                self?.showAlert(message: "Cannot able to save picture as it is not shared")
            }
        }
        present(activityController, animated: true, completion: nil)
    }
    
    private func saveMeme() -> MemeModel {
        let memedImage = saveImage()
        let originalImage = imageView.image
        var memeModel = MemeModel()
        memeModel.memedImage = memedImage
        memeModel.originalImage = originalImage
        memeModel.subTitles = textFieldsArray.flatMap { $0.text }
        return memeModel
    }
    
    /// This method will create buttons for edit operation, Button shown in order close, edit, save
    @objc private func prepareEditToolBar() {

        let removeTextFieldButton = UIBarButtonItem(image: UIImage(named: "ic_close_white"), style: .plain, target: self, action: #selector(removeTextField))

        let editButton = UIBarButtonItem(image: UIImage(named: "ic_edit_white"), style: .plain, target: self, action: #selector(editButtonTapped))
        
        let saveButtonButton = UIBarButtonItem(image: UIImage(named: "ic_save_white"), style: .plain, target: self, action: #selector(saveButtonTapped))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let operationArray = [removeTextFieldButton, spacer, editButton, spacer, saveButtonButton]
        setToolbarItems(operationArray, animated: true)
    }
    
    //This will remove added textfield.
    @objc private func removeTextField() {
        textField?.removeFromSuperview()
        prepareToolBar()
    }
    
    ///If edit button tapped, toolbar buttons will replaced with done button.
    @objc private func editButtonTapped() {
        preparePickerView()
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        setToolbarItems([spacer, done, spacer], animated: true)
    }

    //This function will remove access from UITextView.
    @objc private func saveButtonTapped() {
        textFieldsArray.append(textField!)
        textField?.isUserInteractionEnabled = false
        textField?.removeGestureRecognizer(gesture!)
        prepareToolBar()
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
    
    //This will close picker view
    @objc private func doneButtonTapped() {
        removePickerView()
        restoreTextField(textField: textField!)
        prepareEditToolBar()
    }
    
    //MARK:- Private methods
    private func saveImage() -> UIImage {
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
    
    @objc private func imageSaved(image : UIImage, didFinishSavingWithError error: NSError,contextInfo: Any) {
        mode = .view
        self.image = image
    }
    
    @objc private func userDragged(gesture: UIPanGestureRecognizer){
        let loc = gesture.location(in: self.view)
        let center = textField?.center ?? CGPoint.zero
        textField?.center = CGPoint(x: center.x, y: loc.y)
    }
    
    private func setupMode(changedMode: PhotoMode) {
        changedMode == .edit ? prepareToolBar() : hideViews()
    }
    
    private func setTextFieldProperties() {
        textField?.defaultTextAttributes = getAttributes()
        textField?.backgroundColor = pickerController.backgroundColor
    }
    
    private func removePickerView() {
        pickerController.view.removeFromSuperview()
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
        textField?.textAlignment = .center
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
    
    //MARK:- UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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

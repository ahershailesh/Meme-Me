//
//  ViewController.swift
//  Meme Me
//
//  Created by Shailesh Aher on 2/11/18.
//  Copyright © 2018 Shailesh Aher. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var photoAlbumImage: UIImageView!
    @IBOutlet weak var photoImageBackView1: UIView!
    @IBOutlet weak var photoImageBackView2: UIView!
    @IBOutlet weak var photoImageBackView3: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoImageBackView1.layer.cornerRadius = photoImageBackView1.frame.width / 2
        photoImageBackView2.layer.cornerRadius = photoImageBackView2.frame.width / 2
        photoImageBackView3.layer.cornerRadius = photoImageBackView3.frame.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        navigationController?.isToolbarHidden = true
    }
    
    @IBAction func openPhoto(_ sender: Any) {
       presentImagePicker(withSourceType: .photoLibrary)
    }
    
    @IBAction func openCamera(_ sender: Any) {
        presentImagePicker(withSourceType: .camera)
    }
    
    private func presentImagePicker(withSourceType sourceType: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate = self
            present(picker, animated: false, completion: nil)
        } else {
            let sourceTypeString = sourceType == .camera ? "camera" : "photo library"
            showAlert(message: "This device does not support \(sourceTypeString)")
        }
    }
    
    @IBAction func viewSavedMemes(_ sender: Any) {
        
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage,
            let editorViewController = storyboard?.instantiateViewController(withIdentifier: "PhotoController") as? PhotoController {
            editorViewController.image = image
            picker.dismiss(animated: true, completion: nil)
            navigationController?.pushViewController(editorViewController, animated: true)
        }
    }
}

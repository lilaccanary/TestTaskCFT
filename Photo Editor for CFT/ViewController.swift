//
//  ViewController.swift
//  Photo Editor for CFT
//
//  Created by Алина Квашнина on 05.07.2021.
//

import UIKit

class ViewController: UIViewController,
                      UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate
{
    var photos: [Photo] = []
    
    func addPhoto(newPhoto: Photo) {
        photos.appendAtBeginning(newItem: newPhoto)
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var URLTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedImage = Photo()
    var notInvertImage = UIImage()
    
    @IBAction func selectButtonTap(_ sender: UIButton) {
        sender.setTitle("", for: .normal)
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source",
                                            preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default,
                                                handler: { (action:UIAlertAction) in
                                                    imagePickerController.sourceType = .camera
                                                    self.present(imagePickerController, animated: true,
                                                                 completion: nil)
                                                }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            actionSheet.addAction(UIAlertAction(title: "Photo library", style: .default,
                                                handler: { (action:UIAlertAction) in
                                                    imagePickerController.sourceType = .photoLibrary
                                                    self.present(imagePickerController, animated: true,
                                                                 completion: nil)
                                                }))
        }
        
        
        actionSheet.addAction(UIAlertAction(title: "Use URL", style: .default,
                                            handler: { [self] (action:UIAlertAction) in
                                                self.URLTextField.isHidden = false
                                                self.imageView.image = nil
                                                self.activityIndicator.isHidden = false
                                                self.activityIndicator.startAnimating()
                                            }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel,
                                            handler: nil ))
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        selectedImage.image = image
        notInvertImage = selectedImage.image
        imageView.image = image
        buttons[0].isEnabled = true
        buttons[1].isEnabled = true
        buttons[2].isEnabled = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func touchButton(_ sender: UIButton) {
        addPhoto(newPhoto: selectedImage)
        tableView.reloadData()
        
    }
    
    @IBAction func rotateButtonTap(_ sender: UIButton) {
        selectedImage.image = selectedImage.image.rotate(radians: .pi/2) ?? selectedImage.image
        notInvertImage = notInvertImage.rotate(radians: .pi/2) ?? notInvertImage
        imageView.image = selectedImage.image
        if selectedImage.isRotated {
            selectedImage.isRotated = false
        } else { selectedImage.isRotated = true }
    }
    
    @IBAction func invertColorsBattonTap(_ sender: UIButton) {
        if selectedImage.isInverted {
            selectedImage.image = notInvertImage
            imageView.image = selectedImage.image
            selectedImage.isInverted = false
        } else {
            selectedImage.image = selectedImage.image.invert()
            imageView.image = selectedImage.image
            selectedImage.isInverted = true
        }
    }
    
    @IBAction func mirrorImageButtonTap(_ sender: UIButton) {
        selectedImage.image = selectedImage.image.mirror() ?? selectedImage.image
        notInvertImage = notInvertImage.mirror() ?? notInvertImage
        imageView.image = selectedImage.image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons[0].isEnabled = false
        buttons[1].isEnabled = false
        buttons[2].isEnabled = false
        tableView.register(ImageViewCell.self, forCellReuseIdentifier: "CellOfPhoto")
        URLTextField.isHidden = true
        activityIndicator.isHidden = true
        URLTextField.addTarget(self, action: #selector(enterPressed), for: .editingDidEndOnExit)
    }
    
    @objc func enterPressed(){
        self.activityIndicator.startAnimating()
        let imageURL: URL
        if URLTextField.text != "" {
            imageURL = URL(string: URLTextField.text!)! } else {
                imageURL = URL(string: "https://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg")!
            }
        let queue = DispatchQueue.global(qos: .utility)
        queue.sync{
            
            if let data = try? Data(contentsOf: imageURL){
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                    self.buttons[0].isEnabled = true
                    self.buttons[1].isEnabled = true
                    self.buttons[2].isEnabled = true
                    self.selectedImage.image = UIImage(data: data)!
                    self.notInvertImage = self.selectedImage.image
                    print("Show image data")
                }
                print("Did download  image data")
            }
        }
        self.activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        URLTextField.resignFirstResponder()
        URLTextField.isHidden = true
    }
}

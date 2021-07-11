//
//  UIViewController+tableView.swift
//  Photo Editor for CFT
//
//  Created by Алина Квашнина on 06.07.2021.
//

import Foundation
import UIKit

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: TableView Protocols
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellOfPhoto") as! ImageViewCell
        cell.mainImageView.image = photos[indexPath.row].image
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentImage = photos[indexPath.row]
        if currentImage.isRotated {
            let imageCrop = currentImage.image.getCropRatioNot()
            return tableView.frame.height * imageCrop
        } else {
            let imageCrop = currentImage.image.getCropRatio()
            return tableView.frame.height * imageCrop
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let save = UIContextualAction(style: .normal,
                                      title: "Save") { [weak self] (action, view, completionHandler) in
            self?.handleSave()
            completionHandler(true)
        }
        let edit = UIContextualAction(style: .normal,
                                      title: "Edit") { [weak self] (action, view, completionHandler) in
            self?.handleMoveToEdit(cellForRowAt: indexPath)
            completionHandler(true)
        }
        let delete = UIContextualAction(style: .destructive,
                                        title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.handleDelete(cellForRowAt: indexPath)
            completionHandler(true)
        }
        save.backgroundColor = .systemGreen
        edit.backgroundColor = .systemGray
        let swipe = UISwipeActionsConfiguration(actions: [save, edit, delete])
        return swipe
    }
    
    // MARK: Saving Image to photo library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    // MARK: Swipe Functions
    private func handleSave() {
        guard let image = imageView.image else { return }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    private func handleMoveToEdit(cellForRowAt indexPath: IndexPath) {
        selectedImage = photos[indexPath.row]
        imageView.image = selectedImage.image
    }
    
    private func handleDelete(cellForRowAt indexPath: IndexPath) {
        photos.remove(at: indexPath.row)
        tableView.reloadData()
    }
}

//
//  ImageReplace.swift
//  MemoryGame
//
//  Created by arkokat on 15/06/2018.
//  Copyright © 2018 afeka. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

class ImageReplace: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var curImageId = 0
    var imagesLayout: UICollectionViewLayout? = nil
    
    @IBOutlet weak var test: UICollectionView!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        UserDefaults.standard.set(UIImagePNGRepresentation(chosenImage), forKey: String(format: "card%d", curImageId + 1))
        UserDefaults.standard.synchronize()
        test.collectionViewLayout.invalidateLayout()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.mediaTypes = [kUTTypeImage as String]
        picker.allowsEditing = true
        
        curImageId = indexPath.row + indexPath.section
        present(picker, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "image", for: indexPath) as! Image
        
        cell.image.image = UIImage(data: UserDefaults.standard.data(forKey: String(format: "card%d", indexPath.row + indexPath.section + 1))!)
        
        return cell
    }
    
        
}

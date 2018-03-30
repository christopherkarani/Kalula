//
//  PhotoSelectorViewController.swift
//  Kalula
//
//  Created by Chris Karani on 3/17/18.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import UIKit
import Photos

class PhotoSelectorViewController: UICollectionViewController {
    
    let cellID = "CellID"
    let headerID = "HeaderID"
    
    var header: PhotoSelectorHeaderCell?
    var selectedImage : UIImage?
    
    fileprivate func handleCellRegistration() {
        collectionView?.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.register(PhotoSelectorHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleCellRegistration()
        setupNavigationBar()
        collectionView?.backgroundColor = .white
        fetchPhotos()
    }
    
    var images = [UIImage]()
    var assets = [PHAsset]()
    
    fileprivate func fetchAssetsOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 10
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
    }

    fileprivate func fetchPhotos() {
        DispatchQueue.global(qos: .background).async {
            let assets = PHAsset.fetchAssets(with: .image, options: self.fetchAssetsOptions())
            assets.enumerateObjects { (asset, count, stop) in
                let imageManager = PHImageManager.default()
                let options = PHImageRequestOptions()
                let targetSize = CGSize(width: 300, height: 300)
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                    if let image = image {
                        self.images.append(image)
                        self.assets.append(asset)
                        
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                    }
                    if count == self.images.count - 1 {
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    }
                })
            }
        }
    }
    
    

    override var prefersStatusBarHidden: Bool { return true  }
    
    func setupNavigationBar() {

        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancleAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNextAction))
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImage = images[indexPath.item]
        collectionView.reloadData()
        let firstIndexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: firstIndexPath, at: .top, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PhotoSelectorCell
        cell.imageView.image = images[indexPath.item]
        return cell
    }
    
    @objc func handleCancleAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNextAction() {
        let selectPhotoViewController = SelectPhotoViewController()
    
        selectPhotoViewController.image = header?.imageView.image
        navigationController?.pushViewController(selectPhotoViewController, animated: true)
        
    }
}

extension  PhotoSelectorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (view.frame.width - 3) / 4
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID, for: indexPath) as! PhotoSelectorHeaderCell
        self.header = header
        setupHeaderImage(withHeaderCell: header, andSelectedImage: selectedImage)

        return header
    }
    
    fileprivate func setupHeaderImage(withHeaderCell cell:PhotoSelectorHeaderCell, andSelectedImage image: UIImage?) {
        cell.imageView.image = image
        if let selectedImage = image {
            if let index = images.index(of: selectedImage) {
                let selectedAsset = assets[index]
                let targetSize = CGSize(width: 600, height: 600)
                
                let imageManager = PHImageManager.default()
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .aspectFit, options: nil, resultHandler: { (image, info) in
                    cell.imageView.image = image
                })
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = view.frame.width
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
}

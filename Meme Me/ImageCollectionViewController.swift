//
//  ImageCollectionViewController.swift
//  FindIt
//
//  Created by Shailesh Aher on 3/5/18.
//  Copyright © 2018 Shailesh Aher. All rights reserved.
//

import UIKit
import CoreData

class ImageCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let numberOfSections = 1
    private let LINE_SPACING : CGFloat = 4
    private let ITEM_SPACING : CGFloat = 4
    private let LEFT_PADDING : CGFloat = 8
    private let RIGHT_PADDING : CGFloat = 8
    private let CELL_HEIGHT : CGFloat = 100
    private let numberOfItemsInRow = 3
    
    private let reuseId = "ImageViewCollectionViewCell"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        collectionView.reloadData()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        super.didRotate(from: fromInterfaceOrientation)
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = getItemSize()
            layout.minimumInteritemSpacing = ITEM_SPACING
            layout.minimumLineSpacing = LINE_SPACING
        }
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: reuseId, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseId)
        collectionView.dataSource = self
        collectionView.delegate = self
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = getItemSize()
            layout.minimumInteritemSpacing = ITEM_SPACING
            layout.minimumLineSpacing = LINE_SPACING
        }
        title = "Sent Memes"
    }
    
    private func getItemSize() -> CGSize {
        let deviceWidth = UIScreen.main.bounds.width  - LEFT_PADDING - RIGHT_PADDING
        let itemWidth = (deviceWidth - ITEM_SPACING * CGFloat(numberOfItemsInRow - 1))/CGFloat(numberOfItemsInRow)
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    private func showPreview(model: MemeModel) {
        let controller = PreviewImageViewController()
        controller.model = model
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ImageCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MemeHandler.shared.memeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as? ImageViewCollectionViewCell
        cell?.model = MemeHandler.shared.memeList[indexPath.row]
        return cell ?? UICollectionViewCell()
    }
}

extension ImageCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = MemeHandler.shared.memeList[indexPath.row]
        let controller = PreviewImageViewController()
        controller.model = model
        navigationController?.pushViewController(controller, animated: true)
    }
}

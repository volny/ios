//
//  CollectionViewController.swift
//  mememe
//
//  Created by felix on 8/15/15.
//  Copyright (c) 2015 Volnyio. All rights reserved.
//

// the grid view of saved image macros aka COLLECTION VIEW

import UIKit

class CollectionViewController: UICollectionViewController, UICollectionViewDataSource {
    
    // Udacity: "In the Sent Memes Table and Collection View Controllers:"
    var memes: [Meme]!
    
    // CollectionViewFlowLayout let's you change the styling of CollectionView grid
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    override func viewDidLoad() {
        let space: CGFloat = 2.0
        // spacing between items
        flowLayout.minimumInteritemSpacing = space
        // spacing between rows
        flowLayout.minimumLineSpacing = space

        // wait for it ... RESPONSIVE IMAGE (!!!) hack:
        let imagesInRow: CGFloat!
        switch UIDevice.currentDevice().orientation {
        case .Portrait, .PortraitUpsideDown:
            imagesInRow = 3
        case .LandscapeLeft, .LandscapeRight:
            imagesInRow = 5
        default:
            println("Strange device orientation. Guessing 3 images per CollectionView row will look good")
            imagesInRow = 3
        }

        let totalSpacePerRow = (imagesInRow - 1) * space
        // using the frame width (or height) to style content!
        let imgDimension = (self.view.frame.size.width - totalSpacePerRow) / imagesInRow
        
        // it is unclear whether is streches the image into a rectangle or (correctly) chooses the biggest rectangle in the image
        flowLayout.itemSize = CGSizeMake(imgDimension, imgDimension)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println("Counted \(self.memes.count) items")
        return self.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // A custom cell defined at `CustomCollectionViewCell.swift`
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! CustomCollectionViewCell

        let meme = self.memes[indexPath.item]
        
        cell.ImageView.image = meme.memedImage
        //or
        //cell.backgroundView = UIImageView(image: meme.memedImage)

        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("CreatorVC") as! ViewController!
        controller.meme = self.memes[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

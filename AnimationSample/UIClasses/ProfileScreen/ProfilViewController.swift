//
//  ProfilViewController.swift
//  AnimationSample
//
//  Created by Avadesh Kumar on 17/03/16.
//  Copyright © 2016 ibibo Group. All rights reserved.
//

let navigationBarOffset: CGFloat = 64
let profileImageCellHeight: CGFloat = 380
let numberOfCells: Int = 7
let bgViewAlpha: CGFloat = 0.7

import UIKit

class ProfilViewController: UIViewController, UIScrollViewDelegate, ProfileImageCellDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bgSemiTransparentView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSemiTransparentViewAnimationInBackGround()
        configureNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bgSemiTransparentView.isHidden = false
    }
    
    //MARK: Private Methods
    func configureNavigationBar() {

        self.navigationController?.navigationBar.isHidden = true

        let image = UIImage(named: "ic_share_grey.png")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        imageView.image = image
        imageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProfilViewController.shareButtonPressed))
        imageView.addGestureRecognizer(tapGesture)
        
        let shareButton = UIBarButtonItem(customView: imageView)
        self.navigationItem.rightBarButtonItems = [shareButton]
    }
    
    func shareButtonPressed() {
    
        let alertController = UIAlertController(title: "Awesome", message: "You pressed share button", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Enjoy", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // This is the additional view to show shadow animation in background while this view controller presentation is in progres, it will be removed automatically after completion of animation.
    func addSemiTransparentViewAnimationInBackGround() {
        
        let superView = self.presentingViewController?.view
        
        if superView == nil {
            return
        }
        
        let marginToStartView: CGFloat = 30
        bgSemiTransparentView.alpha = bgViewAlpha
        
        let backgroundView =  UIView(frame: CGRect(x: (superView!.frame.origin.x + marginToStartView), y: superView!.frame.origin.y + marginToStartView, width: superView!.frame.size.width - marginToStartView * 2, height: superView!.frame.size.height - marginToStartView * 2))
        
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.0
        
        superView?.addSubview(backgroundView)
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            backgroundView.frame = superView!.frame
            backgroundView.alpha = bgViewAlpha
            }, completion: { (completed) -> Void in
                backgroundView.removeFromSuperview()
        })
            
    
    }
    
    //MARK: Collection View DataSource & Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return numberOfCells;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell
    {
        var cell: UICollectionViewCell;
        
        if (indexPath as NSIndexPath).row == 0 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileImageCell", for: indexPath) as! ProfileImageCell
            (cell as! ProfileImageCell).delegate = self
            (cell as! ProfileImageCell).configureCellWithDetails()
        }
        else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserDetailsCell", for: indexPath) as! UserDetailsCell
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        var height: CGFloat = profileImageCellHeight
        
        if (indexPath as NSIndexPath).row != 0 {
            height = 110
        }
        
        return CGSize(width: collectionView.frame.size.width, height: height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
                
        if (scrollView.contentOffset.y < -100) {// To dismiss view controller if user has swiped down
            self.dismiss(animated: true, completion: nil)
        }
        
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = self.collectionView.cellForItem(at: indexPath) as? ProfileImageCell
        
        if cell != nil {
            //We just replace the current view with navigationbar if content has gone behind navigationbar offset and vice versa in else condition
            if ((scrollView.contentOffset.y + navigationBarOffset) > profileImageCellHeight) {
                
                self.navigationController?.navigationBar.isHidden = false
                self.navigationItem.titleView = cell?.getNavigationBarHeaderView()
            }
            else {
                cell?.doConfigurationForContentOffsetY(scrollView.contentOffset.y)
                self.navigationController?.navigationBar.isHidden = true
            }
        }
    }
    
    //MARK: ProfileImageCell delegate methods
    func didPressedShareButtonOnCell(_ cell: ProfileImageCell) {
        self.shareButtonPressed()
    }
    
    func didTappedBackgroundOnCell(_ cell: ProfileImageCell) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didTappedImageViewOnCell(_ cell: ProfileImageCell) {
        print("Show profile picture")
    }
}

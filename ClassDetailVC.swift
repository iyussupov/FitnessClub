//
//  ClassDetailVC.swift
//  FitnessClub
//
//  Created by Dev1 on 2/12/16.
//  Copyright © 2016 FXoffice. All rights reserved.
//

import UIKit
import Parse

class ClassDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var navBarTitle: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var contentField: UILabel!
    
    var classItem: Classes!
    var toggleRightDrawer: Bool?
    var toggleLeftDrawer: Bool?
    static var imageCache = NSCache()
    var preventAnimation = Set<NSIndexPath>()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var imageViewer: UIView!
    
    @IBOutlet weak var categoryLbl: BadgeViewStyle!
    
    var weekDays:[String] = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
   
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        self.evo_drawerController?.openDrawerGestureModeMask = .All
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 30.0
        
        self.updateUI()
        
        let tap = UITapGestureRecognizer(target: self, action: "showImageViewer")
        imageViewer.addGestureRecognizer(tap)
        
        
    }
    
    
    func updateUI() {
        
        navBarTitle.text = classItem.title?.uppercaseString
        titleLbl.text = classItem.title?.uppercaseString
        contentField.text = classItem.classDesc
        
        if let category = classItem.title where category != "" {
            self.categoryLbl.text = "   \(category.uppercaseString)         "
        } else {
            self.categoryLbl.hidden = true
        }
        
        var img: UIImage?
        
        if let url = classItem.classImg {
            
            img = ClassDetailVC.imageCache.objectForKey(url) as? UIImage
            
            if img != nil {
                self.headerImage.image = img
            } else {
                
                let featuredImage = classItem.classImg
                
                featuredImage!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        let image = UIImage(data:imageData!)!
                        self.headerImage.image = image
                        ClassDetailVC.imageCache.setObject(image, forKey: self.classItem!.classImg!)
                    }
                }
                
            }
            
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        headerImage.clipsToBounds = true
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekDays.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        return UITableViewCell()
        
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        var headerTransform = CATransform3DIdentity
        var labelsTransform = CATransform3DIdentity
        
        // PULL DOWN -----------------
        
        if offset < 0 {
            
            let headerScaleFactor:CGFloat = -(offset) / headerImage.bounds.height
            let headerSizevariation = ((headerImage.bounds.height * (1.0 + headerScaleFactor)) - headerImage.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            headerImage.layer.transform = headerTransform
        }
            
            // SCROLL UP/DOWN ------------
            
        else {
            
            // Header -----------
            
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            labelsTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            
        }
        
        // Apply Transformations
        
        headerImage.layer.transform = headerTransform
        
        categoryLbl.layer.transform = labelsTransform
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeHeaderToFit()
    }
    
    func sizeHeaderToFit() {
        let headerView = tableView.tableHeaderView!
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        let height = headerView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame
        
        tableView.tableHeaderView = headerView
    }
    
    
    @IBAction func postShareAction(sender: AnyObject) {
       
        var textToShare = ""
        
        if let title = classItem!.title where title != "" {
            textToShare = "\(classItem!.title!)"
        }
        
        if let myWebsite = NSURL(string: "")
        {
            let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
            //
            
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func DetailsBackBtn(sender: AnyObject) {
        
        if toggleRightDrawer == true {
            
            self.evo_drawerController?.toggleRightDrawerSideAnimated(true, completion: nil)
            
        } else if toggleLeftDrawer == true {
            
            self.evo_drawerController?.toggleLeftDrawerSideAnimated(true, completion: nil)
            
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ViewerVC" {
            if let viewerVC = segue.destinationViewController as? ViewerVC {
                if let classItem = sender as? Classes {
//                    viewerVC.post = classItem
                }
            }
        }
    }
    
    
}


//
//  ClassesVC.swift
//  FitnessClub
//
//  Created by Dev1 on 2/12/16.
//  Copyright © 2016 FXoffice. All rights reserved.
//

import UIKit
import Parse

class ClassesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func openMenu(sender: AnyObject) {
        self.evo_drawerController?.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    
    @IBAction func openSearch(sender: AnyObject) {
        self.evo_drawerController?.toggleDrawerSide(.Right, animated: true, completion: nil)
    }
    
    var classes = [Classes]()
    
//    var classesTitles:[String] = ["Boxing","Fitness","Pilates","Gym"];
    var classesIcons:[String] = ["boxer-icon","boxer-icon","boxer-icon","boxer-icon"];
//    var classesDesc:[String] = ["Trainers: Sam Smith, Eva Brown","Trainer: John Stuart","Trainers: Stan Bishop, Amanda Hoe","Trainer: Amanda Hoe"];

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        //
        self.navigationController?.view.setNeedsLayout()
        //
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentSizeDidChangeNotification:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
        //
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        parseClassesFromParse()
        
    }
    
    func parseClassesFromParse() {
        
        let PostsQuery: PFQuery =  PFQuery(className:"Classes")
        PostsQuery.includeKey("trainers")
        PostsQuery.addAscendingOrder("priority")
        PostsQuery.cachePolicy = .NetworkElseCache
        PostsQuery.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error: NSError?) -> Void in
            
            self.classes = []
           
            if error == nil {
                
                for object in objects! {
                    
                    let key = object.objectId as String!
                    let classItem = Classes(classId: key, dictionary: object)
                    self.classes.append(classItem)
                    
                }
                
            }
            
            self.tableView.reloadData()
            
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return classes.count;
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let classItem = self.classes[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("ClassesCell") as? ClassesCell {

            
            cell.configureCell(classItem)
            
            return cell
        } else {
            return PostCell()
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let classItem = self.classes[indexPath.row]
        
        performSegueWithIdentifier("ClassDetailVC", sender: classItem)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ClassDetailVC" {
            if let detailVC = segue.destinationViewController as? ClassDetailVC {
                if let classItem = sender as? Classes {
                    detailVC.classItem = classItem
                }
            }
        }
        if segue.identifier == "ViewerVC" {
            if let viewerVC = segue.destinationViewController as? ViewerVC {
                if let post = sender as? Post {
                    viewerVC.post = post
                }
            }
        }
    }
    
    
    
    
    
}

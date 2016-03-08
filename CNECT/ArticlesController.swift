//
//  ArticlesController.swift
//  SidebarMenu
//
//  Created by Tobin Bell on 2/13/16.
//  Copyright © 2016 Tobin Bell. All rights reserved.
//

import UIKit

class ArticlesController: UITableViewController {
    
    var posts = [WPPost]()
    let imageQueue = NSOperationQueue()
    
    var postSubset = WPPostSubset.All
    
    var selectedRow: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let indicator = addActivityIndicatorView()
        tableView.userInteractionEnabled = false
        
        let start = CACurrentMediaTime()
        
        cnect.posts(inSubset: postSubset) { posts in
            // Check for posts? (nil means error).
            if let posts = posts {
                
                // Reload the table view
                self.posts.appendContentsOf(posts)
                self.tableView.reloadData()
                
                let delta = CACurrentMediaTime() - start
                let remaining = 0.3 - Double.init(_bits: delta.value)
                
                if remaining > 0 {
                    usleep(UInt32(remaining * 1000000.0))
                }
                
                // Fade in the table.
                UIView.animateWithDuration(0.5, animations: {
                    indicator.alpha = 0
                }, completion: { _ in
                    indicator.removeFromSuperview()
                    self.tableView.userInteractionEnabled = true
                })
                
            } else {
                // TODO: Handle error.
            }
        }
        
        // Navigation item
        if let categoryID = postSubset.categoryID {
            let category = cnect.category(withID: categoryID)
            navigationItem.title = category?.title
        } else if let tagID = postSubset.tagID {
            let tag = cnect.tag(withID: tagID)
            navigationItem.title = tag?.title
        } else {
            navigationItem.title = "Top Stories"
        }
        
        
        // Add a custom back button to get back to MenuController
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "MenuButton"), style: .Plain, target: navigationController, action: "popViewControllerAnimated:")
        
        // After coming back from an article, the highlight should still be there.
        clearsSelectionOnViewWillAppear = false
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return selectedRow == indexPath.row ? 400 : 150
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ArticleCell", forIndexPath: indexPath)
        
        guard let articleCell = cell as? ArticleCell else {
            return cell
        }
        
        let post = posts[index]
        let category = cnect.category(withID: post.categoryID)
        
        articleCell.categoryLabel?.text = category?.title
        articleCell.titleLabel?.text = post.title
        articleCell.featuredImageView?.image = nil
        articleCell.excerptLabel?.text = post.excerpt.plainString
        
        post.featuredImage { image in
            articleCell.featuredImageView?.image = image
        }
        
        articleCell.adjustConstraintsForSelected(cell.selected)

        return articleCell
    }
    
    
    // Recalculate autolayout height.
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        selectedRow = nil
    }
    
    // Recalculate autolayout height.
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.beginUpdates()
        selectedRow = indexPath.row
        tableView.endUpdates()
        
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ArticleSegue" {
            if let articleController = segue.destinationViewController as? ArticleController,
                button = sender as? UIButton,
                cell = button.superview?.superview?.superview as? ArticleCell,
                indexPath = tableView.indexPathForCell(cell) {
                    articleController.articleTitle = posts[indexPath.row].title
                    articleController.articleAuthor = posts[indexPath.row].authorName
                    articleController.articleContent = posts[indexPath.row].content
            }
        }
    }

}

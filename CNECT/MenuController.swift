//
//  MenuController.swift
//  CNECT
//
//  Created by Tobin Bell on 2/27/16.
//  Copyright © 2016 Tobin Bell. All rights reserved.
//

import UIKit

class MenuController: UITableViewController {
    
    var categories = [WPCategory]()
    var tags = [WPTag]()
    
    let imageQueue = NSOperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let indicator = addActivityIndicatorView()
        
        let start = CACurrentMediaTime()
        var numberOfCalls = 0
        
        // Create a common operation to wait at least 0.3 seconds before fading out the indicator view.
        let hideIndicator = {
            
            numberOfCalls += 1
            if numberOfCalls != 2 {
                return
            }
            
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
        }
        
        // Fetch the categories from the Wordpress connection.
        cnect.categories { categories in
            if let categories = categories {
                // Reload the table view.
                self.categories.appendContentsOf(categories)
                self.tableView.reloadData()
                hideIndicator()
            }
        }
        
        // Fetch the tags from the Wordpress connection.
        cnect.tags { tags in
            if let tags = tags {
                // Reload the table view.
                self.tags.appendContentsOf(tags)
                self.tableView.reloadData()
                hideIndicator()
            }
        }
        
        // Hide the bottom border on navigation bar.
        navigationController?.navigationBar.borderView?.hidden = true
        
        // Switch to top stories by default.
        if let topStories = storyboard?.instantiateViewControllerWithIdentifier("ArticlesTableViewController") as? ArticlesController {
            navigationController?.pushViewController(topStories, animated: false)
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Sections"
        }
        
        if section == 1 {
            return "Publications"
        }
        
        return nil
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1 + categories.count
        }
        
        return tags.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Take the early path out if this is the default "Top Stories" section.
        if indexPath.section == 0 && indexPath.row == 0 {
            return tableView.dequeueReusableCellWithIdentifier("TopStoriesCell", forIndexPath: indexPath)
        }
        
        // Categories ("sections") section.
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath)
            guard let categoryCell = cell as? CategoryCell else {
                return cell
            }
            
            let index = indexPath.row - 1
            let category = categories[index]
            
            categoryCell.titleLabel?.text = category.title
            categoryCell.featuredImageView?.image = nil
            
            // Fetch and cache the category image.
            category.featuredImage { image in
                categoryCell.featuredImageView?.image = image
            }
            
            return categoryCell
        }
        
        // Otherwise; Tags ("publications") section.
        let cell = tableView.dequeueReusableCellWithIdentifier("TagCell", forIndexPath: indexPath)
        guard let tagCell = cell as? TagCell else {
            return cell
        }
        
        let index = indexPath.row
        let tag = tags[index]
        
        tagCell.titleLabel?.text = tag.title
        tagCell.universityLabel?.hidden = true
        tagCell.featuredImageView?.image = nil // TODO: Tag rows background?
        
        return tagCell
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
        
        if segue.identifier == "TopStoriesSegue",
            let articlesController = segue.destinationViewController as? ArticlesController {
                articlesController.postSubset = .All
        }
        
        if segue.identifier == "CategorySegue",
            let articlesController = segue.destinationViewController as? ArticlesController,
            senderCell = sender as? UITableViewCell,
            indexPath = tableView.indexPathForCell(senderCell) {
                articlesController.postSubset = WPPostSubset(categoryID: categories[indexPath.row - 1].ID, tagID: nil)
        }
        
        if segue.identifier == "TagSegue",
            let articlesController = segue.destinationViewController as? ArticlesController,
            senderCell = sender as? UITableViewCell,
            indexPath = tableView.indexPathForCell(senderCell) {
                print("Note: Tag article subsets are not yet supported")
                articlesController.postSubset = WPPostSubset(categoryID: nil, tagID: tags[indexPath.row].ID)
        }
    }


}

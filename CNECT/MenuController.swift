//
//  MenuController.swift
//  CNECT
//
//  Created by Tobin Bell on 2/27/16.
//  Copyright © 2016 Marco Monteiro. All rights reserved.
//

import UIKit

class MenuController: UITableViewController {
    
    var categories = [WPCategory]()
    var tags = [WPTag]()
    
    let imageQueue = NSOperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let indicator = addActivityIndicatorView()
        
        // Fetch the categories from the Wordpress connection.
        cnect.categories { categories in
            if let categories = categories {
                // Reload the table view.
                indicator.removeFromSuperview()
                self.categories.appendContentsOf(categories)
                self.tableView.reloadData()
            }
        }
        
        // Hide the bottom border on navigation bar.
        navigationController?.navigationBar.borderView?.hidden = true
        
        // Switch to top stories by default.
        if let topStories = storyboard?.instantiateViewControllerWithIdentifier("ArticlesTableViewController") as? ArticlesTableViewController {
            topStories.category = nil
            navigationController?.pushViewController(topStories, animated: false)
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 18))
        
        view.backgroundColor = UIColor.whiteColor()
        
        return view
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + categories.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryTableViewCell", forIndexPath: indexPath)
        guard let categoryCell = cell as? CategoryTableViewCell else {
            return cell
        }
        
        // Take the early path out if this is the default "Top Stories" section.
        if indexPath.row == 0 {
            categoryCell.featuredImageView?.image = UIImage(named: "TopStories")
            categoryCell.titleLabel?.text = "Top Stories"
            return categoryCell
        }
        
        let index = indexPath.row - 1
        let category = categories[index]
        
        categoryCell.titleLabel?.text = category.title
        categoryCell.imageView?.image = nil
        
        // Fetch and cache the category image.
        category.featuredImage { image in
            categoryCell.featuredImageView?.image = image
        }

        return categoryCell
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
        
        if segue.identifier == "SectionArticlesSegue",
            let articlesController = segue.destinationViewController as? ArticlesTableViewController,
            senderCell = sender as? UITableViewCell,
            indexPath = tableView.indexPathForCell(senderCell) {
                
                // Special case for "Top Stories"
                if indexPath.row == 0 {
                    articlesController.category = nil
                } else {
                    articlesController.category = categories[indexPath.row - 1]
                }
                
        }
    }


}

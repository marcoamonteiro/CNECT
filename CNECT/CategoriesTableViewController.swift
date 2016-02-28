//
//  CategoriesTableViewController.swift
//  CNECT
//
//  Created by Tobin Bell on 2/27/16.
//  Copyright © 2016 Marco Monteiro. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController {
    
    var categories = [WPCategory]()
    
    let imageQueue = NSOperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Fetch the categories from the Wordpress connection.
        cnect.getCategories { categories in
            if let categories = categories {
                self.categories.appendContentsOf(categories)
            } else {
                self.categories.removeAll()
            }
            
            // Reload the table view, performing UI updates on the main thread.
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.tableView.reloadData()
            }
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryTableViewCell", forIndexPath: indexPath)
        
        guard let categoryCell = cell as? CategoryTableViewCell else {
            return cell
        }

        // Configure the cell...
        categoryCell.nameLabel.text = categories[indexPath.row].name + " »"
        categoryCell.taglineLabel.text = categories[indexPath.row].tagline.uppercaseString
        // categoryCell.descriptionLabel.text = categories[indexPath.row].description
        categoryCell.descriptionLabel.text = ""
        
        // Cached loading of images.
        if let image = self.categories[indexPath.row].featuredImage {
            categoryCell.featuredImageView.image = image
        } else {
            imageQueue.addOperationWithBlock {
                if let data = NSData(contentsOfURL: self.categories[indexPath.row].featuredImageURL) {
                    if let image = UIImage(data: data) {
                        self.categories[indexPath.row].featuredImage = image
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            categoryCell.featuredImageView.image = image
                        }
                    }
                }
            }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ArticlesTableViewController.swift
//  SidebarMenu
//
//  Created by Marco Monteiro on 2/13/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class ArticlesTableViewController: UITableViewController {
    
    var clickedFlag : Bool = false;
    
    var posts: [WPPost]!
    
    let imageQueue = NSOperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        WP(site: "http://cnect.co").getPosts { posts in
            self.posts = posts
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if posts == nil {
            return 0
        }
        
        return posts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArticleCell", forIndexPath: indexPath) as! ArticleTableViewCell
       // cell.selectionStyle = UITableViewCellSelectionStyleNone
        
        cell.selectionStyle = .None;
        cell.titleLabel.text = posts[indexPath.row].title
        cell.authorLabel.text = posts[indexPath.row].authorName
        
        if let image = self.posts[indexPath.row].featuredImage {
            cell.featuredImageView.image = image
        } else {
            imageQueue.addOperationWithBlock {
                if let data = NSData(contentsOfURL: self.posts[indexPath.row].featuredImageURL) {
                    if let image = UIImage(data: data) {
                        self.posts[indexPath.row].featuredImage = image
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            cell.featuredImageView.image = image
                        }
                    }
                }
            }
        }

        // Configure the cell...

        return cell
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
            let articleController = segue.destinationViewController as! ArticleController
            
            if let cell = sender as? ArticleTableViewCell {
                if let indexPath = tableView.indexPathForCell(cell) {
                    articleController.articleTitle = posts[indexPath.row].title
                    articleController.articleAuthor = posts[indexPath.row].authorName
                    articleController.articleFeaturedImageURL = posts[indexPath.row].featuredImageURL
                    articleController.articleContent = posts[indexPath.row].content
                }
            }
        }
    }


}

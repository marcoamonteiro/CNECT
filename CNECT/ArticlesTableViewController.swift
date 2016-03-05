//
//  ArticlesTableViewController.swift
//  SidebarMenu
//
//  Created by Marco Monteiro on 2/13/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class ArticlesTableViewController: UITableViewController {
    
    var posts = [WPPost]()
    let imageQueue = NSOperationQueue()
    
    var category: WPCategory?
    
    var selectedRow: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let indicator = addActivityIndicatorView()
        
        cnect.posts(inCategoryID: category?.ID) { posts in
            if let posts = posts {
                // Reload the table view
                indicator.removeFromSuperview()
                self.posts.appendContentsOf(posts)
                self.tableView.reloadData()
            }
        }
        
        // Navigation item
        navigationItem.title = category?.title ?? "Top Stories"
        
        // Auto Layout cell height
        //tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.estimatedRowHeight = 150
        
        // Add a custom back button to get back to Sections
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "MenuButton"), style: .Plain, target: navigationController, action: "popViewControllerAnimated:")
        
        // After coming back from an article, the highlight should still be there.
        clearsSelectionOnViewWillAppear = false
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return posts.isEmpty ? 0 : 1
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
        
        guard let articleCell = cell as? ArticleTableViewCell else {
            return cell
        }
        
        let post = posts[index]
        let category = cnect.categoryWithID(post.categoryID)
        
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

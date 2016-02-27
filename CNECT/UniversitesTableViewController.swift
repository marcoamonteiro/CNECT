//
//  UniversitesTableViewController.swift
//  SidebarMenu
//
//  Created by Marco Monteiro on 2/7/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class UniversitesTableViewController: UITableViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBAction func Stanford(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://bases.stanford.edu/")!);
    }
    
    @IBAction func Columbia(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://coreatcu.com/")!);
    }
    
    @IBAction func Harvard(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.harvardventures.org/")!);
    }
    
    @IBAction func Northwestern(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.nuisepic.com/")!);
    }
    
    @IBAction func USC(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://sparksc.org/")!);
    }
    
    @IBAction func Syracuse(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://whitman.syr.edu/programs-and-academics/academics/eee/index.aspx")!);
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        /*
        let bgImage = UIImage(named: "background1.png");
        var blurredImage = bgImage!.applyBlurWithRadius(
            CGFloat(5),
            tintColor: nil,
            saturationDeltaFactor: 1.0,
            maskImage: nil
        )
*/
        let bg = UIImageView(image: UIImage(named: "background1.png"));
        let lightBlur = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight);
        let blurView = UIVisualEffectView(effect: lightBlur);
        blurView.frame = bg.bounds;
        bg.addSubview(blurView);
        tableView.backgroundView = bg;

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

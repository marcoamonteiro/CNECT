//
//  ArticleController.swift
//  SidebarMenu
//
//  Created by Marco Monteiro on 2/26/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import WebKit

class ArticleController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var contentView: WKWebView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var articleTitle = ""
    var articleAuthor = ""
    var articleContent = "<b>test</b>"
    var articleFeaturedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = articleTitle
        authorLabel.text = articleAuthor
        
        //contentView.delegate = self
        contentView.scrollView.scrollEnabled = false
        contentView.loadHTMLString(articleContent, baseURL: nil)


        
        featuredImageView.image = articleFeaturedImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        //if let heightString = webView.stringByEvaluatingJavaScriptFromString("document.height"),
          //  height = Int(heightString) {
                
            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: 400 + 1000)
            
            contentView.frame = CGRect(x: contentView.frame.minX, y: 200, width: contentView.frame.width, height: 1000)


                
                print(contentView.frame)
                print(scrollView.contentSize)
       // }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

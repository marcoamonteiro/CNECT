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
    
    static var articleCSS: String?
    
    @IBOutlet weak var contentView: UIWebView!
    
    var articleTitle = ""
    var articleAuthor = ""
    var articleContent = "<b>test</b>"
    var articleFeaturedImageURL: NSURL?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        formatHTML()
        contentView.loadHTMLString(articleContent, baseURL: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func formatHTML() {
        
        articleContent = "<div id='cnect-app-article-content'>\(articleContent)</div>"
        
        if ArticleController.articleCSS == nil {
            do {
                ArticleController.articleCSS = try String(contentsOfURL: NSBundle.mainBundle().URLForResource("Article", withExtension: "css")!)
            } catch {
                ArticleController.articleCSS = ""
            }
        }

        articleContent = "<h2 id='cnect-app-article-category'>News</h2><h1 id='cnect-app-article-title'>\(articleTitle)</h1><h3 id='cnect-app-article-author'><span class='by'>By</span> \(articleAuthor)</h3>" + articleContent
        if let imageURL = articleFeaturedImageURL {
            articleContent = "<img id='cnect-app-featured-image' src='\(imageURL.absoluteString)' />" + articleContent
        }
        
        if let articleCSS = ArticleController.articleCSS {
            articleContent = "<style type=\"text/css\">\(articleCSS)</style>" + articleContent
        }
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

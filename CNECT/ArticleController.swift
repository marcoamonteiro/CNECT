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
        
        /*
        let statusBlur = UIBlurEffect(style: .ExtraLight)
        let statusEffect = UIVisualEffectView(effect: statusBlur)
        statusEffect.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 20)
        
        view.addSubview(statusEffect)*/
        
        /*
        let statusFade = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        statusFade.backgroundColor = UIColor.whiteColor()
        
        let gradientMask = CAGradientLayer()
        gradientMask.frame = statusFade.bounds
        
        gradientMask.colors = [UIColor.whiteColor().CGColor, UIColor.clearColor().CGColor]
        gradientMask.startPoint = CGPoint(x: 0.0, y: 0.25)
        gradientMask.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        statusFade.layer.mask = gradientMask
        view.addSubview(statusFade)
*/
        
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

        articleContent = "<h1 id='cnect-app-article-title'>\(articleTitle)</h1><h2 id='cnect-app-article-author'><span class='by'>By</span> \(articleAuthor)</h2>" + articleContent
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

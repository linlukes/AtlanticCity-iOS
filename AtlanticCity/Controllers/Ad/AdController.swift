//
//  AdController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 15/07/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import WebKit

class AdController: UIViewController,WKNavigationDelegate,WKUIDelegate {

    @IBOutlet var ad_webview: WKWebView!
    var url = ""
    var backButton: UIBarButtonItem?
    var forwardButton: UIBarButtonItem?
    override func viewDidLoad() {
          super.viewDidLoad()
          guard let url = URL(string: url) else { return }
          ad_webview.isUserInteractionEnabled = true
          ad_webview.navigationDelegate = self
          ad_webview.uiDelegate = self
          ad_webview.configuration.preferences.javaScriptEnabled = true
          let request = URLRequest(url: url)
          ad_webview.load(request)
        
          self.navigationController?.setToolbarHidden(false, animated: true)
          let backButton = UIBarButtonItem(
              image: UIImage(systemName: "arrow.left")!.withTintColor(.blue, renderingMode: .alwaysTemplate),
              style: .plain,
              target: self.ad_webview,
              action: #selector(WKWebView.goBack))
          let forwardButton = UIBarButtonItem(
              image: UIImage(systemName: "arrow.right")!.withTintColor(.blue, renderingMode: .alwaysTemplate),
              style: .plain,
              target: self.ad_webview,
              action: #selector(WKWebView.goForward))
          let reloadButton = UIBarButtonItem(
                     image: UIImage(systemName: "arrow.counterclockwise")!.withTintColor(.blue, renderingMode: .alwaysTemplate),
                     style: .plain,
                     target: self.ad_webview,
                     action: #selector(WKWebView.reload))

          self.toolbarItems = [backButton, forwardButton,
                               UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                               reloadButton
          ]
          self.backButton = backButton
          self.forwardButton = forwardButton
      }
    override func viewDidAppear(_ animated: Bool) {
        Helpers.showHUD(view: self.view, progressLabel: "Loading...")
    }
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
              if let frame = navigationAction.targetFrame,
                  frame.isMainFrame {
                  return nil
              }
              webView.load(navigationAction.request)
              return nil
      }
      func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
          Helpers.dismissHUD(view: self.view, isAnimated: true)

      }

      func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
          Helpers.dismissHUD(view: self.view, isAnimated: true)
      }
    
    @IBAction func back_btn_listener(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func close_btn_listener(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
      
    }
    

}

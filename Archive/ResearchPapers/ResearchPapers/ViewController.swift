//
//  ViewController.swift
//  ResearchPapers
//
//  Created by Yuvaraj Mayank Konjeti  on 12/18/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var detailsTextView: UITextView!
    var report:techReport? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let report = report {
            var dataStr = ""
            dataStr = (report.title.count > 0) ? "Title : " + report.title + "\n\n" : ""
            dataStr = (report.year.count > 0) ? dataStr + "Year : " + report.year + "\n\n" : dataStr
            dataStr = (report.authors.count > 0) ? dataStr + "Authors : " + report.authors + "\n\n"  : dataStr
            dataStr = (report.email != nil) ? dataStr + "Email : " + (report.email ?? "") + "\n\n"  : dataStr
            dataStr = (report.abstract != nil) ? dataStr + "Abstract : \n" + (report.abstract ?? "") + "\n\n" : dataStr
            var attributedOriginalText = NSMutableAttributedString(string: dataStr)
            if let url = report.pdf {
                dataStr = (url.absoluteString.count > 0) ? dataStr + "URL : \n" +  (url.absoluteString) + "\n\n" : dataStr
                attributedOriginalText = NSMutableAttributedString(string: dataStr)
                let linkRange = attributedOriginalText.mutableString.range(of: (url.absoluteString))
                attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: url.absoluteString, range: linkRange)
                self.detailsTextView.attributedText = attributedOriginalText
                self.detailsTextView.isUserInteractionEnabled = true
                self.detailsTextView.isEditable = false
                self.detailsTextView.linkTextAttributes = [
                    .foregroundColor: UIColor.blue,
                    .underlineStyle: NSUnderlineStyle.single.rawValue
                ]
            }else{
               detailsTextView.attributedText = attributedOriginalText
            }
        }
    }
}


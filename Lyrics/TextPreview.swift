//
//  TextPreview.swift
//  Lyrics
//
//  Created by Eru on 15/11/18.
//  Copyright © 2015年 Eru. All rights reserved.
//

import Cocoa

class TextPreview: NSView {
    
    private var attributes: [String:AnyObject]
    private var backgroundColor: NSColor
    private var image: NSImage
    private var bkLayer: CALayer!
    private var textLayer: CATextLayer!
    private let stringValue: String = NSLocalizedString("PREVIEW_TEXT", comment: "")

    required init?(coder: NSCoder) {
        attributes = [String:AnyObject]()
        backgroundColor = NSColor.blackColor()
        image = NSImage(named: "preview_bkground")!
        super.init(coder: coder)
        
        self.layer = CALayer()
        self.layer?.speed = 5
        self.wantsLayer = true
        self.layer?.contents = image
        
        
        bkLayer = CALayer()
        bkLayer.speed = 5
        bkLayer.anchorPoint = NSZeroPoint
        bkLayer.position = NSZeroPoint
        bkLayer.cornerRadius = 12
        self.layer?.addSublayer(bkLayer)
        
        textLayer = CATextLayer()
        textLayer.speed = 5
        textLayer.anchorPoint = NSZeroPoint
        textLayer.position = NSZeroPoint
        textLayer.alignmentMode = kCAAlignmentCenter
        bkLayer.addSublayer(textLayer)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "viewChanged:", name: "PrefsViewChanged", object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // Layers don't fade out, so we have to do it selves.
    func viewChanged(n: NSNotification) {
        let userInfo = n.userInfo as! [String:AnyObject]
        let fontAndColorPrefs: String = NSLocalizedString("FONT_COLOR", comment: "")
        if userInfo["OldViewName"] as! String == fontAndColorPrefs {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.layer?.hidden = true
                self.bkLayer.hidden = true
                self.textLayer.hidden = true
            })
        } else if userInfo["NewViewName"] as! String == fontAndColorPrefs {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.layer?.hidden = false
                self.bkLayer.hidden = false
                self.textLayer.hidden = false
            })
        }
    }
    
    func setAttributs(font:NSFont, textColor:NSColor, bkColor:NSColor, enableShadow:Bool, shadowColor:NSColor, shadowRadius:CGFloat) {
        backgroundColor = bkColor
        attributes.removeAll()
        attributes[NSForegroundColorAttributeName] = textColor
        attributes[NSFontAttributeName] = font
        if enableShadow {
            textLayer.shadowColor = shadowColor.CGColor
            textLayer.shadowRadius = shadowRadius
            textLayer.shadowOffset = NSZeroSize
            textLayer.shadowOpacity = 1
        } else {
            textLayer.shadowOpacity = 0
        }
        drawString()
    }
    
    func drawString() {
        let viewSize = self.bounds.size
        let attrString: NSAttributedString = NSAttributedString(string: stringValue, attributes: attributes)
        var strSize: NSSize = attrString.size()
        strSize.width += 50
        let strOrigin: NSPoint = NSMakePoint((viewSize.width-strSize.width)/2, (viewSize.height-strSize.height)/2)
        bkLayer.backgroundColor = backgroundColor.CGColor
        bkLayer.frame.size = strSize
        bkLayer.frame.origin = strOrigin
        
        textLayer.frame.size = strSize
        textLayer.string = attrString
    }
    
}

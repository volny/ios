//
//  Macro.swift
//  mememe
//
//  Created by felix on 8/16/15.
//  Copyright (c) 2015 Volnyio. All rights reserved.
//

// <https://developer.apple.com/library/prerelease/ios/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson6.html>

import UIKit

class Macro { // NSObject {
    
    var topText: String
    var bottomText: String
    var macro: UIImage
    
    // Initialization - so my properties don't need to be optionals
    init(topText: String, bottomText: String, macro: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.macro = macro
    }
}

// I'm leaving the legacy code from `AppDelegate.swift` here for reference
//var memes = [Meme]()
//class Meme: UIResponder, UIApplicationDelegate {
//    var topText: String!
//    var bottomText: String!
//    var memedImage: UIImage!
//}


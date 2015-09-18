//
//  ViewController.swift
//  mememe
//
//  Created by felix on 8/9/15.
//  Copyright (c) 2015 Volnyio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIApplicationDelegate {
    @IBOutlet weak var imageViewFrame: UIImageView!

    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var ImagePickerButton: UIToolbar!
    @IBOutlet weak var PhotoButton: UIBarButtonItem!
    @IBOutlet weak var ShareButton: UIBarButtonItem!

    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!

    // see TableVC and CollectionVC's `didSelectRowAtIndexPath` methods - `controller.meme` refers here!
    var meme: Meme!

    // Text should be "Impact" font, all caps, white with a black outline.
    // we will make use of the defaultTextAttributes dictionary that governs font appearance
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -4.0,
    ]

    // only allow landscape for app bc what's the point if it doesn't work
    override func shouldAutorotate() -> Bool {
        return false
    }
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.LandscapeLeft.rawValue) | Int(UIInterfaceOrientationMask.LandscapeRight.rawValue)
    }

    override func viewDidLoad() { super.viewDidLoad()

        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes

        self.topTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        self.bottomTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters

        self.topTextField.delegate = self //UITextFieldDelegate
        self.bottomTextField.delegate = self //UITextFieldDelegate

        self.topTextField.hidden = true
        self.bottomTextField.hidden = true

        self.ShareButton.enabled = false
    }

    // `textfield`: The text field for which editing is about to begin.
    func textFieldDidBeginEditing(textField: UITextField) {

        if textField.text == "TOP" || textField.text == "BOTTOM" {
             textField.text = ""
        }
    }

    // `textfield`: The text field whose return button was pressed.
    func textFieldShouldReturn(textField: UITextField) -> Bool {

        // When a user presses return, the keyboard should be dismissed.
        self.view.endEditing(true)

        // when you're finished with the top focus on the bottom
        if textField == topTextField {
             self.bottomTextField.becomeFirstResponder()
        }

        // return `true` if the text field should implement its default behavior for the return button; otherwise, `false`.
        return false
    }

    override func viewWillAppear(animated: Bool) {

        self.PhotoButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)

        self.subcribeToKeyboardNotifications()
    }

    override func viewWillDisappear(animated: Bool) {
        self.unsubscribeFromKeyboardNotification()
    }

    // we call that in `viewWillApear`
    // NOTE the `:` in the `selector` string. w/o it the app will crash every time the keyboard slides out
    func subcribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // NSValue:CGRect
        return keyboardSize.CGRectValue().height
    }

    // use the keyboard height to shift the frame up and out of the way
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.resignFirstResponder() {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }

    @IBAction func pickAnImage(sender: AnyObject) {
        let controller = UIImagePickerController()

        controller.delegate = self // UIIMagePickerControllerDelegate

        controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary

        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func takeAPhoto(sender: AnyObject) {
        let controller = UIImagePickerController()
        
        controller.delegate = self
        controller.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(controller, animated: true, completion: nil)
    }

    // the `info` dict that's passed here contains the UIImage objects the user chose
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {

        // conditionally unwrap and conditionally downcast image to UIImage
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {

            self.imageViewFrame.image = image

            self.dismissViewControllerAnimated(true, completion: nil)

            self.ShareButton.enabled = true

            self.topTextField.hidden = false
            self.bottomTextField.hidden = false
        }
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // Render the view to an image to create the finished macro
    func generateMemeImage() -> UIImage {

        // hide toolbar and navbar
        //TODO: just hiding toolbar and navbar won't do, as we'll then have white space underneath the image
        // either try to work with NavCtrl or push the image to a new view where it can be fullscreen
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.toolbar.hidden = true
        // breaks prolly bc there is no Navigation Controller?
        //self.navigationController?.setToolbarHidden(true, animated: false)

        // screenshot the frame to create the meme basically
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let imageMacro:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // show toolbar and navbar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.toolbar.hidden = false
        
        // once swiching to tabBar try
        //self.tabBarController?.tabBar.hidden = false

        return imageMacro
    }

    @IBAction func ShareAndSaveMeme(sender: AnyObject) {

        let generatedMeme = generateMemeImage()
        let controller = UIActivityViewController(activityItems: [generatedMeme], applicationActivities: nil)
        self.presentViewController(controller, animated: true, completion: nil)

        // the completion handler gets called once the sharing is completed
        //TODO: get rid of the completion handler and save on button press - if you press the share button it should saves, not after completion!
        controller.completionWithItemsHandler = {
            (activity, success, items, error) in
            self.save()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    func save() {

        // from Udacity
        // var meme = Meme(top: topField.text!, bottom:bottomField.text!, image: imageView.image, memedImage: generateMemeImage())

        // mine - fails for a strange reason
        // var meme = Meme( text: textField.text!, bottomText: bottomField.text!, image: imageViewFrame.image, memedImage: generateMemeImage())
        
        // placeholder
        var meme = Meme()
        
        // to save a finished Macro we create a new instance of `Macro`
        var
        
        // add the newly created meme to the Model
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
}












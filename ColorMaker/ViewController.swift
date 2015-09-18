//
//  ViewController.swift
//  ColorMaker

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var redControl: UISlider!
    @IBOutlet weak var greenControl: UISlider!
    @IBOutlet weak var blueControl: UISlider!
    @IBOutlet weak var showColor: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func changeColorComponent(sender: AnyObject) {
        
        var redValue = CGFloat(self.redControl.value)
        var greenValue = CGFloat(self.greenControl.value)
        var blueValue = CGFloat(self.blueControl.value)
        
        let r: CGFloat = redValue
        let g: CGFloat = greenValue
        let b: CGFloat = blueValue
        
        view.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        
        var redHex = NSString(format:"%2X", Int(redValue*255))
        var greenHex = NSString(format:"%2X", Int(greenValue*255))
        var blueHex = NSString(format:"%2X", Int(blueValue*255))
        
        var hexString = ("#" + (redHex as String) + (greenHex as String) + (blueHex as String)).stringByReplacingOccurrencesOfString(" ", withString: "0", range: nil)
        
        self.showColor.text = hexString
        
        
    }
}


//
//  TableViewController.swift
//  mememe
//
//  Created by felix on 8/15/15.
//  Copyright (c) 2015 Volnyio. All rights reserved.
//

// // the TABLE VIEW of saved image macros aka

import UIKit

class TableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Udacity: "In the Sent Memes Table and Collection View Controllers:"
    var memes: [Meme]!
    
    override func viewWillAppear(animated: Bool) {
        
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("Counted \(self.memes.count) rows")
        return self.memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell") as! UITableViewCell

        let meme = self.memes[indexPath.row]

        cell.textLabel?.text = meme.topText // skip bottomText for now
        cell.imageView?.image = meme.memedImage
        // also skip `cell.detailTextLabel` for now

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("CreatorVC") as! ViewController! // last part refers to the file named `ViewController.swift`, even though it's storyboard identifier is `CreatorVC`
        controller.meme = self.memes[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
}



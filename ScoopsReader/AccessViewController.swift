//
//  AccessViewController.swift
//  ScoopsReader
//
//  Created by MacBook Pro on 1/3/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

import UIKit

class AccessViewController: UIViewController {
    
    var callNewsCloud : NewsAuthorTableViewController?
    
    @IBOutlet weak var accessAuthor: UIButton!
    @IBOutlet weak var accessLector: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        
        settingPropeties(accessLector)
        settingPropeties(accessAuthor)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        navigationItem.title = "Scoopes Reader"
        navigationController?.navigationBar.tintColor = UIColor.orangeColor()
        // Color de fondo  para el 'navigationBar'
        UINavigationBar.appearance().barTintColor = UIColor.blackColor()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Establece propiedades a los atributos de un UIBotton
    func settingPropeties (object:UIButton){
        
        object.layer.cornerRadius = 5
        object.layer.shadowRadius = 10
        object.layer.shadowOpacity = 0.8
        object.layer.shadowOffset = CGSizeMake(3, 3)
        object.backgroundColor = UIColor.orangeColor()
        object.layer.shadowColor = UIColor.orangeColor().CGColor
        object.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
    
    // MARK: Action
    
    @IBAction func callNewsCloud(sender: AnyObject) {
        //self.callNewsCloud?.populateModel()
    }
    
    @IBAction func authorButton(sender: UIButton) {
        if sender == self.accessAuthor{
            self.activityIndicator.startAnimating()
        }
    }
    
    @IBAction func unwindToNewsAuthorTable(sender : UIStoryboardSegue) {
        if sender.destinationViewController is NewsAuthorTableViewController{
            self.activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    
    }*/
}














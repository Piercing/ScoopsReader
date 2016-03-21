//
//  AccessViewController.swift
//  ScoopsReader
//
//  Created by MacBook Pro on 1/3/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

import UIKit

class AccessViewController: UIViewController {
    
    // Propiedad cliente, referencia a 'Mob.Servic'
    var client : MSClient = MSClient(applicationURL: NSURL(
        string: "https://scoopsdailay.azure-mobile.net/"),
        applicationKey: "SFfIMXQedqiHrvQJXiIuVKIomiMign98")
    
    var callNewsCloud : NewsAuthorTableViewController?
    
    // Flag
    var log : Bool = false
    
    @IBOutlet weak var accessAuthor: UIButton!
    @IBOutlet weak var accessLector: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var logIntoSocialNetworks: UIButton!
    
    @IBOutlet weak var buttonAuthor: UIButton!
    @IBOutlet weak var buttonLector: UIButton!
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        
        settingPropeties(accessLector)
        settingPropeties(accessAuthor)
        settingPropeties(logIntoSocialNetworks)
        
        if (log == false) {
            
            self.buttonAuthor.highlighted = true
            self.buttonLector.highlighted = true
            self.buttonAuthor.enabled = false
            self.buttonLector.enabled = false
            
        }else{
            
            self.buttonAuthor.enabled = true
            self.buttonAuthor.highlighted = false
            self.buttonLector.enabled = true
            self.buttonLector.highlighted = false
        }
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
    
//    @IBAction func callNewsCloud(sender: AnyObject) {
//        self.callNewsCloud?.populateModel()
//    }
    @IBAction func logIntoSocialNetworks(sender: AnyObject) {
        
        if sender as! NSObject == self.logIntoSocialNetworks{
            
            // ******* 1º: Comprobar si estamos logueados *******
            // Si el el usuario tiene algo, es que está logueados
            if client.currentUser != nil {
                
                // Creando un alert
                let alert = UIAlertController(title: "Log with Facebook",
                    message: "You're still logged in, continue", preferredStyle: UIAlertControllerStyle.Alert)
                
                // Añadiendo acciones (buttons)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                //alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
                
                // Mostrando el alert
                self.presentViewController(alert, animated: true, completion: nil)
                
                
                print("Estamos logueados")
                self.log = true
                
                
                
            }else{
                // Sino, nos logueamos
                client.loginWithProvider("facebook", // provider, facebook, twttier, google, etc, etc
                    controller: self,// donde queremos que aparezca la ventana modal de autenticarnos
                    animated: true,
                    completion: { (user: MSUser?, error: NSError?) -> Void in//Devuleve un user logueado y error
                        
                        if (error != nil){
                            print("Houston, we have a problem to log 😱😱")
                            self.log = false
                        }else{
                            
                            // Si tenemos éxito ==> "facebook: 23425jqsdfjasñqw3rlñdsfu343a689qflkz (i.e)
                            
                            // Creando un alert
                            let alert = UIAlertController(title: "Log with Facebook",
                                message: "You've logged correctly", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            // Añadiendo acciones (buttons)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                            //alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
                            
                            // Mostrando el alert
                            self.presentViewController(alert, animated: true, completion: nil)
                            
                            self.buttonAuthor.enabled = true
                            self.buttonAuthor.highlighted = false
                            self.buttonLector.enabled = true
                            self.buttonLector.highlighted = false
                            
                            self.log = true
                        }
                })
                
            }
        }
    }
    
    @IBAction func authorButton(sender: UIButton) {
        if sender == self.accessAuthor{
           
        }
    }
    
//    @IBAction func unwindToNewsAuthorTable(sender : UIStoryboardSegue) {
//        if sender.destinationViewController is NewsAuthorTableViewController{
//            //self.activityIndicator.stopAnimating()
//        }
//    }
    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    
    }*/
}

//
//@IBAction func logIntoSocialNetworks(sender: AnyObject) {
//    
//    // ******* 1º: Comprobar si estamos logueados *******
//    // Si el el usuario tiene algo, es que está logueados
//    if client.currentUser != nil {
//        
//        print("Estamos logueados")
//        
//    }else{
//        // Sino, nos logueamos
//        client.loginWithProvider("facebook", // provider, facebook, twttier, google, etc, etc
//            controller: self,// donde queremos que aparezca la ventana modal de autenticarnos
//            animated: true,
//            completion: { (user: MSUser?, error: NSError?) -> Void in//Devuleve un user logueado y error
//                
//                if (error != nil){
//                    print("Houston, we have a problem to log 😱😱")
//                }else{
//                    
//                    // Si tenemos éxito ==> "facebook: 23425jqsdfjasñqw3rlñdsfu343a689qflkz (i.e)
//                }
//        })
//        
//    }
//    
//}











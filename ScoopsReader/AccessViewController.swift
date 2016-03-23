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
        
        // Color fondo  para  la view
        self.view.backgroundColor = UIColor.blackColor()
        
        // Propiedades para atributos
        settingPropeties(accessLector)
        settingPropeties(accessAuthor)
        settingPropeties(logIntoSocialNetworks)
        
        // Si no estamos logados......
        if (log == false) {
            
            self.buttonAuthor.highlighted = true
            self.buttonLector.highlighted = false
            self.buttonAuthor.enabled = false
            self.buttonLector.enabled = true
            
            // Si estamos logados.....
        }else{
            
            self.buttonAuthor.enabled = true
            self.buttonAuthor.highlighted = false
            self.buttonLector.enabled = true
            self.buttonLector.highlighted = false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Estableciendo  título 'navigationItem'
        navigationItem.title = "Scoopes Reader"
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
    
    @IBAction func logIntoSocialNetworks(sender: AnyObject) {
        
        if sender as! NSObject == self.logIntoSocialNetworks{
            
            // ******* 1º: Comprobar si estamos logueados *******
            // Si el el usuario tiene algo, es que está logueados
            if isUserLoged() == true {
                
                print("You're loged")
                // Cargo los datos del  usuario que ya logueo
                if let usrLogin = loadUserAuthInfo(){
                    
                    // Cojo el 'id'del usuario de su red social y la asigno al currentUser del client
                    self.client.currentUser = MSUser(userId: usrLogin.usr)
                    // Cojo el 'idToken' del usuario logueado y lo asigno al MServiceToken del client
                    client.currentUser.mobileServiceAuthenticationToken = usrLogin.token
                    
                    // Creando un alert
                    let alert = UIAlertController(title: "Log with Facebook",
                        message: "Already loged, continue", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    // Añadiendo acciones (buttons)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    
                    // Mostrando el alert
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
            }else{
                // Sino, nos logueamos
                client.loginWithProvider("facebook", //  provider, facebook, twttier, google, etc, etc
                    controller: self,// donde queremos que aparezca la  ventana modal de autenticarnos
                    animated: true,
                    completion: { (user: MSUser?, error: NSError?) -> Void in // user logueado y error
                        
                        // Si hay error, Houston
                        if (error != nil){
                            print("Houston, we have a problem to log 😱😱")
                            
                            // Creando  un alert
                            let alert = UIAlertController(title: "Log with Facebook",
                                message: "Failed to authenticate", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            // Añadiendo acciones
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                            //alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
                            
                            // Mostrando el alert
                            self.presentViewController(alert, animated: true, completion: nil)
                            
                            // Bajo flag => flase
                            self.log = false
                            
                        }else{
                            
                            // Persistimos los credenciales del usuario log
                            saveAuthInfo(user)
                            
                            // Creando un alert
                            let alert = UIAlertController(title: "Log with Facebook",
                                message: "You've logged correctly", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            // Añadiendo acciones
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                            //alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
                            
                            // Mostrando el alert
                            self.presentViewController(alert, animated: true, completion: nil)
                            
                            // Establezco  acceso
                            self.buttonAuthor.enabled = true
                            self.buttonAuthor.highlighted = false
                            self.buttonLector.enabled = true
                            self.buttonLector.highlighted = false
                            
                            // Subo flag => flase
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











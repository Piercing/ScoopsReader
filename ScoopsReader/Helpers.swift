//
//  Helpers.swift
//  ScoopsReader
//
//  Created by MacBook Pro on 21/3/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

import Foundation


var logued : Bool = false
/// Guarda en local datos ususario obtenidos al loguearse
func saveAuthInfo (currentUser: MSUser?){
    
    // Persistimos la 'Info' obtenida del usuario en local
    // El 'userId' es el 'ID' del usuario en la red social
   let id = currentUser?.userId
    NSUserDefaults.standardUserDefaults().setObject(currentUser?.userId, forKey: "userId")
    
    // Hacemos lo mismo para token de red social
    // Nos da el token de sesión del usuario log
   let tokk = currentUser?.mobileServiceAuthenticationToken
    NSUserDefaults.standardUserDefaults().setObject(currentUser?.mobileServiceAuthenticationToken, forKey: "tokenID")
    
    logued = true
    
    print("userId: \(id) \n token: \(tokk)")
}

/// Devuelve los datos 'userId' y 'tokenID' del user log.
// Pongo los parámetros como opcionales, puede ser que no
// se haya logueado  el usuario y los parámetros sean nil
func loadUserAuthInfo () -> (usr : String, token : String)? {
    
    // Leemos del NSuserDefault
    let user = NSUserDefaults.standardUserDefaults().objectForKey("userId") as? String
    let tok = NSUserDefaults.standardUserDefaults().objectForKey("tokenID") as? String
    
    return (user!, tok!)
}

/// Comprueba si tenemos datos de un usuario log
func isUserLoged() -> Bool {
    
    //let result = logued
    
    // Leemos el usuario
//    let userID = NSUserDefaults.standardUserDefaults().objectForKey("userdId") as? String
//    
//    if let _ = userID {
//        result = true
//    }
    return logued
}




//
//  AppDelegate.swift
//  ScoopsReader
//
//  Created by MacBook Pro on 27/2/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var prueba : NewsViewController?
    
    var window: UIWindow?
    
    let client = MSClient(
        applicationURLString:"https://scoopsdailay.azure-mobile.net/",
        applicationKey:"VjcTsrgmahsJOviIgUWrrkpQHxIRKO71")
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //sleep(1)
        
//        // Usando el ==>'client' hacemos referencia a la tabla de los vídeos
//        let tablePhotos = client?.tableWithName("photos")
//        
//        // 1º: Guardamos las  fotos que queremos  persistir en Base de Datos
//        tablePhotos?.insert([
//            "title" : "prueba", "author" : "yo mismo","newText": "texto de prueba",
//            "rating" : 5, "amountVotes": 12, "ratingTotalNews": 120,
//            "blobName": "nombre blob", "containername" : "myphotoposts"],
//            completion: { (inserted: [NSObject : AnyObject]!, error: NSError?) -> Void in
//                print("Hello Azure!!!👋👍😋 👋👍😋")
//                // Si hay error
//                if error != nil {
//                    print("Houston, we have a problem to save  😱😵😱 => : \(error?.description)")
//                }
//                else {
//                    // 2º: Persistimos ahora el 'blob' en el Storage de Azure
////                    print("All right when saving Database Houston, now plays Blob 😎😎😎")
////                    // Se supone que aquí la photo ya debe de estar capturada
////                    self.uploadToStorage(self.bufferPhoto!, blobName: self.blobName!)
//                }
//        })
        
        
        // Diccionario para ingresar en Mobile Service de Azure
        let item = ["id":"SDR5-FGT4-23DE-QWEA" , "title":"Photo 03 prueba", "author":"Carlos", "newtext":"hola" , "rating":"3", "totalrating":"25"]
        
        // Obtengo la tabla donde  insertar los datos en 'Azure'
        let table = client.tableWithName("photos")
        // Inserto
        table.insert(item) {
            (insertedItem, error : NSError?) in
            print("Hello Azure!!!👋👍😋")
            if (error != nil) {
                print("Error" + error!.description)
            } else {
                print("Item inserted, id:  \(insertedItem["id"])")
            }
        }
        
        //Predicado para filtar la consulta
//        let predicate = NSPredicate(format: "rating > 4", [])
//        // Consulta a la tabla en ===> Azure
//        table.readWithPredicate(predicate) { (result : MSQueryResult?, error : NSError?) -> Void in
//            
//            if (error != nil) {
//                print("Error" + error!.description)
//            } else {
//                print("Item delete, rating > 4")
//                let registers : MSQueryResult = result!
//                // Borro
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
//                    table.delete(registers.items[0] as! [NSObject : AnyObject], completion: { (result: AnyObject?, error : NSError?) -> Void in
//                        
//                        if (error != nil) {
//                            print("Error" + error!.description)
//                        } else {
//                            print("Item delete -> \(result)")
//                        }
//                    })
//                })
//            }
//        }
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}


//
//  News.swift
//  ScoopsReader
//
//  Created by MacBook Pro on 1/3/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

import UIKit

class News : NSObject, NSCoding {
    
    // MARK: Properties
    
    // Enum coordenadas:'latitude' y 'longitude'
    enum coordinatesEnum : Double {
        case longitude, latitude
    }
    
    // Estructura con el conjunto de valores de
    // las coordenadas:  'longitude', 'latitude'
    struct location {
        var coordinates : Set<coordinatesEnum>
    }
    
    var title : String
    var author : String
    var newsText : String
    var photo : UIImage?
    var state :  Bool 
    var rating : Int
    // Inicializando  variable  con coordenadas
    var initCoordinates = location(coordinates: [.longitude, .latitude])
    var longitude : coordinatesEnum = .longitude
    var latitude : coordinatesEnum = .latitude
    
    // Variable computada para la fecha  actual
    var dateActual : NSDate{
        // Devuelvo la  fecha de  creación news
        get {
            return NSDate()
        }
        // Como la observo si cambia, actualizo
        // a  fecha que  ha producido el cambio
        set(newDate){
            self.dateActual = newDat
        }
    }
    
    // Observo  los  cambios  de la fecha actual
    var newDat : NSDate {
        // Cuando la fecha actual  cambie y sea
        // distinta a la que tenía al principio
        didSet {
            let newDateActual = NSDate()
            if dateActual != newDateActual{
                // Actualizo a fecha a la nueva
                dateActual = newDateActual
            }
        }
    }
    
    
    // MARK: Archiving Paths
    
    // Constantes 'statics' acceder fuera
    // Lugar  donde  se guardan las 'news'
    static let documentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    // Path donde se  guardarán las 'news'
    static let archiveURL = documentsDirectory.URLByAppendingPathComponent("news")

    
    // MARK: Types
    // Struct: => key para codificar propiedades
    struct propertyKey {
        static let titleKey = "title"
        static let authorKey = "author"
        static let newsTextKey = "textKey"
        static let ratingKey = "rating"
        static let photoKey = "photo"
        static let dateActualKey = "date"
        static let latitudeKey = "latitude"
        static let longitudeKey = "longitude"
        static let stateKey = "state"
    }
    
    
    // MARK:  Initialization
    init? (title : String, author : String, newsText : String, rating : Int,
        photo : UIImage?,  state : Bool, newDat : NSDate) {
            
            // Inicilizando propiedades almacenadas
            self.title = title
            self.author = author
            self.newsText = newsText
            self.rating = rating
            self.photo = photo
            self.state = state
            self.newDat = newDat
            
            // Llamo al inicializador superclase
            super.init()
            
            // Inicializador fallable si se cumple:
            if title.isEmpty || author.isEmpty ||
                newsText.isEmpty || rating < 0 ||
                newDat == "" {
                    return nil
            }
    }
    
    // MARK: NScoding
    
    // Métodos Protocolos para codificar y descodificar la información guardada
    func encodeWithCoder(aCoder: NSCoder) {
        // encodeObject codifica cualquier tipo de objeto, codificando el valor
        // de cada propiedad de 'news'
        aCoder.encodeObject(title, forKey: propertyKey.titleKey)
        aCoder.encodeObject(author, forKey: propertyKey.authorKey)
        aCoder.encodeObject(newsText, forKey: propertyKey.newsTextKey)
        aCoder.encodeObject(rating, forKey: propertyKey.ratingKey)
        aCoder.encodeObject(photo, forKey: propertyKey.photoKey)
        aCoder.encodeObject(dateActual, forKey: propertyKey.dateActualKey)
        aCoder.encodeObject(state, forKey: propertyKey.stateKey)
        //        aCoder.encodeObject(latitude as? AnyObject, forKey: propertyKey.latitudeKey)
        //        aCoder.encodeObject(longitude as? AnyObject, forKey: propertyKey.longitudeKey)
    }
    
    // Inicializador  de conveniencia: ===> debe implementarse en las subclases
    // Sólo se aplicará cuando se vayan a guardar datos o cargar datos ==> (rw)
    required convenience init?(coder aDecoder: NSCoder) {
        // Como 'decodeObjectForKey' devuelve un 'AnyObject' lo casteo a 'String'
        let title = aDecoder.decodeObjectForKey(propertyKey.titleKey) as! String
        let author = aDecoder.decodeObjectForKey(propertyKey.authorKey) as! String
        let newsText = aDecoder.decodeObjectForKey(propertyKey.newsTextKey) as! String
        let rating = aDecoder.decodeObjectForKey(propertyKey.ratingKey) as! Int
        let photo = aDecoder.decodeObjectForKey(propertyKey.photoKey) as? UIImage
        let date = aDecoder.decodeObjectForKey(propertyKey.dateActualKey) as! NSDate
        let state = aDecoder.decodeObjectForKey(propertyKey.stateKey) as! Bool
        //        let latitude = aDecoder.decodeObjectForKey(propertyKey.latitudeKey) as! Double
        //        let longitude = aDecoder.decodeObjectForKey(propertyKey.longitudeKey) as! Double
        
        // Llammo al incializador designado
        self.init(title : title, author : author, newsText : newsText, rating : rating,
            photo : photo,  state: state, newDat: date)
        
    }
}

















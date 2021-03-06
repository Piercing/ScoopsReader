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
    //    enum coordinatesEnum : Double {
    //        case longitude, latitude
    //    }
    
    // Estructura con el conjunto de valores de
    // las coordenadas:  'longitude', 'latitude'
    //    struct location {
    //        var coordinates : Set<coordinatesEnum>
    //    }
    
    // Valor que tiene una start al pulsarse
    var rating : Int = 0
    // Cantidad  usuarios  votan una noticia
    var amountVotes : Int = 0
    // Rating acmulado que tiene una noticia
    var ratingTotalNews : Int = 0
    // result = 'ratingTotalNews/amountVotes'
    var result    : Int = 0
    var title     : String
    var author    : String
    var newstext  : String
    //var id        : String
    //var photo   : UIImage?
    // Variable state computada
    var state     :  Bool = false {
        didSet (newValue){
            state = newValue
        }
    }
    var longitude : Double?
    var latitude  : Double?
    var newDat    : NSDate?
    // Inicializando  variable  con coordenadas
    //var initCoordinates = location(coordinates: [.longitude, .latitude])
    
    //
    //    // Variable computada para la fecha  actual
    
    //        {
    //        // Devuelvo la  fecha de  creación news
    //        get {
    //            return NSDate()
    //        }
    //        // Como la observo si cambia, actualizo
    //        // a  fecha que  ha producido el cambio
    //        set(newDate){
    //            self.newDat = newDate
    //        }
    //    }
    //
    //    // Observo  los  cambios  de la fecha actual
    //    var dateActual : NSDate {
    //        // Cuando la fecha actual  cambie y sea
    //        // distinta a la que tenía al principio
    //        didSet {
    //            let newDateActual = NSDate()
    //            if newDat != newDateActual{
    //                // Actualizo a fecha a la nueva
    //                newDat = newDateActual
    //            }
    //        }
    //    }
    
    
    // MARK: Archiving Paths
    
    // Constantes 'statics' acceder fuera
    // Constante con la cual doy nombre con un 'UUIDString' ya creado y con la extensión 'jpg'
    static let blobNameUUID = "/photo-\(NSUUID().UUIDString).jpg"
    // Lugar  donde  se guardan las 'news'
    static let documentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    // Path donde se  guardarán las 'news'
    static let archiveURL = documentsDirectory.URLByAppendingPathComponent("news")
    // Lugar donde se  guardarán  'photos'
    static let photosDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    // Path donde se guardar  las 'photos'
    static let archivePhotosURL = photosDirectory.URLByAppendingPathComponent(blobNameUUID)
    
    // MARK: Types
    
    // Struct: => key para codificar propiedades
    struct propertyKey {
        //static let idKey = "id"
        static let titleKey = "title"
        static let authorKey = "author"
        static let newsTextKey = "textKey"
        static let ratingKey = "rating"
        //        static let photoKey = "photo"
        static let dateActualKey = "date"
        static let latitudeKey = "latitude"
        static let longitudeKey = "longitude"
        static let stateKey = "state"
        static let resultkey = "result"
        static let amountVotesKey = "amountVotes"
        static let ratingTotalNewsKey = "ratingTotalNews"
    }
    
    
    // MARK:  Initialization
    init? (title : String, author : String, newstext : String, rating : Int,ratingTotalNews : Int,
        state : Bool, newDat : NSDate,result : Int, amountVotes : Int)
        //    , latitude : Double, longitude : Double)
    {
        
        // Inicilizando propiedades almacenadas
        //self.id = id
        self.title = title
        self.author = author
        self.newstext = newstext
        self.rating = rating
        // self.photo = photo
        self.state = state
        self.newDat = newDat
        self.result = result
        self.amountVotes = amountVotes
        self.ratingTotalNews = ratingTotalNews
        //        self.latitude = latitude
        //        self.longitude = longitude
        // Llamo al inicializador superclase
        super.init()
        
        // Inicializador fallable si se cumple:
        if title.isEmpty || author.isEmpty ||
            newstext.isEmpty || rating < 0 || newDat == ""
        {
            return nil
        }
    }
    
    // MARK: NScoding
    
    // Métodos Protocolos para codificar y descodificar la información guardada
    
    func encodeWithCoder(aCoder: NSCoder) {
        // encodeObject codifica cualquier tipo de objeto, codificando el valor
        // de cada propiedad de 'news'
        //aCoder.encodeObject(id, forKey: propertyKey.idKey)
        aCoder.encodeObject(title, forKey: propertyKey.titleKey)
        aCoder.encodeObject(author, forKey: propertyKey.authorKey)
        aCoder.encodeObject(newstext, forKey: propertyKey.newsTextKey)
        aCoder.encodeObject(rating, forKey: propertyKey.ratingKey)
        //        aCoder.encodeObject(photo, forKey: propertyKey.photoKey)
        aCoder.encodeObject(newDat, forKey: propertyKey.dateActualKey)
        aCoder.encodeObject(state, forKey: propertyKey.stateKey)
        aCoder.encodeObject(result, forKey: propertyKey.resultkey)
        aCoder.encodeObject(amountVotes, forKey: propertyKey.amountVotesKey)
        aCoder.encodeObject(ratingTotalNews, forKey: propertyKey.ratingTotalNewsKey)
        //        aCoder.encodeObject(latitude as? AnyObject, forKey: propertyKey.latitudeKey)
        //        aCoder.encodeObject(longitude as? AnyObject, forKey: propertyKey.longitudeKey)
    }
    
    // Inicializador  de conveniencia: ===> debe implementarse en las subclases
    // Sólo se aplicará cuando se vayan a guardar datos o cargar datos ==> (rw)
    required convenience init?(coder aDecoder: NSCoder) {
        // Como 'decodeObjectForKey' devuelve un 'AnyObject' lo casteo a 'String'
        //let id = aDecoder.decodeObjectForKey(propertyKey.idKey) as! String
        let title = aDecoder.decodeObjectForKey(propertyKey.titleKey) as! String
        let author = aDecoder.decodeObjectForKey(propertyKey.authorKey) as! String
        let newstext = aDecoder.decodeObjectForKey(propertyKey.newsTextKey) as! String
        let rating = aDecoder.decodeObjectForKey(propertyKey.ratingKey) as! Int
        //        let photo = aDecoder.decodeObjectForKey(propertyKey.photoKey) as? UIImage
        let newDat = aDecoder.decodeObjectForKey(propertyKey.dateActualKey) as! NSDate
        let state = aDecoder.decodeObjectForKey(propertyKey.stateKey) as! Bool
        let result = aDecoder.decodeObjectForKey(propertyKey.resultkey) as! Int
        let amountVotes = aDecoder.decodeObjectForKey(propertyKey.amountVotesKey) as! Int
        let ratingTotalNews = aDecoder.decodeObjectForKey(propertyKey.ratingTotalNewsKey) as! Int
        //        let latitude = aDecoder.decodeObjectForKey(propertyKey.latitudeKey) as! Double
        //        let longitude = aDecoder.decodeObjectForKey(propertyKey.longitudeKey) as! Double
        
        // Llammo al incializador designado
        self.init(title: title, author: author, newstext: newstext, rating: rating,
            ratingTotalNews : ratingTotalNews, state : state, newDat : newDat,
            result : result, amountVotes : amountVotes)
        //        , latitude : latitude, longitude : longitude)
        
    }
}

















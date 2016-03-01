//
//  News.swift
//  ScoopsReader
//
//  Created by MacBook Pro on 1/3/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

import UIKit

class News {
    
    // MARK: Properties
    
    var title : String
    var author : String
    var newsText : String
    var photo : UIImage?
    var state :  Bool = false
    var rating : Int
    var location : (longitude : Double, latitude : Double)?
    
    // Enumeración de coordenadas ===> 'latitude' y 'longitude'
    enum coordinatesEnum {
        case longitude, latitude
    }

    // MARK:  Initialization
    init? (title : String, author : String, newsText : String, rating : Int, photo : UIImage?) {
        
        // Inicilizando propiedades almacenadas
        self.title = title
        self.author = author
        self.newsText = newsText
        self.rating = rating
        self.photo = photo
        
        // Inicializador fallable si se cumple:
        if title.isEmpty || author.isEmpty || newsText.isEmpty || rating < 0 {
            return nil
        }
    }
    
    // Estructura con el conjunto de valores de 
    // las coordenadas: 'longitude', 'latitude'
    struct location {
        var coordinates : Set<coordinatesEnum>
    }
    
    // Inicializando  variable  con coordenadas
    var initCoordinates = location(coordinates: [.longitude, .latitude])
    
}

//
//  News.swift
//  ScoopsReader
//
//  Created by MacBook Pro on 1/3/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

import UIKit

class news {
    
    // MARK: Properties
    
    var title : String
    var author : String
    var newsText : String
    var photo : UIImage?
    var state :  Bool = false
    var location : (longitude : Double, latitude : Double)?
    
    // Enumeración de coordenadas ===> 'latitude' y 'longitude'
    enum coordinatesEnum {
        case longitude, latitude
    }

    // MARK:  Initialization
    init (title : String, author : String, newsText : String, photo : UIImage) {
        
        // Inicilizando propiedades almacenadas
        self.title = title
        self.author = author
        self.newsText = newsText
        self.photo = photo
    }
    
    // Estructura con el conjunto de valores de 
    // las coordenadas: 'longitude', 'latitude'
    
    struct location {
        var coordinates : Set<coordinatesEnum>
    }
    
    // Inicializando  variable  con coordenadas
    var initCoordinates = location(coordinates: [.longitude, .latitude])
    
}

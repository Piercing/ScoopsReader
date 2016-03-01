//
//  ScoopsReaderTests.swift
//  ScoopsReaderTests
//
//  Created by MacBook Pro on 27/2/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

import XCTest
@testable import ScoopsReader

class ScoopsReaderTests: XCTestCase {
    
    
    // MARK; Test para News
    
    // Test  para  confirmar que el 'init' de 'News' puede  fallar
    // cuando no se le pasa al 'init' los parámetros no opcionales
    // o se le pasan  valores nulos a alguno de sus parámetros Int.
    func testNewsInitialization () {
        
        // Caso de éxito, parámetros correctos - Ok.
        // Espero que el test no falle,  todos sus campos son correctos, probando así,
        // que el 'init' no puede tener campos vacios o nulos en todos sus parámetros
        let potentialItem = News(title: "Primera noticia, título no puede ser nulo", author: "Yo mismo",
            newsText: "Ponga usted mismo el texto que quiera para describir la noticia 1",
            rating: 5, photo: nil)
        XCTAssertNotNil(potentialItem)
        
        // Caso de fallo, parámetro author vacio - OK.
        // Espero que el test falle, ya que el título está vacio, probando así, que el init
        // puede  fallar debido a la condición de  que el title no puede ser un campo vacio.
        let noAuthor = News(title: "Segunda noticia, author no puede ser nulo", author: "",
            newsText: "Ponga usted mismo el texto que quiera para describir la noticia 2",
            rating: 5, photo: nil)
        XCTAssertNil(noAuthor, "Autor no válido, campo vacio")
        
        // Caso de fallo, parámetro title vacio - OK.
        // Espero que el test falle, ya que el título está vacio, probando así, que el init
        // puede  fallar debido a la condición de  que el title no puede ser un campo vacio.
        let noTitle = News(title: "", author: "Yo mismo",
            newsText: "Ponga usted mismo el texto que quiera para describir la noticia 3",
            rating: 5, photo: nil)
        XCTAssertNil(noTitle, "Título no válido, campo vacio")
        
        // Caso de fallo, parámetro newsText vacio - OK.
        // Espero que el test falle, ya que el título está vacio, probando así, que el init
        // puede  fallar debido a la condición de  que el title no puede ser un campo vacio.
        let nonewsText = News(title: "Ponga usted mismo el texto que quiera para describir la noticia 4", author: "Yo mismo",
            newsText: "",
            rating: 5, photo: nil)
        XCTAssertNil(nonewsText, "Texto noticias no válido, campo vacio")
        
        // Caso de fallo, Rating  valor negativo - Ok.
        // Espero que el test falle, ya que el rating es negativo, probando así, que el init
        // puede fallar debido a la  condición de que el rating  no puede ser menor que cero
        let badRating = News(title: "Quinta noticia, el rating no puede ser negativo", author: "Yo mismo",
            newsText: "Ponga usted mismo el texto que quiera para describir la noticia 5",
            rating: -5, photo: nil)
        XCTAssertNil(badRating)
    }
}

//
//  RatingControl.swift
//  ScoopsReader
//
//  Created by MacBook Pro on 28/2/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

import UIKit

/// Clase de tipo UIView para la valoración ==> 'rating' de noticas
class RatingControl: UIView {
    
    // MARK: Properties
    var rating = 0
    var ratingButtons = [UIButton]()
    
    
    // MARK: Initialization
    
    // Inicalizador para definir 'StoryBoards'. Se puede inicializar
    // mediante  'frame', si  trabajamos con 'frames', en  este caso
    // voy a trabajar con 'StoryBoards' por lo tanto, uso 'aDecorder'
    // Cada subclase de 'UIview' que implementa un incializador debe
    required init?(coder aDecoder: NSCoder) {
        
        // LLamo  al incializador de la supreclase  == > 'super.init'
        super.init(coder: aDecoder)
        
        // Bucle para crear-añadir los cinco botones  para el rating
        for _ in 0..<5 {
            
            // Añado un botón a la UIView que contendrá la imagen 'rating'
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            button.backgroundColor = UIColor.redColor()
            // Añado la acción 'TouchDown' cada vez que el botón se pulse
            // Mediante este target no es necesario definir un 'IBAction'
            button.addTarget(self, action: "ratingButtonTapped:", forControlEvents: .TouchDown)
            
            // Añado los botones  en cada ciclo del bucle a 'ratinButtons'
            ratingButtons += [button]
            
            // Añado el botón a la subvista para mostar la imagen 'rating'
            addSubview(button)
        }
    }
    
    // MARK: Initialization
    // Método que  llamado en  el momento adecuado por el sistema para
    // poder realizar un diseño preciso a la 'UIView 'de sus subvistas
    override func layoutSubviews() {
        
        var buttonFrame = CGRect(x: 0, y: 0, width: 44, height: 44)
        
        // Obtengo la  posición de  cada botón a partir de su longitud
        // Recorro el  array 'ratingButtons'  enumerados por su índice
        // enumerate() devuelve una colección que contiene los element
        // ==> colección  de tuplas agrupadas por valores, que en éste
        // caso cada tupla contiene un índice y un botón de la colecci
        // Para cada tupla de la colección, el bucle une a los valores
        // del índice y el botón a variables locales:'index' y 'button'
        // Utiliza el índice para calcular la nueva ubicación de buton
        // La ubicación inicial se fija  al tamaño  del botón estándar
        // de 44 puntos y 5puntos de de padding multiplicado por index
        for(index, button) in ratingButtons.enumerate(){
            // Cojo el primero con índice '0', por tanto se situa 'x=0'
            // El siguiente,  con índice '1',  se situará en ==> 'x=49'
            // y así hasta el quinto botón que será el de la posicón 4
            buttonFrame.origin.x = CGFloat(index * (44 + 5))
            // Asigno donde  situar cada botón en el valor 'posición X'
            button.frame = buttonFrame
        }
        
    }
    
    // Es necesario decirle a la vista  el tamaño  del botón, para eso
    // sobreescribo el método 'intrinsicContentSize' para que coincida
    // con el tamaño especificado anterirmente en la Interface Builder
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: 240, height: 44)
    }
    
    // MARK: Button Action
    func ratingButtonTapped(button: UIButton) {
        print("Button pressed 😎👍")
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
}

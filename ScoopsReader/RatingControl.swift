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
    
    var totalRating : News?
    var save : NewsAuthorTableViewController?
    //var save : NewsAuthorTableViewController?
    
    // MARK: Properties
    
    // Observo a los  cambios  de 'rating', que será llamado después
    // de que la propiedad cambie, es decir, cuando se haya cambiado
    // el valor de ==>'rating'. A continuación  incluyo la llamada a 
    // 'setNeedsLayout()', que actualiza el diseño cada vez que haya
    // un cambio en el valor de 'rating', asegurando que la interfaz
    // siempre  estará mostrando un valor exacto en el valor 'rating'
    var rating = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var ratingButtons = [UIButton]()
    var spacing = 5
    var stars = 5
    // Resultado 1/2votaciones
    var result = 0
    // Cantidad de votos users
    var amountVotes = 0
    // Total rating  acumulado
    var ratingTotalNews = 0
    
    
    // MARK: Initialization
    
    // Inicalizador para definir 'StoryBoards'. Se puede inicializar
    // mediante  'frame', si  trabajamos con 'frames', en  este caso
    // voy a trabajar con 'StoryBoards' por lo tanto, uso 'aDecorder'
    // Cada subclase de 'UIview' que implementa un incializador debe:
    required init?(coder aDecoder: NSCoder) {
        
        // LLamo  al incializador de la supreclase  == > 'super.init'
        super.init(coder: aDecoder)
        
        // Imágenes estrellas  para la configuración  de los botones
        let filledStarImage = UIImage(named: "filledStar")
        let emptyStarImage = UIImage(named: "emptyStar")
        
        // Bucle para crear-añadir los cinco botones  para el rating
        for _ in 0..<stars {
            
            // Añado un botón a la UIView que contendrá la imagen 'rating'
            let button = UIButton()
            
            // Inicalizado el botón le asigno, según el estado, la imagen
            button.setImage(emptyStarImage, forState: .Normal)
            button.setImage(filledStarImage, forState: .Selected)
            // Estado en el que el botón está seleccionado y resaltado,es
            // decir, cuando el usuario está en proceso de tocar el botón
            button.setImage(filledStarImage, forState: [.Highlighted, .Selected])
            
            // Para asegurarme de que la imagen no muestre alguna caract.
            // adicional  durante  el cambio  de  estado, al ser pulsada.
            button.adjustsImageWhenHighlighted = false
            
            // Añado la acción 'TouchDown'cada vez que el botón se pulse
            // Mediante este target no es necesario definir un 'IBAction'
            // La acción que desencadenará el botón: 'ratingButtonTapped'
            button.addTarget(self, action: "ratingButtonTapped:",
                forControlEvents: .TouchDown)
            
            // Añado los botones  en cada ciclo del bucle a 'ratinButtons'
            ratingButtons += [button]
            
            // Añado el botón a la subvista para mostar la imagen 'rating'
            addSubview(button)
            // NOTA: este botón se creará en base a lo definido dentro del
            // método que llama el sistema para diseñar sus subvistas, que
            // es el que he sobreescrito  más abajo ===> 'layoutSubviews()'
        }
    }
    
    // MARK: Initialization
    
    // Método que se llama en  el momento adecuado por el sistema para
    // que la 'UIView' puedad realizar diseño preciso de sus subvistas
    override func layoutSubviews() {
        
        // Obteniendo el alto, para establecer botones de tipo 'square'
        let buttonSize = Int (frame.size.height)
        
        // Creo el botón desde el origen y con alto y ancho 'buttonSize'
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        
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
            // que  tendrá un ancho y un alto definido por 'buttonSize'
            // El siguiente,  con índice '1',  se situará en ==> 'x=49'
            // y así hasta el quinto botón que será el de la posicón 4
            buttonFrame.origin.x = CGFloat(index * (buttonSize + spacing))
            // Asigno donde  situar cada botón en el valor 'posición X'
            button.frame = buttonFrame
        }
        
        // Actualizo el estado de los botones(stars) rellenas o vacias
        // Hay que actualizarlas también  cuando  la vista sea cargada
        // y no solamente cuando se actualiza si hay cambios de rating
        updateButtonSelectionStates()
    }
    
    // Es necesario decirle a la vista  el tamaño  del botón, para eso
    // sobreescribo el método 'intrinsicContentSize' para que coincida
    // con el tamaño especificado anterirmente en la Interface Builder
    override func intrinsicContentSize() -> CGSize {
        
        // Obtengo altura del botón para acutalizar 'intrinsic content'
        // para  que la 'UIView' pueda  diseñar correctamente el botón
        let buttonSize = Int (frame.size.height)
        // Le indico a la ==> 'UIView' que  su ancho total va a ser el:
        // 'ancho un botón + el padding del botón * el nº de estrellas'
        let width = (buttonSize + spacing) * stars
        // Devuelvo el tamaño que tendra el contenedor de la =>'UIview'
        return CGSize(width: width, height: buttonSize)
    }
    
    // MARK: Button Action
    func ratingButtonTapped(button: UIButton) {
        // Busco el botón que me pasan como parámetro, que es el botón
        // seleccionado en el array que los contiene ==>'ratingButtons'
        // devolviendo el índice en el que se encuentra el botón selec
        // Desempaqueto seguro: sé  que en el array están los 'buttons'
        // Para obtener la  calificación correspondiente añado un '+ 1'
        // ya que los  arrays comienzan en su primera posición en cero.
        // Es decir, si  se pulsa la segunda  estrella, según el array,
        // tendrá la posción 1 y  ratíng tendría una calificación de 1
        // cosa que no es cierta, ya que es dos, de ahí que le sume +1
        rating = ratingButtons.indexOf(button)! + 1
        
        // TODO: implementar votación media de una noticia por usuarios
        
        let total = self.totalVoteOfTheNewsByUsers(rating)
        totalRating?.totalRating  = total
        
        // Actulaizo el estado de los botones, stars rellenas o vacias
        updateButtonSelectionStates()
        
        print("Button pressed 😎👍")
        print("Cantidad de usuarios que han votado:  \(amountVotes)")
        print("Valoración total usuarios: \(ratingTotalNews)")
        print("Valoración media usuarios: \(total)")
        
        
    }
    
    // MARK: Utils

    /// Método de ayuda que  acutalizar estado de los botones 'selected'
    func updateButtonSelectionStates() {
        
        // Itero  a través de 'ratingButtons' para establecer el estado
        // de cada botón  en función de  que su index sea < que  rating.
        for(index, button) in ratingButtons.enumerate() {
            
            // Si el índice del botón seleccionado es < que el 'rating'?
            // Si es así, se evalua la expresión con true, estableciendo
            // el estado  del botón  a seleccionado, haciendo visible la
            // imagen de la estrella rellena. De lo contrario, el  botón
            // no estará seleccionado mostrando la imagen estrella vacia
            // Decir que si se  selecciona  un botón del array,  siempre
            // será  menor que el rating, por lo que  simpre se cumplirá
            // Por tanto, cuando no se seleccione éste se mostrará vacia
            button.selected = index < rating
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    // MARK: Utils
    /// Calcula el rating medio de los usuarios que han votado una noticia
    func totalVoteOfTheNewsByUsers(valueRating :Int)-> Int{

        switch(valueRating){
            
        case 1: self.ratingTotalNews += 1
            self.amountVotes++
            break
        case 2: self.ratingTotalNews += 2
        self.amountVotes++
            break
        case 3: self.ratingTotalNews += 3
        self.amountVotes++
            break
        case 4: self.ratingTotalNews += 4
        self.amountVotes++
            break
        case 5: self.ratingTotalNews += 5
        self.amountVotes++
            break
        default: ()
        }
        
        result = (self.ratingTotalNews / self.amountVotes) 
        self.totalRating?.totalRating = self.result
        self.totalRating?.amountVotes = self.amountVotes
        //self.totalRating?.ratingTotalNews = self.ratingTotalNews
        
        // Añado al modelo los valores de las votaciones
        self.totalRating?.amountVotes = self.amountVotes
        //self.totalRating?.ratingTotalNews = self.ratingTotalNews
        self.totalRating?.result = self.result
        
        self.save?.saveNews()
        
        return result
    }
    
}














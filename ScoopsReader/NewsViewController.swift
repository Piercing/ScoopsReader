//
//  NewsViewController.swift
//  ScoopsReader
//
//  Created by MacBook Pro on 27/2/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, UITextFieldDelegate,
UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate{
    
    
    // MARK: - Properties
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var newsText: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Valor que puede ser pasado mediante 'prepareForsegue'
    var news : News?
    
    // var reset : RatingControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 'ViewController' delegado => 'textField' 'UITextView'
        titleTextField.delegate = self
        authorTextField.delegate = self
        newsText.delegate = self
        
        // Establecer  cada una de las vistas en 'NewsViewController'
        // para  mostrar los  datos de las  propiedades de una 'news'
        // si 'news' no es 'nil', que sucede cuando la news se edita
        if let news = self.news {
            navigationItem.title = news.title
            titleTextField.text  = news.title
            authorTextField.text = news.author
            photoImageView.image = news.photo
            ratingControl.rating = news.rating
            newsText.text = news.newsText
        }
        
        // Habilito el botón 'Save' sólo si los campos de texto
        // contienen valores válidos para las propiedades 'news'
        checkValidNewsName()
        
    }
    override func viewWillAppear(animated: Bool) {
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        // Color  para el título 'navigationItem'
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orangeColor()]
        
        // Color de fondo  para el 'navigationBar'
        UINavigationBar.appearance().barTintColor = UIColor.blackColor()
    }
    
    // MARK: Navigation
    
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        
        // Dependiendo del estilo de presentación ('modal' o 'push') el
        // viewController se puede  cancelar de  dos  maneras distintas
        
        // Valor booleano para comprobar si la escena es 'NavigationCtr'
        // Compruebo si la escena ha sido presentada con el botón =>'+'
        let isPresentingInAddNewsMode = presentingViewController is UINavigationController
        
        // Ahora sólo se cancela la entrada de información si se cumple
        if isPresentingInAddNewsMode {
            
            // Cancelar la  nueva  entrada  sin  almacenar  información
            dismissViewControllerAnimated(true, completion: nil)
            
        }else{
            // Se  ejecuta cuando la  noticia  se  inserta en la pila de
            // navegación de la parte superior de la escena  tabla 'news'
            // Con este método aparece el controlador de la vista actual
            // (news) de la pila de navegación  de 'navigationController'
            // Es decir, si se cancela cuando se ha pulsado una celda de
            // la tabla y no el botón de añadir, este método devuelve la
            // la  tabla de  nuevo sin mostrar  ningún  cambio realizado
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    // Método para configurar un viewController antes de ser presentado.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // 'identity operator' === compruebo que el objeto referenciado
        // de salida => 'saveButton' es la misma instancia que 'sender'
        if saveButton === sender {
            
            // 'Coalescencing operator' => devuelve un valor si lo tiene
            // y si éste no lo tiene, devuelve un valor por defecto ("")
            // En este caso si tuviera un nil, devolvería texto vacio ""
            let title = titleTextField.text ?? ""
            let author = authorTextField.text ?? ""
            let photo = photoImageView.image
            let rating = ratingControl.rating
            let newsTxt = newsText.text ?? ""
            let newDat = NSDate()
            let state = false
            //let latitude =
            //let longitude =
            
            // Estableciendo  valores de la 'news' para ser pasados al
            // =====>  'NewsTableViewController' a  través  del  segue
            news = News(title: title, author: author, newsText: newsTxt,
                rating: rating, photo: photo, state: state, newDat : newDat)
        }
    }
    
    // MARK: - Actions (Target-Action)
    
    //    @IBAction func resetRating(sender: UIButton) {
    //
    //        for (index, button) in (reset?.ratingButtons.enumerate())! {
    //
    //            switch (index){
    //
    //            case 0...4: button.setImage(reset?.emptyStarImage, forState: .Normal)
    //            reset?.rating = 0
    //                break
    //            default: ()
    //            }
    //            // Para asegurarme de que la imagen no muestre alguna caract.
    //            // adicional  durante  el cambio  de  estado, al ser pulsada.
    //            reset!.button.adjustsImageWhenHighlighted = false
    //        }
    //    }
    
    
    
    @IBAction func selectImageFromPhotLibrary(sender: UITapGestureRecognizer) {
        
        // Inicio el 'activityIndicator'  cuando el usuario va  acceder carrete
        self.activityIndicator.startAnimating()
        
        // Usuario  toca la 'imageView' mientras escribe, el teclado desaparece
        self.titleTextField.resignFirstResponder()
        
        // Utilizo una cola del sistema, donde se obtiene la foto en segundo plano
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            // Creo 'imagePickerController' para  que el usuario acceda al carrete
            let imagePickerController = UIImagePickerController()
            
            // Acceso solamente a 'photLibrary' del usuario, no acceso a la camara
            imagePickerController.sourceType = .PhotoLibrary
            
            // Paro  el 'activity Indicator' en la cola principal una vez accedido
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                // Recibo las notificaciones cuando usuario escoge imagen => 'Delegate'
                imagePickerController.delegate = self
                
                // Presento  el 'viewController' definido  por  'imagePickerController'
                self.presentViewController(imagePickerController, animated: true, completion: nil)

                // Detengo el 'activityIndicator' cuando el usuario ya accedió carrete
                self.activityIndicator.stopAnimating()
            })
        }
        
        
    }
    
    // MARK: - UITextViewDelegate - Métodos del protocolo delegado opcionales
    
    // Método  que se llama al usuario pulsar en  el teclado 'return' => 'Done'
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange,
        replacementText text: String) -> Bool {
            
            if text == "\n" {
                textView.resignFirstResponder()
                return false
            }
            return true
    }
    
    // MARK: - UITextFieldDelegate - Métodos del protocolo delegado opcionales
    
    // Método  que se llama al usuario pulsar en  el teclado 'return' => 'Done'
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        // El campo de texto debe responder a la pulsación de la tecla =>'Done'
        return true
    }
    
    // Método que  es llamado  después de  que  el usuario  renuncie al teclado
    // dando la opción de poder  leer el texto introducido y hacer  algo con él
    func textFieldDidEndEditing(textField: UITextField) {
        
        // LLamo al método '' para comporbar si hay texto en los campos de texto
        checkValidNewsName()
        // Establezco el título de la escena al texto del título que le da autor
        navigationItem.title = titleTextField.text
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        // Deshabilto  el botón 'Save' durante  la edición de los campos de texto
        // Se llama cuando se inicia algún tipo de edición o se visualiza teclado
        // Se desactiva 'Save' cuando el usuario está  editando en campo de texto
        saveButton.enabled = false
    }
    
    
    /// Deshabilita botón 'Save' si algún campo de texto  está vacio o no se edita
    func checkValidNewsName() {
        
        // Deshabilito el botón 'Save' si alguno de los campos de texto está vacio
        let textTitle = titleTextField.text ?? ""
        let textAuthor = authorTextField.text ?? ""
        let textTxt = newsText.text ?? ""
        
        saveButton.enabled = !textTitle.isEmpty
        saveButton.enabled = !textAuthor.isEmpty
        saveButton.enabled = !textTxt.isEmpty
        
    }
    
    // MARK: - UIImagePickerControllerDelegate - Métodos del  protocolo delegado
    
    // Método que se llama cuando el usuario pulsa el botón Cancelar de imágenes
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        // Cierro  el selector de imágenes  si el  usuario pulsa  botón cancelar
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Método qu se llama cuando usuario selecciona una foto pudiendo modificarla
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            
            // El diccionario que recibo contiene múltiples representaciones de image
            // utilizo la imagen  original ===> 'UIImagePickerControllerOriginalImage'
            let selectImage = info [UIImagePickerControllerOriginalImage] as! UIImage
            
            // Establezco como 'photoImage' la 'selectImage' seleccionada y la muestro
            photoImageView.image = selectImage
            
            // Cierro  el selector de imágenes de forma animada y bloque final ==> nil
            dismissViewControllerAnimated(true, completion: nil)
            
    }
}




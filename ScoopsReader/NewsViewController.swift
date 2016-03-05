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
    //@IBOutlet weak var placeholderLabel : UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // Valor que puede ser pasado mediante 'prepareForsegue'
    var news : News?
    
    // var reset : RatingControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        // 'ViewController' delegado: 'textField' 'UITextView'
        titleTextField.delegate = self
        authorTextField.delegate = self
        newsText.delegate = self
        
        // Habilito el botón 'Save' sólo si los campos de texto
        // contienen valores válidos para las propiedades 'news'
        checkValidNewsName()
        
    }
    
    // MARK: Navigation
    
    @IBAction func cancelButton(sender: AnyObject) {
        // Cancelar la nueva entrada  sin almacenar ninguna información
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Método para configurar un viewController antes de ser presentado.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // 'identity operator' ==> compruebo que el objeto referenciado
        // de salida => 'saveButton' es la misma instancia que 'sender'
        if saveButton === sender {
            
            // 'Coalescencing operator' => devuelve un valor si lo tiene
            // y si éste no lo tiene, devuelve un valor por defecto ("")
            // En este caso si al desempaquetar tuviera un nil, devolver
            // texto vacio ""
            let title = titleTextField.text ?? ""
            let author = authorTextField.text ?? ""
            let photo = photoImageView.image
            let rating = ratingControl.rating
            let newsTxt = newsText.text ?? ""
            //let newsTxt = "Prueba, no implementado aún"
            
            // Estableciendo  valores de la 'news' para ser pasados al
            // =====>  'NewsTableViewController' a  través  del  segue
            news = News(title: title, author: author, newsText: newsTxt, rating: rating, photo: photo)
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
        
        // Usuario  toca la 'imageView' mientras escribe el teclado desaparece
        titleTextField.resignFirstResponder()
        
        // Creo 'imagePickerController' para  que el usuario acceda al carrete
        let imagePickerController = UIImagePickerController()
        
        // Acceso solamente a 'photLibrary' del usuario, no acceso a la camara
        imagePickerController.sourceType = .PhotoLibrary
        
        // Recibo las notificaciones cuando usuario escoge imagen => 'Delegate'
        imagePickerController.delegate = self
        
        // Presento  el 'viewController' definido  por  'imagePickerController'
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: - UITextViewDelegate - Métodos del protocolo delegado opcionales
    
    // Método  que se llama al usuario pulsar en  el teclado 'return' => 'Done'
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
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
        
        //@IBOutlet weak var newsTitleLabel : UILabel!
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
    
    // MARK: Delegate textView
//    func textViewDidChange(textView: UITextView) {
//        // Oculto la  etiqueta  cuando  hay  texto
//        placeholderLabel.hidden = !textView.text.isEmpty
//    }
    
    // MARK: Utils
//    func settingsNewsText(){
//        // Establezco propiedades para el textView
//        //newsText.delegate = self
//        placeholderLabel = UILabel()
//        placeholderLabel.text = "Enter the text of the news here..."
//        placeholderLabel.font = UIFont.italicSystemFontOfSize(newsText.font!.pointSize)
//        placeholderLabel.sizeToFit()
//        newsText.addSubview(placeholderLabel)
//        placeholderLabel.frame.origin = CGPointMake(5, newsText.font!.pointSize / 2)
//        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
//        placeholderLabel.hidden = !newsText.text.isEmpty
//    }
}
















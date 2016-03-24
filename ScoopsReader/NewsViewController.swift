
//
//  NewsViewController.swift
//  ScoopsReader
//
//  Created by MacBook Pro on 27/2/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

import UIKit
import MobileCoreServices

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
    @IBOutlet weak var numberValoration: UILabel!
    @IBOutlet weak var numberVotes: UILabel!
    @IBOutlet weak var saveInAzure: UIButton!
    @IBOutlet weak var stateNewsSwitch: UISwitch!
    
    // Valor para pasar por 'prepareForsegue'
    var news : News?
    
    let imageAsset = UIImage(named: "defaultPhoto")
    // Propiedad almacenada para almacenar NSdate photo
    var bufferPhoto : NSData?
    //        {
    //
    //        get {
    //            let defaultPhoto = UIImagePNGRepresentation(imageAsset!)
    //            return defaultPhoto
    //        }
    //        set (newImage) {
    //
    //            self.bufferPhoto = newImage
    //        }
    //    }
    // Propiedad para almacenar  nombre blob
    var blobName : String  = "Sin nombre"
    // Propiedad para  acceder a propiedades
    var values : RatingControl?
    // Propiedad cliente, referencia a 'AMS'
    var client : MSClient = MSClient(applicationURL: NSURL(
        string: "https://scoopsdailay.azure-mobile.net/"),
        applicationKey: "SFfIMXQedqiHrvQJXiIuVKIomiMign98")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Añado a la  Bar Navigation el botón de  save y photo
        let plusButton = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "capturePhotos:")
        self.navigationItem.setRightBarButtonItems([self.saveButton ,plusButton], animated: true)
        plusButton.tintColor = UIColor.orangeColor()
        
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
            //photoImageView.image = news.photo
            ratingControl.rating = news.result
            numberVotes.text = news.amountVotes.description
            numberValoration.text = news.result.description
            newsText.text = news.newstext
            
        }
        
        // Habilito el botón 'Save' sólo si los campos de texto
        // contienen valores válidos para las propiedades 'news'
        checkValidNewsName()
        
    }
    override func viewWillAppear(animated: Bool) {
        
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
    
    // Método para  configurar un viewController antes de ser presentado.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // 'identity operator' === compruebo que el objeto referenciado
        // de salida => 'saveButton' es la misma instancia que 'sender'
        if saveButton === sender {
            
            // 'Coalescencing operator' => devuelve un valor si lo tiene
            // y si éste no lo tiene, devuelve un valor por defecto ("")
            // En este caso si tuviera un nil, devolvería vacio "" ó '0'
            //let id = self.news?.id ?? ""
            let title = titleTextField.text ?? ""
            let author = authorTextField.text ?? ""
            //let photo = photoImageView.image
            let rating = ratingControl.rating ?? 0
            let newstext = newsText.text ?? ""
            let newDat = self.news?.newDat ?? NSDate()
            let state = self.news?.state ?? false
            let result = ratingControl.result ?? 0
            let amountVotes = ratingControl.amountVotes ?? 0
            let totalRatingNews = ratingControl.ratingTotalNews ?? 0
            //            let latitude = 1.45329
            //            let longitude = 1.45723
            
            // Estableciendo  valores de la 'news' para ser pasados al
            // =====>  'NewsTableViewController' a  través  del  segue
            news = News(title: title, author: author, newstext: newstext,rating: rating,ratingTotalNews : totalRatingNews,
                state: state, newDat : newDat,result: result, amountVotes: amountVotes)
            //            , latitude : latitude, longitude : longitude)
        }
    }
    
    // MARK: - Actions (Target-Action)
    @IBAction func stateNewsAction(sender: UISwitch) {
        
        if (sender == self.stateNewsSwitch.on){
            self.news?.state = true
            stateNewsSwitch.on = true
        }else{
            self.news?.state = false
            stateNewsSwitch.on = false
        }
        
    }
    
    @IBAction func saveAzureAction(sender: AnyObject) {
        
        if isUserLoged(){
            
            // Cargo los datos del usuario que ya logueo
            if let usrLogin = loadUserAuthInfo(){
                
                // Cojo el 'id'del usuario de su red social y la asigno al currentUser del client
                client.currentUser = MSUser(userId: usrLogin.usr)
                // Cojo el 'idToken' del usuario logueado y lo asigno al MServiceToken del client
                client.currentUser.mobileServiceAuthenticationToken = usrLogin.token
                
                // Usando el ==>'client' hacemos referencia a la tabla de los vídeos
                let tablePhotos = client.tableWithName("photos")
                
                // 1º: Guardamos las  fotos que queremos  persistir en Base de Datos
                tablePhotos?.insert([
                    "title" : titleTextField.text!, "author" : authorTextField.text!,"newtext": newsText.text,
                    "blobName": blobName, "containername" : "scoop"],
                    completion: { (inserted, error: NSError?) -> Void in
                        print("Hello Azure!!!👋👍😋 👋👍😋")
                        // Si hay error
                        if error != nil {
                            print("Houston, we have a problem to save  😱😵😱 => : \(error?.description)")
                        }
                        else {
                            // 2º: Persistimos ahora el 'blob' en el Storage de Azure
                            print("All right when saving Database Houston, now plays Blob 😎😎😎\n\n")
                            
                            if self.bufferPhoto == nil {
                                
                                let imageAsset = UIImage(named: "defaultPhoto")
                                let defaultPhoto = UIImagePNGRepresentation(imageAsset!)
                                self.bufferPhoto = defaultPhoto
                                
                                // Se supone que aquí la photo ya debe de estar capturada
                                self.uploadToStorage(self.bufferPhoto!, blobName: self.blobName)
                                
                            }else{
                                
                                // Se supone que aquí la photo ya debe de estar capturada
                                self.uploadToStorage(self.bufferPhoto!, blobName: self.blobName)
                            }
                        }
                })
            }
            
        }else{
            
            // No estamos logados, podemos forzar el login para que se loguee el usuario correcta/
            client.loginWithProvider("facebook", //  provider, facebook, twttier, google, etc, etc
                controller: self,// donde queremos que aparezca la  ventana modal de autenticarnos
                animated: true,
                completion: { (user: MSUser?, error: NSError?) -> Void in // user logueado y error
                    
                    if (error != nil){
                        print("Houston, we have a problem to log 😱😱")
                        
                    }else{
                        saveAuthInfo(user)
                    }
            })
        }
    }
    
    // Tap Capture Recognizer, al pulsar sobre 'no photo availble' accede a carrete
    @IBAction func selectImageFromPhotLibrary(sender: UITapGestureRecognizer) {
        
        // Inicio  el  'activityIndicator'  cuando el usuario va  acceder a carrete
        self.activityIndicator.startAnimating()
        
        // Usuario  toca   la 'imageView' mientras escribe, el  teclado  desaparece
        self.titleTextField.resignFirstResponder()
        
        // Utilizo una cola del sistema, donde se obtiene la foto en  segundo plano
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            // Creo 'imagePickerController' para  que el usuario acceda  al carrete
            let imagePickerController = UIImagePickerController()
            
            // Acceso solamente a 'photLibrary' del usuario, no acceso a  la camara
            imagePickerController.sourceType = .PhotoLibrary
            
            // Paro  el 'activity Indicator' en la cola principal una vez  accedido
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                // Recibo las notificaciones cuando usuario escoge imagen 'Delegate'
                imagePickerController.delegate = self
                
                // Presento el 'viewController' definido por 'imagePickerController'
                self.presentViewController(imagePickerController, animated: true, completion: nil)
                
                // Detengo 'activityIndicator' cuando el usuario ya accedió al carrete
                self.activityIndicator.stopAnimating()
            })
        }
    }
    
    // MARK: Methods for Capture Video/Photos
    
    /// Captura las photos realizados mediante la cámara de nuestro dispositvo
    func capturePhotos (sender : AnyObject){
        
        self.activityIndicator.startAnimating()
        
        // Utilizo una cola del sistema, donde se obtiene la foto en  segundo plano
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            self.startCapturePhotosBlogFromViewController(self, withDelegate: self)
        }
    }
    
    /// Captura  photos realizados  mediante  la cámara del  dispositivo usado
    func startCapturePhotosBlogFromViewController(viewcontroller: UIViewController,
        withDelegate delegate: protocol<UIImagePickerControllerDelegate,
        UINavigationControllerDelegate>) -> Bool {
            
            if (UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum) == false) {
                //                let alert = UIAlertAction(title: "Cámara no disponible", style: .plano, handler: { (UIAlertAction) -> Void in
                //                    <#code#>
                //                })
                return false
            }
            
            //            let cameraController = UIImagePickerController()
            //            cameraController.sourceType = .SavedPhotosAlbum
            //            cameraController.mediaTypes = [kUTTypeMovie as NSString as String]
            //            cameraController.allowsEditing = false
            //            cameraController.delegate = delegate
            //
            //            presentViewController(cameraController, animated: true, completion: nil)
            
            // Usuario  toca   la 'imageView' mientras escribe, el  teclado  desaparece
            self.titleTextField.resignFirstResponder()
            
            // Utilizo una cola del sistema, donde se obtiene la foto en  segundo plano
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                
                // Creo 'imagePickerController' para  que el usuario acceda  al carrete
                let imagePickerController = UIImagePickerController()
                
                // Acceso solamente a 'photLibrary' del usuario, no acceso a  la camara
                imagePickerController.sourceType = .PhotoLibrary
                
                // Paro  el 'activity Indicator' en la cola principal una vez  accedido
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    // Recibo las notificaciones cuando usuario escoge imagen 'Delegate'
                    imagePickerController.delegate = self
                    
                    // Presento el 'viewController' definido por 'imagePickerController'
                    self.presentViewController(imagePickerController, animated: true, completion: nil)
                    
                    self.activityIndicator.stopAnimating()
                })
            }
            return true
    }
    
    // MARK: Methods to save Videos & Upload Videos
    
    /// Path donde se guardarán las photos  grabadas en el dispositivo local/
    //    func savePhotosInDocuments (data: NSData) {
    //
    //        let existsFile = NSArray(contentsOfFile: News.archivePhotosURL.path!) as? [String]
    //
    //        if existsFile == nil {
    //
    //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
    //                // Intento guardar  el array de  'vídeos', si se  ha podido  guardar me devuelve 'true'
    //                // Le paso constante  estática creada en 'News' que es la ruta al archivo donde guardar
    //                let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self.news!, toFile: News.archivePhotosURL.path!)
    //
    //                // Guardo los datos de la foto y el  nombre que se le dará al blob que se sube a 'Azure'
    //                self.bufferPhoto = data
    //                self.blobName = News.blobNameUUID
    //
    //                // Compruebo por consola si se han guardado o no los objetos en ruta especificada (path)
    //                if !isSuccessfulSave {
    //                    print("Failed to save photos")
    //                }
    //            }
    //        }
    //    }
    
    /// Método para guardar localmente un NSData
    func saveInDocuments(data : NSData) {
        
        // Constante con la cual doy nombre con un 'UUIDString' ya creado y con la extensión 'jpg'
        let blobNameUUID = "/photo-\(NSUUID().UUIDString).jpg"
        
        // Obtenemos el 'path' del directorio donde voy  guardar y  ponerle un nombre  al fichero
        // El primer parámetro le paso el directorio del documento y el 2º el dominio del usuario
        // Como esto nos devuelve un array le decimos que nos devuelva el primer elemento => '[0]'
        // como una cadena. Con esto ya tengo el 'path' del directorio mi documents, de mi'Sanbox'
        let documents = NSSearchPathForDirectoriesInDomains(.DocumentationDirectory, .UserDomainMask, true)[0] as String
        
        // Ahora le agrego a documents  un nombre de fichero al vídeo  a guardar que he capturado
        // A este fichero le doy un nombre con un 'UUIDString' ya creado y con  la extensión 'mov'.
        let filePath = documents.stringByAppendingString(blobNameUUID) // le  añado la  extensión
        // Ya tenemos el nombre del fichero, pero el fichero  aún no existe, o creo que no existe.
        // Para ello compruebo con un 'if' si existe o no el fichero. Con 'contentsOfFile' obtngo
        // todas las coincidencias que encuentra en el'filePath' que le paso, metidas en un array
        let array = NSArray(contentsOfFile: filePath) as? [String]// si lo puede desempaquetar...
        // Pregunto si el array  está vacio, es decir, no ha encontrado coincidencias en el Path,
        // ya que si encuentra  coincidencias, es  que el fichero ya existe y se sobreescribiría.
        // Puedo preguntar si es nil, es un opcional, y compruebo si está a nil, para persistirlo
        // ya que, al comprobar  que no es nil, es  que no existe, por tanto  podemos persistirlo.
        if (array == nil) {
            // voy  a persistir  el fichero  localmente  y una vez haya guardado  lo subo a Azure.
            data.writeToFile(filePath, atomically: true)
            
            // Guardo los datos binarios de la foto y el nombre que se le dará al blob que subamos.
            bufferPhoto = data
            blobName = blobNameUUID
            // Para  subirlo  a  Azure, llamo  a  la  función que  he  creado ==> 'uploadToStorage'
            // pasándole el NSData => el vídeo y el nombre NSUUID ya  creado con la extensión'.JPG'
            //uploadToStorage(data, blobName: blobNameUUID)
        }
    }
    
    /// Sube los vídeos al Storage de Azure y los almacena
    func uploadToStorage(data: NSData, blobName: String) {
        
        // Invocamos la API 'urlsastoblobcontainer' para obtener una url para poder subir el 'blob'
        // Esta misma custom API, también nos va a servir para la operación inversa ===> descargar
        
        //********************* 1º **********************
        // Invocar la Api mediante el 'client'. Nuestra 'custom API'
        // la  hemos  llamado   =======>  'urlsastoblobandcontainer'
        // Aquí es donde se dispara nuestra custom API en 'Azure MS
        client.invokeAPI("urlsastoblobcontainer",
            body: nil,
            HTTPMethod: "GET",
            // como  parámetros  el nombre  del contenedor y del blob
            parameters: ["blobName" : self.blobName, "containerName" : "scoop" ],
            headers: nil,
            // El primer parámetro devuelve el diccionario con la URL
            // que hemos  generado para poder  subir un  blob a Azure
            // El segundo, es la  respuesta, por si queremos analizar
            // el tipo de respuesta como por ejemplo que nos devuelva
            // un '205' u  otra  respuesta  y por  último el 'NSError'
            completion: { (result : AnyObject?, response : NSHTTPURLResponse?, error : NSError?) -> Void in
                
                // Si no hay error
                if error == nil {
                    
                    // ********************* 2º ***********************
                    // es  que en el 'result' recibo un diccionario con
                    // una clave  que se llamará ==> 'sasURL' que tiene
                    // un valor, que es el  que a nosotros nos interesa
                    // Con esta sólo tenemos la ruta del container/blob
                    let sasURL = result!["sasURL"] as? String
                    
                    // ********************* 3º ***********************
                    // En  vez de  crear el  container  desde Azure, lo
                    // vamos  a  hacer  desde  aquí, partiendo  de esta
                    // 'sasURL'. Con esto tenemos la 'firma' de la URL,
                    // pero tenemos que poner también el recurso al que
                    // queremos acceder,tenemos que ponerle el endpoint
                    // Hay que poner el 'endpoint 'del 'Storage' no del
                    // Mobile Service.
                    var endPoint = "https://scoop.blob.core.windows.net"
                    
                    // Ya  tenemos  la 'sasURL' y el 'endPoint'. Lo que
                    // hacemos ahora es sumar las dos cadenas,  unirlas,
                    // para tener la URL completa y poder subir o bajar
                    // el recurso queremos acceder. En este caso  subir.
                    
                    // Sumamos  las cadenas == > 'endPoint'  y  'sasURl'
                    endPoint += sasURL!
                    
                    // ********************** 4º ***********************
                    //     APUNTANDO AL CONTAINER DE AZURE STORAGE
                    // Ya podemos hacer  referencia a nuestro  container
                    // para  poder  subir. Hasta ahora  usábamos el  que
                    // tenía el blobClient y ahora usaremos directamente
                    // una URL, que no es ni más ni menos  que 'endPoint'
                    let container = AZSCloudBlobContainer(url: NSURL(string: endPoint)!)
                    
                    // ********************** 5º ***********************
                    //           CREANDO NUESTRO BLOB LOCAL
                    // Como no me permite subir un fichero, sino un blob
                    // he de convertir el fichero a un tipo de dato blob
                    // Desde el container tomo la referencia del  nombre
                    // del  'blob', pasándole  el 'blobName' que  recibo
                    let blobLocal = container.blockBlobReferenceFromName(blobName)
                    
                    // ********************** 6º ***********************
                    // HACEMOS EL UPLOAD DE NUESTRO BLOB LOCAL *EL DATA*
                    //
                    blobLocal.uploadFromData(data, completionHandler: {
                        (error : NSError?) -> Void in
                        
                        // Aquí se supone  que  hemos controlado el éxito
                        // Recordar también, que tenemos un button, en el
                        // storyBoard del viewController, el cual  estaba
                        // desactivado para poder subir los datos a Azure
                        
                        // Si no hay error
                        if error == nil {
                            // Deshabilito el botón. Como las clase de AZS
                            // trabajan en 2º plano, tenemos que volver al
                            // hilo principale para poder llevarlo a  cabo
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                // Deshabilito el botón para subida  Azure
                                self.saveButton.enabled = false
                                self.saveInAzure.enabled = false
                                print("Houston, upload to Storage Azure 👍!!!")
                            })
                        }
                        
                        // NOTA: CON ESTO HEMOS  TERMINADO TODO EL PROCESO DE
                        // ASOCIAR EL ELEMENTO EN UNA TABLA DE MOBILE SERVICE
                        // Y  DE  SUBIR  EL  'BLOB'  AL  STORAGE   DE  'AZURE'
                    })
                }else{
                    print("Server response: \(response?.description) \n\n")
                    print("error:  \(error?.description)")
                }
        })
    }
    
    // Asigna los valores en vista Detail valoración y votos
    func textField(textField: UITextField,
        shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool {
            
            // Asigno valoración
            numberValoration.text = NewsAuthorTableViewController.resultViewDetail.description
            numberValoration.textColor = UIColor.orangeColor()
            // Asigno total votos
            numberVotes.text = NewsAuthorTableViewController.amountForViewDetail.description
            numberVotes.textColor = UIColor.orangeColor()
            
            return true
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
        saveInAzure.enabled = false
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
        
        saveInAzure.enabled = !textTitle.isEmpty
        saveInAzure.enabled = !textAuthor.isEmpty
        saveInAzure.enabled = !textTxt.isEmpty
        
    }
    
    // MARK: - UIImagePickerControllerDelegate - Métodos del  protocolo delegado
    
    // Método que se llama cuando el usuario pulsa el botón Cancelar de imágenes
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        // Cierro  el selector de imágenes  si el  usuario pulsa  botón cancelar
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Método q se llama cuando usuario selecciona una foto pudiendo modificarla
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            
            // El diccionario que recibo contiene múltiples representaciones de image
            // utilizo la imagen  original ===> 'UIImagePickerControllerOriginalImage'
            let selectImage = info [UIImagePickerControllerOriginalImage] as! UIImage
            
            // Establezco como 'photoImage' la 'selectImage' seleccionada y la muestro
            photoImageView.image = selectImage
            
            // Obtengo el NSData de la imagen seleccionada
            let imageData = UIImageJPEGRepresentation(selectImage, 0.9)
            
            // Recojo  lo  que  he recibido, el parámetro 'info' tiene  una key que se
            // va  a poder  tener acceso a  lo que hemos capturado, lo casteo a cadena
            let mediaType = info[UIImagePickerControllerMediaType] as! String
            
            // Cierro  el selector de imágenes de forma animada y bloque final ==> nil
            dismissViewControllerAnimated(true, completion: nil)
            
            // Comprobamos  que  hemos  capturado, si  es  una photo ==> 'kUTTypePhoto'
            if(mediaType == kUTTypeImage as String){
                
                // Obtengo de la clave 'info', preguntando donde está almacenada tempo/
                // la photo que acabamos de capturar, obteniendo el 'path'(casteo a URL)
                //let path = (info[UIImagePickerControllerMediaURL] as? NSURL)
                
                // Guarda la imagen en Documets
                saveInDocuments(imageData!)
                
                // Éste método se invoca desde la extensión del UIImagePickerContr
                //UISaveVideoAtPathToSavedPhotosAlbum((path?.absoluteString)!, self, "photo:didFinishSavingWithError:contextInfo:", nil)
                
            }
    }
}




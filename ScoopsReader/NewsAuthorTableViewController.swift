//
//  NewsAuthorTableViewController.swift
//  ScoopsReader
//
//  Created by MacBook Pro on 4/3/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

import UIKit

class NewsAuthorTableViewController: UITableViewController {
    
    // Creo cuenta para AZS
    // DefaultEndpointsProtocol=https;AccountName=scoopes;AccountKey=
    // x90MSepEOi1TMwFnhft+iBtxVCWeA9JIoC6FlLZxhPNEjHT04Y6/kup4/XvuabeBMc0pYEtzfZf2KaqGK1rVOw==
    // let account = AZSCloudStorageAccount(fromConnectionString: "")
    
    // MARK: Properties
    // Propiedad cliente, referencia a 'Mob.Servic'
    var client : MSClient = MSClient(applicationURL: NSURL(
        string: "https://scoopsdailay.azure-mobile.net/"),
        applicationKey: "SFfIMXQedqiHrvQJXiIuVKIomiMign98")
    
    // Modelo de objetos que recibimos de Mob.Serv
    var model : [AnyObject]?
    var records = [NSDictionary]()
    var news = [News]()
    var result : RatingControl?
    var activityIndicator : NewsViewController?
    
    // Valores para asignarlos en la vista detalle
    static var ratingTotalNewsForViewDetail = 0
    static var amountForViewDetail = 0
    static var resultViewDetail = 0
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Botón editar para la vista de la tabla
        navigationItem.leftBarButtonItem = editButtonItem()
        
        // Cargo  las 'news' guardadas  en  disco
//        if let savedNews = loadUpNews() {
//            news += savedNews
//        }else{
            // Sino, cargo las 'news' de  ejemplo
            loadSamplesNews()
//        }
        
        // Botón 'back':de vuelva pantalla inicio
        let button = UIBarButtonItem(title: "❮ Back👻", style: UIBarButtonItemStyle.Done,
            target: self, action: "goBack")
        // Situo el botón (Item) al lado izquierdo
        self.navigationItem.leftBarButtonItem = button
        
        // Pedir a Mobile Services News publicadas
        populateModel()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        // Título  para  el ====> 'navigationItem'
        navigationItem.title = "Your News"
    }
    
    /// Lee noticias de ejemplo almacenadas en local
    func loadSamplesNews() {
        
        //let photo4 = UIImage(named: "noticias.jpg")
        let news1 = News(
            title: "Nuevas noticias",
            author: "Andrés",
            newstext: "Noticias mundiales",
            rating: 0,
            ratingTotalNews: 0,
            state: false,
            newDat: NSDate(),
            result: 0,
            amountVotes: 0
            //            ,
            //            latitude: 1.44553,
            //            longitude: 1.45445
            )!
        
        //let photo5 = UIImage(named: "noticiasfresquitas.png")
        let news2 = News(
            title: "Noticias frescas",
            author: "Carlos",
            newstext: "Noticias fresquitas fresquitas",
            rating: 0,
            ratingTotalNews: 0,
            state: false,
            newDat: NSDate(),
            result: 0,
            amountVotes: 0
            //            ,
            //            latitude: 1.2222,
            //            longitude: 1.2222
            )!
        
        //let photo6 = UIImage(named: "Mafalda_vin_prodiaser.jpg")
        let news3 = News(
            title: "Mafalda",
            author: "Andrés",
            newstext: "Mafalda se pone al día",
            rating: 0,
            ratingTotalNews: 0,
            state: false,
            newDat: NSDate(),
            result: 0,
            amountVotes: 0
            //            ,
            //            latitude: 1.3333,
            //            longitude: 1.3333
            )!
        
        news += [news1, news2, news3]
    }
    
    func onRefresh(sender: UIRefreshControl!) {
        
        let tablePhotos = client.tableWithName("photos")
        let predicate = NSPredicate(format: "state == false")
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        tablePhotos!.readWithPredicate(predicate){ result, error in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            if error != nil {
                print("Error: " + error.description)
                return
            }
            self.records = result.items as! [NSDictionary]
            print("Information: retrieved %d records", result.items.count)
            
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let control = news.count
        return control
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "NewsAuthorTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NewsAuthorTableViewCell
        
        // Obtener la noticia  seleccionada del array  para el 'data source layout'
        let newsOfIndexPath = news[indexPath.row]
        
        // Actualizando las propidades de la vista con sus valores correspondientes
        cell.titleLabel.text = newsOfIndexPath.title
        cell.authorLabel.text = newsOfIndexPath.author
        //cell.photoImage.image = newsOfIndexPath.photo
        cell.ratingControl.rating = newsOfIndexPath.result
        
//        let dateFormatter = NSDateFormatter()
//        // the "M/d/yy, H:mm" is put together from the Symbol Table
//        dateFormatter.dateFormat = "dd/MM/yy, HH:mm"
//        let dateFormt = dateFormatter.stringFromDate(newsOfIndexPath.newDat!)
        
        //cell.dateTextView.text = dateFormt
        
        // Aprovecho para asignar  datos de las votaciones y actualizar sus valores
        //NewsAuthorTableViewController.ratingTotalNewsForViewDetail = newsOfIndexPath.rating!
        NewsAuthorTableViewController.amountForViewDetail = newsOfIndexPath.amountVotes
        NewsAuthorTableViewController.resultViewDetail = newsOfIndexPath.result
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        
        return "Complet"
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            
            let tablePhotos = client.tableWithName("photos")
            
            let record = self.news[indexPath.row]
            let compleItem = record.mutableCopy() as! NSMutableDictionary
            compleItem["status"] = true
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            tablePhotos.update(compleItem as [NSObject : AnyObject]) { (result, error) in
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                if error != nil {
                    print("Error: " + error.description)
                    return
                }
                
                self.records.removeAtIndex(indexPath.row)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            
            
            if editingStyle == .Delete {
                
                // Antes de  actualizar 'news' en tabla
                tableView.beginUpdates()
                
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                
                // Elimino la fila  del => 'data source'
                //let  objDelete = news.removeAtIndex(indexPath.row)
                
                // Tabla 'photos' para borrado en Azure
                // let table = client.tableWithName("photos")
                
                // TODO: añadir el id al modelo para parasrlo como parámetro para poder borrar datos en la tabla 'photos'
                
//                table.deleteWithId(objDelete.id, completion: { (resultado: AnyObject?, error : NSError? ) -> Void in
//                    // error al canto
//                    if (error != nil){
//                        print("Error" + error!.description)
//                    }else{
//                        print("Elemento eliminado -> \(resultado)")
//                    }
//                })
                
                //                table.delete((objDelete as AnyObject) as! [NSObject : AnyObject], completion: {
                //                    (resultado: AnyObject?, error : NSError?) -> Void in
                //                    // error al canto
                //                    if (error != nil){
                //                        print("Error" + error!.description)
                //                    }else{
                //                        print("Elemento eliminado -> \(resultado)")
                //                    }
                //                })
                
                // Después de actualizar  news en tabla
                tableView.endUpdates()
                
                // Guardo 'news' al eliminar una noticia
                saveNews()
                
            } else if editingStyle == .Insert {
                
            }
    }
    
    // MARK: Populate Model
    
    ///  Popula  el  modelo
    func populateModel() {
        
        let nameTable = "photos"
        // Defino la tabla donde voy a coger 'vídeos/fotos' Azure'
        let tableNews = self.client.tableWithName(nameTable)
        
        // Prueba 2: Obtener todos los datos de tabla via 'MSQuery'
        let query = MSQuery(table: tableNews)
        
        // Incluir predicados, constrains  para filtrar, limitar el
        // número de filas que vamos a recibir o en múmero columnas
        query.orderByAscending("newdat")
        // Ejecutar el 'MSQuery', que es practiacamente al anterior
        query.readWithCompletion { (results: MSQueryResult?, error: NSError?) -> Void in
            
            // si no hay error
            if error == nil {
                // Guardao  los  resultados y sincronizo la tabla  con el modelo
                let resultsTableMS = results?.items
                
                // De los resultados recibidos, asigno a cada propiedad su valor
                for item in resultsTableMS! {
                    
                    // TODO: tengo que actualizar e insertar las propiedades que faltan al modelo
                    
                    //let id = (item["id"] as? String) ?? ""
                    let title = (item["title"] as? String) ?? ""
                    let author = (item["author"] as? String) ?? ""
                    let newstext = (item["newtext"] as? String) ?? ""
                    let rating = (item["rating"] as? Int) ?? 0
                    let ratingTotalNews = (item["ratingtotalNews"] as? Int) ?? 0
                    let state = (item["state"] as? Bool) ?? false
                    let newDat = (item["newdat"] as? NSDate) ?? NSDate()
                    let result = (item["result"] as? Int) ?? 0
                    let amountVotes = (item["amountvotes"] as? Int) ?? 0
                    //                    let latitude = item["latitude"] as! Double
                    //                    let longitude = item["longitude"] as! Double
                    
                    // Creo una nueva noticia con los datos sacados del dictionary
                    let newsCloud = News(title: title, author: author, newstext: newstext, rating: rating,ratingTotalNews : ratingTotalNews,state : state, newDat : newDat,
                        result : result, amountVotes : amountVotes)
                    //                    , latitude : latitude, longitude : longitude)
                    
                    
                    // Añado la nueva noticia recibida al array que contine 'News'
                    self.news.append(newsCloud!)
                }
                
                // Guardo en modo local
                self.saveNews()
                // Actualizo  la  tabla
                self.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetail" {
            
            // Casteo el nuevo controlador a tipo 'NewsViewController'
            let newsDetailViewController = segue.destinationViewController as! NewsViewController
            
            // Obtengo la celda que ha generado este segue => 'sender'
            if let selectNewsCell = sender as? NewsAuthorTableViewCell {
                
                // Obtengo la notica 'news' correspondiente a la celda
                // seleccionada, es decir, su 'indexPath' y lo  guardo
                let indexPath = tableView.indexPathForCell(selectNewsCell)!
                
                // Obtengo objeto seleccionado del'indexPath'del array
                let selectNews = news[indexPath.row]
                
                // Asigno el  objeto 'selectNews' a la propiedad 'news'
                // del controlador que es el objeto seleccionado table
                newsDetailViewController.news = selectNews
            }
        }
        else if segue.identifier == "addItem" {
            
            print("Adding new news")
            
        }
    }
    
    // MARK: Action
    
    @IBAction func unwindToNewsList(sender : UIStoryboardSegue) {
        
        // Casteo 'sourceViewController' de tipo 'UIViewController' a 'NewsViewController'
        if let sourceViewController = sender.sourceViewController as? NewsViewController,
            // Si no es 'nil' asigno a la constante  local 'new' el valor que tiene 'news'
            new = sourceViewController.news {
                
                // Compruebo si se ha seleccionado una fila de la tabla, si es así, es que
                // se está editando una celda por el usuario, por tanto guardo los cambios
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    
                    // Actualizo una noticia existente que se ha modificado por el usuario
                    news[selectedIndexPath.row] = new
                    
                    // Aprovecho para asignar  datos de las votaciones y actualizar sus valores
                    NewsAuthorTableViewController.amountForViewDetail = new.amountVotes
                    //NewsAuthorTableViewController.ratingTotalNewsForViewDetail = new.ratingTotalNews
                    NewsAuthorTableViewController.resultViewDetail = new.result
                    
                    // Guardo
                    self.saveNews()
                    
                    // Vuelvo a cargar  la fila  correspondiente  para mostrar los cambios
                    tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
                    
                    
                }else{
                    // Ésta se ejecuta mientras no se seleccione ninguna fila, sino al pulsar'+'
                    // Añado una  nueva noticia, calculando la posición en la tabla y la guardo
                    // La posción es, en la sección 0, y en el  total de noticas, el total será
                    // su posición en la  tabla, es decir, si hay 5 noticias, se  situará en el
                    // indexPath 5, y como empieza desde cero,siempre se colocará después de la
                    // última notica, ya  que éstas  empiezan a contar desde  cero en la  tabla
                    let newIndexPath = NSIndexPath(forRow: news.count,inSection: 0)//Sólo hay 1
                    news.append(new)
                    // Ahora  añado la nueva  noticia a la tabla en el 'indexPath' que le paso
                    tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                }
                // Guardo 'news' tanto si se añade una nueva o se ha actualizado una existente
                saveNews()
        }
    }
    
    // Activo el 'Refresh Control' en el 'inspector de propiedades'
    // y creo este'IBAction' para poder refrescar la tabla-cambios
    @IBAction func refreshTable(sender: AnyObject) {
        
        // Aquí  tengo que  actualizar la tabla, el modelo, etc...
        tableView.reloadData()
        
        // Por último, termino el  'Refresh Control'  de la  tabla.
        sender.endRefreshing()
    }
    
    // MARK: NSCoding
    
    /// Guarda la lista de noticias
    func saveNews() {
        
        self.activityIndicator?.activityIndicator.startAnimating()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            // Intento guardar  el array de las 'news', si se  ha podido  guardar me devuelve 'true'
            // Le paso constante  estática creada en 'News' que es la ruta al archivo donde guardar
            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self.news, toFile: News.archiveURL.path!)
            // Compruebo por consola si se han guardado o no los objetos en ruta especificada (path)
            if !isSuccessfulSave {
                print("Failed to save news")
            }
        }
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.activityIndicator?.activityIndicator.stopAnimating()
        }
    }
    
    /// Carga la lista de noticias
    func loadUpNews () -> [News]? {
        
        return NSKeyedUnarchiver.unarchiveObjectWithFile(News.archiveURL.path!) as? [News]
    }
    
    
    // MARK: Utils
    
    /// Nos  devuelve a la pantalla  de inicio al pulsar botón ===>'Back'
    func goBack()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
}

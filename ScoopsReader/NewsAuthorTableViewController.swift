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
    
    var client : MSClient = MSClient(applicationURL: NSURL(
        string: "https://scoopsdailay.azure-mobile.net/"),
        applicationKey: "SFfIMXQedqiHrvQJXiIuVKIomiMign98")
    
    // Modelo de objetos que recibimos de Mob.Serv
    var model : [AnyObject]?
    
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
        if let savedNews = loadUpNews() {
            news += savedNews
        }else{
            // Sino, cargo las 'news' de  ejemplo
            loadSamplesNews()
        }
        
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
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        // Color  para el título 'navigationItem'
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        // Color de fondo  para el 'navigationBar'
        UINavigationBar.appearance().barTintColor = UIColor.blackColor()
        
        // Color para el título de 'navigationBar'
        let color = UIColor.orangeColor()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.setTitleTextAttributes(
            [NSForegroundColorAttributeName: color], forState: .Normal)
    }
    
    /// Lee noticias de ejemplo almacenadas en local
    func loadSamplesNews() {
        
        //let photo4 = UIImage(named: "noticias.jpg")
        let news4 = News(
            title: "Nunas noticias",
            author: "Andrés",
            newstext: "Noticias mundiales",
            rating: 0,
            //            ,
            //            photo: photo4,
            //            state: false,
            //            newDat: NSDate(),
            //            result:  0,
            totalrating: 0
            //            amountVotes: 0
            )!
        
        //let photo5 = UIImage(named: "noticiasfresquitas.png")
        let news5 = News(
            title: "Notcias frescas",
            author: "Fernando",
            newstext: "Las noticias más fresquitas de la actualidad",
            rating: 0,
            //            ,
            //            photo: photo5,
            //            state: false,
            //            newDat: NSDate(),
            //            result:  0,
            totalrating: 0
            //            amountVotes: 0
            )!
        
        //let photo6 = UIImage(named: "Mafalda_vin_prodiaser.jpg")
        let news6 = News(
            title: "Mafalda",
            author: "Marta",
            newstext: "Mafalda se pone al día",
            rating: 0,
            //            ,
            //            photo: photo6,
            //            state: false,
            //            newDat: NSDate(),
            //            result:  0,
            totalrating: 0
            //            amountVotes: 0
            )!
        
        news += [news4, news5, news6]
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
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            
            if editingStyle == .Delete {
                
                // Elimino la  fila  del => 'data source'
                news.removeAtIndex(indexPath.row)
                // Guardo 'news' al eliminar una noticia
                saveNews()
                
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                
            } else if editingStyle == .Insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
    }
    
    // MARK: Populate Model
    
    ///  Popula  el  modelo
    func populateModel() {
        
        let nameTable = "photos"
        // Defino la tabla donde voy a coger 'vídeos/fotos' Azure'
        let tableNews = self.client.tableWithName(nameTable)
        
        // Prueba 1: obtener todos los datos de tabla via 'MSTable'
//        tableNews?.readWithCompletion({ (results: MSQueryResult?, error: NSError?) -> Void in
//            
//            // si no hay error
//            if error == nil {
//                // Guardao  los  resultados y sincronizo la tabla  con el modelo
//                let resultsTableMS = (results?.items as! AnyObject) as! [NSDictionary]
//                
//                // De  los datos  recibidos, asignamos  a cada propiedad su valor
//                for item in resultsTableMS {
//                    
//                    let id = item["id"] as! String
//                    let title = item["title"] as! String
//                    let author = item["author"] as! String
//                    let newstext = item["newtext"] as! String
//                    let rating = item["rating"] as! Int
//                    let totalrating = item["totalrating"] as! Int
//                    
//                    // Creo una nueva noticia con los datos sacados del dictionary
//                    let newsCloud = News(id: id, title: title, author: author, newstext: newstext, rating: rating, totalrating: totalrating)
//                    
//                    // Añado la nueva noticia recibida al array que contine 'News'
//                    self.news.append(newsCloud!)
//                    
//                }
//                
//                // Por último, guardo también en modo local la  nueva noticia
//                self.saveNews()
//                // actualizo la tabla con un 'reload'
//                self.tableView.reloadData()
//            }
//        })
        
        // Prueba 2: Obtener todos los datos de tabla via 'MSQuery'
        let query = MSQuery(table: tableNews)
        
        // Incluir predicados, constrains  para filtrar, limitar el
        // número de filas que vamos a recibir o en múmero columnas
        query.orderByAscending("__updatedAt")
        // Ejecutar el 'MSQuery', que es practiacamente al anterior
        query.readWithCompletion { (results: MSQueryResult?, error: NSError?) -> Void in
            
            // si no hay error
            if error == nil {
                // Guardao  los  resultados y sincronizo la tabla  con el modelo
                let resultsTableMS = (results?.items as! AnyObject) as! [NSDictionary]
                
                // De  los datos  recibidos, asignomos  a cada propiedad su valor
                for item in resultsTableMS {
                    
                    //let id = item["id"] as! String
                    let title = item["title"] as! String
                    let author = item["author"] as! String
                    let newstext = item["newtext"] as! String
                    let rating = 4
                    let totalrating = 16
                    
                    // Creo una nueva noticia con los datos sacados del dictionary
                    let newsCloud = News(title: title, author: author, newstext: newstext, rating: rating, totalrating: totalrating)
                    
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

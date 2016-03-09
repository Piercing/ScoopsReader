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
    // x90MSepEOi1TMwFnhft+iBtxVCWeA9JIoC6FlLZxhPNEjHT04Y6/kup4/XvuabeBMc0pYEtzfZf2KaqGK1rVOw==
    
    // DefaultEndpointsProtocol=https;AccountName=scoopes;AccountKey=x90MSepEOi1TMwFnhft+iBtxVCWeA9JIoC6FlLZxhPNEjHT04Y6/kup4/XvuabeBMc0pYEtzfZf2KaqGK1rVOw==
    //let account = AZSCloudStorageAccount(fromConnectionString: "")
    
    // MARK: Properties
    var client : MSClient = MSClient(applicationURL: NSURL(
        string: "https://scoopsdailay.azure-mobile.net/"),
        applicationKey: "VjcTsrgmahsJOviIgUWrrkpQHxIRKO71")
    
    var news = [News]()
    var activityIndicator : NewsViewController?

    
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
        
        // Modelo  para ser publicado en la tabla
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
        
        let photo4 = UIImage(named: "noticias.jpg")
        let news4 = News(
            title: "Nunas noticias",
            author: "Andrés",
            newsText: "Noticias mundiales",
            rating: 3,
            photo: photo4,
            state: false,
            newDat: NSDate())!
        
        let photo5 = UIImage(named: "noticiasfresquitas.png")
        let news5 = News(
            title: "Notcias frescas",
            author: "Fernando",
            newsText: "Las noticias más fresquitas de la actualidad",
            rating: 3,
            photo: photo5,
            state: false,
            newDat: NSDate())!
        
        let photo6 = UIImage(named: "Mafalda_vin_prodiaser.jpg")
        let news6 = News(
            title: "Mafalda",
            author: "Marta",
            newsText: "Mafalda se pone al día",
            rating: 3,
            photo: photo6,
            state: false,
            newDat: NSDate())!
        
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
        return news.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "NewsAuthorTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NewsAuthorTableViewCell
        
        // Obtener la noticia  seleccionada del array  para el 'data source layout'
        let newsOfIndexPath = news[indexPath.row]
        
        // Actualizando las propidades de la vista con sus valores correspondientes
        cell.titleLabel.text = newsOfIndexPath.title
        cell.authorLabel.text = newsOfIndexPath.author
        cell.photoImage.image = newsOfIndexPath.photo
        cell.ratingControl.rating = newsOfIndexPath.rating
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
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
        
        // Defino la tabla donde voy a coger 'vídeos/fotos' Azure'
        let tableNews = client.tableWithName("news")
        
        // Prueba 1: obtener todos los datos de tabla via 'MSTable'
//        tableNews?.readWithCompletion({ (results: MSQueryResult?, error: NSError?) -> Void in
//            
//            // si no hay error
//            if error == nil {
//                // Sincronizo la tabla con el modelo
//                self.news = results?.items as! [News]
//                // actualizo la tabla con un 'reload'
//                self.tableView.reloadData()
//            }
//        })
        
        // Prueba 2: Obtener todos los datos de tabla via 'MSQuery'
        let query = MSQuery(table: tableNews)
        
        // Incluir predicados, constrains  para filtrar, limitar el
        // número de filas que vamos a recibir o en múmero columnas
        query.orderByAscending("actualdate")
        // Ejecutar el 'MSQuery', que es practiacamente al anterior
        query.readWithCompletion { (results: MSQueryResult?, error: NSError?) -> Void in
            
            // si no hay error
            if error == nil {
                // Sincronizo la tabla con el modelo
                self.news = results?.items as! [News]
                // actualizo la tabla con un 'reload'
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
                
                // //************** TODO: aprovecho para coger el indexpath y asignarle ****************//
                // guardarle, la cantidad de rating y votos que tiene,
                // el 'state' que tiene, la fecha  y las  coordenadas.
                
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
                    // Vuelvo a cargar  la fila  correspondiente  para mostrar los cambios
                    tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
                    
                }else{
                    // Ésta se ejecuta mientras no se selecciona ninguna fila por el usuario(+)
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

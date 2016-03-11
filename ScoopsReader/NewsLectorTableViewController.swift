//
//  NewsLectorTableViewController.swift
//  ScoopsReader
//
//  Created by MacBook Pro on 5/3/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

import UIKit

class NewsLectorTableViewController: UITableViewController {
    
    // MARK: Properties
    var news = [News]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Título  para  el ===> 'navigationItem'
        navigationItem.title = "Your News"
        
        //self.navigationItem.leftBarButtonItem?.title = "Back"
        
        // Color  para el título 'navigationItem'
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        // Color de fondo para el 'navigationBar'
        UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
        
        let color = UIColor.whiteColor()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.setTitleTextAttributes(
            [NSForegroundColorAttributeName: color], forState: .Normal)
        
        // Defino  altura de las celdas en tabla
        self.tableView.rowHeight = 120
        
        // Cargar noticas
        loadNews()
        
    }
    
    func loadNews() {
        
        let photo4 = UIImage(named: "noticias.jpg")
        let news4 = News(
            title: "Nunas noticias",
            author: "Andrés",
            newsText: "Noticias mundiales",
            rating: 0,
            photo: photo4,
            state: false,
            newDat: NSDate(),
            result:  0,
            totalRating: 0,
            amountVotes: 0)!
        
        let photo5 = UIImage(named: "noticiasfresquitas.png")
        let news5 = News(
            title: "Notcias frescas",
            author: "Fernando",
            newsText: "Las noticias más fresquitas de la actualidad",
            rating: 0,
            photo: photo5,
            state: false,
            newDat: NSDate(),
            result:  0,
            totalRating: 0,
            amountVotes: 0)!
        
        let photo6 = UIImage(named: "Mafalda_vin_prodiaser.jpg")
        let news6 = News(
            title: "Mafalda",
            author: "Marta",
            newsText: "Mafalda se pone al día",
            rating: 0,
            photo: photo6,
            state: false,
            newDat: NSDate(),
            result:  0,
            totalRating: 0,
            amountVotes: 0)!
        
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
        
        let cellIdentifier = "newsLectorTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NewsLectorTableViewCell
        
        // Obtener la noticia  seleccionada del array  para el 'data source layout'
        let newsOfIndexPath = news[indexPath.row]
        
        // Actualizando las propidades de la vista con sus valores correspondientes
        cell.titleLabel.text = newsOfIndexPath.title
        cell.authorLabel.text = newsOfIndexPath.author
        cell.photoImage.image = newsOfIndexPath.photo
        cell.ratingControl.rating = newsOfIndexPath.rating!
        
        return cell
    }
    
    
    @IBAction func unwindToNewsList(sender : UIStoryboardSegue) {
        
        // Casteo 'sourceViewController' de tipo 'UIViewController' a 'NewsViewController'
        if let sourceViewController = sender.sourceViewController as? NewsViewController,
            // Si no es 'nil' asigno a la constante  local 'new' el valor que tiene 'news'
            new = sourceViewController.news {
                // Añado una nueva noticia, calculando la posición en la tabla y la guardo
                let newIndexPath = NSIndexPath(forRow: news.count, inSection: 0)
                news.append(new)
                // Ahora  añado la nueva  noticia a la tabla en el 'indexPath' que le paso
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

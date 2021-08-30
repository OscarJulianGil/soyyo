//
//  ViewController.swift
//  SoyYo
//
//  Created by Oscar Julian on 27/08/21.
//  Copyright © 2021 Oscar Julian Gil Bernal. All rights reserved.
//

import UIKit

class ViewController: UIViewController,IServerResponse {
    
    @IBOutlet var text: UILabel!
    @IBOutlet var table: UITableView!
    @IBOutlet var spinnerContainer: UIView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var userMessage: UILabel!
    
    var network = NetworkManager()
    var items = [Apod]()
    var itemseleccionado : Apod?
    var dateInitRequest : String = ""
    var dateEndRequest : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        //Realiza el calculo de la fecha
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = Date()
        let nextDate = Calendar.current.date(byAdding: .day, value: -8, to: today)
        dateInitRequest = dateFormatter.string(from: nextDate!)
        dateEndRequest = dateFormatter.string(from: today)
        table.register(UINib(nibName: "CellNasaApod", bundle: nil), forCellReuseIdentifier: "CellNasaApod")
        loadDataServer(dateOne: dateInitRequest,dateTwo : dateEndRequest,isRango: true)
       
    }
    
    //Realiza la petición al servidor
    func loadDataServer(dateOne : String, dateTwo: String ,isRango : Bool){
        showSpinner(show: true)
        let parametros :[String:String]
        if isRango{
            parametros  = ["api_key":Constantes.API_KEY,"start_date" : dateOne, "end_date" : dateTwo]
        }
        else{
             parametros = ["api_key":Constantes.API_KEY,"date" : dateOne]
        }
        network.delegate = self
        network.getServerData(endpoint: "planetary/apod", parameters : parametros)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "godetail"{
           if let viewController = segue.destination as? DetailController {
               viewController.detailItem = self.itemseleccionado
           }
        }
    }
    
    ///Muestra o oculta el spinner
    func showSpinner(show : Bool){
        if show {
            showMessageUser(mesage: "Un momento por favor")
            spinner.startAnimating()
            spinner.isHidden = false
            spinnerContainer.isHidden = false
        }
        else{
            spinner.stopAnimating()
            spinnerContainer.isHidden = true
        }
    }
    
    ///Muestra mensaje al usuario, esconde el spinner
    func showMessageUser(mesage : String){
        spinner.isHidden = true
        self.userMessage.text = mesage
    }
    
    ///Captura las respuestas del servidor
    func Response(response: ServerResponse) {
       var ApiError : Bool = false
       let decoder = JSONDecoder()
       decoder.dateDecodingStrategy = .iso8601
       if let dataserver = response.data {
        
            do{
                let item = try decoder.decode(Apod.self, from: dataserver)
            
                if item.code != nil{
                    ApiError = true
                }
                
                if ApiError{
                    DispatchQueue.main.async {
                        self.showMessageUser(mesage: "Lo sentimos, no tenemos información para mostrar")
                    }
                    return
                }
                
                self.items = [Apod]()
                
                DispatchQueue.main.async {
                     self.showSpinner(show: false)
                     self.items.append(item)
                     self.table.reloadData()
                }
                return
            }
            catch let error{
                DispatchQueue.main.async {
                    self.userMessage.text = "Error " + error.localizedDescription
                }
            }
        
           do{
               print("Respuesta exitosa")
               let items = try decoder.decode(Array<Apod>.self, from: dataserver)
               self.items = [Apod]()
               DispatchQueue.main.async {
                    self.showSpinner(show: false)
                    self.items = items
                    self.table.reloadData()
                }
                
           }
           catch let error{
               DispatchQueue.main.async {
                self.userMessage.text = "Error " + error.localizedDescription
               }
           }
       }
       else{
          DispatchQueue.main.async {
            self.userMessage.text = "Lo sentimos, no tenemos información para mostrar"
          }
       }
    }
}

//Extension para usar el datasource de la tabla
extension ViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "CellNasaApod", for : indexPath)
        as! CellNasaApod
        
        if self.items[indexPath.row].media_type! == "video"{
            cell.ItemImage.image = UIImage(named: "nodisponible")
        }
        else{
            let url = URL(string: self.items[indexPath.row].url!)
            cell.ItemImage.load(url: url!)
        }

        cell.textTitle.text = self.items[indexPath.row].title
        cell.textDate.text = self.items[indexPath.row].date
        return cell
    }
}


//Extension para usar el delegado del datatable
extension ViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.itemseleccionado = self.items[indexPath.row]
        self.performSegue(withIdentifier: "godetail", sender: self)
    }
}

//Extension para cargar desde una URL la imagen en un control UIImageView
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


//Extensión para usar el delegado de la barra de busqueda
extension ViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Click")
        loadDataServer(dateOne: searchBar.text!,dateTwo: "", isRango: false)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            DispatchQueue.main.async {
                self.loadDataServer(dateOne: self.dateInitRequest,dateTwo : self.dateEndRequest,isRango: true)
               searchBar.resignFirstResponder()
            }
            
        }
    }
}

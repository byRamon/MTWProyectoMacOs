//
//  TableViewController.swift
//  Proyecto
//
//  Created by ByRamon on 12/12/19.
//  Copyright © 2019 ByRamon. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    struct strucNombres: Decodable {
        let nombres: [String]
    }
    var nombres:[String] = []
    let objetoFileHelper = FileHelper()
    var miDB:FMDatabase?=nil
    var alerta:UIAlertController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        miDB=FMDatabase(path: objetoFileHelper.pathArchivoEnCarpetaDocumentos("Proyecto"))
        SelectAll()
        CargarJson()
        SelectAll()
        self.tableView.reloadData()
    }
    func SelectAll(){
        nombres = []
        if (miDB!.open()){
            let querySQL = "SELECT * FROM Nombres"
            let resultados:FMResultSet? = try! miDB!.executeQuery(querySQL, withParameterDictionary: nil)
            while resultados!.next() == true {
                nombres.append(resultados!.string(forColumn: "Nombre")!)
            }
            miDB!.close()
        }
        else{
            print("No halle")
        }
    }
    func Insert(_ nombre: String){
        if(miDB!.open()){
            let inserta = miDB!.executeUpdate("INSERT into Nombres (Nombre) VALUES (?)", withArgumentsIn: [nombre])
            if inserta{
                print("hola me llamo \(nombre).")
            }
            else{
                print("No Guarde")
            }
        }
        miDB!.close()
    }
    func CargarJson(){
        let urlStr = "http://192.168.64.2/Nombres.json"
        if let url = URL(string: "http://192.168.64.2/Nombres.json") {
           URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data {
                 if let jsonString = String(data: data, encoding: .utf8) {
                    do {
                        let res = try JSONDecoder().decode(strucNombres.self, from: data)
                        print("existen ", res.nombres.count)
                        for nombre in res.nombres {
                            if !self.nombres.contains(nombre) {
                                print("No existe ", nombre)
                                self.Insert(nombre)
                            }
                        }
                    } catch let error {
                       print(error)
                    }
                 }
               }
           }.resume()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return nombres.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = nombres[indexPath.row]
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

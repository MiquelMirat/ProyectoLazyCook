//
//  AlergensViewController.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 16/05/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import UIKit

class SearchAlergenVC: UIViewController {
    

    @IBOutlet weak var alergensTable: UITableView!
    
    //esta vista solo se llama desde la pagina 2 (tiene que ser la 3) y en esa pagina siempre se setteara la lista aunque este vacia desde el prepare segue
    var selectedAlergens:[Alergenos]!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alergensTable.delegate = self
        alergensTable.dataSource = self
        self.navigationItem.title = "LazyCook"

        print("selected alergens count: ", selectedAlergens.count)
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        print("prepare alergens controller")
        if segue.destination is NewRecipePageThree {
            let vc = segue.destination as? NewRecipePageThree
            vc?.recipe?.alergenos = self.selectedAlergens
        }
    }
    
    
}
extension SearchAlergenVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Alergenos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = alergensTable.dequeueReusableCell(withIdentifier: "alergenCell", for: indexPath) as! AlergenCell
        cell.nameLbl.text = Alergenos(rawValue: indexPath.row)?.name
        cell.descrLbl.text = Alergenos(rawValue: indexPath.row)?.description
        cell.selectionMark.isHidden = !selectedAlergens.contains(Alergenos(rawValue: indexPath.row)!)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alergeno = Alergenos(rawValue: indexPath.row)
        if selectedAlergens.contains(alergeno!) {
            selectedAlergens = selectedAlergens.filter { $0 != alergeno! }
        }else{
            selectedAlergens.append(alergeno!)
        }
        print("alergen count changed: ", selectedAlergens.count)
        let alergenos:[String: [Alergenos]] = ["alergenos": selectedAlergens]
        NotificationCenter.default.post(name: Notification.Name(rawValue: "searchAlergenSelected"), object: nil, userInfo: alergenos)
        
        tableView.reloadData()
        
    }
    
    
    
}

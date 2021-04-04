//
//  LastViewController.swift
//  Runner
//
//  Created by Artem Yurchenko on 31.03.2021.
//

import UIKit

class LastViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Move(_ sender: Any) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(next, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

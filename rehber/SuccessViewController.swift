//
//  SuccessViewController.swift
//  rehber
//
//  Created by Sefa MacBook Pro on 5.05.2021.
//

import UIKit

class SuccessViewController: UIViewController {

    @IBOutlet weak var successView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        successView.layer.cornerRadius = successView.frame.height / 3
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapp))
        view.addGestureRecognizer(tap)
    }
    
    @objc func tapp(){
        //performSegue(withIdentifier: "fromSuccessToDetails", sender: nil)
        self.dismiss(animated: true, completion: nil)
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

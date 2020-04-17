//
//  ResultPage.swift
//  Cme4428_Calculator
//
//  Created by COREBIT on 2.04.2020.
//  Copyright © 2020 akif.cakar. All rights reserved.
//

import UIKit

class ResultPage: UIViewController {
    
    @IBOutlet weak var resultLabel: UITextView!
    var resultLogSave = [String]();
    

    override func viewDidLoad() {
        super.viewDidLoad()

        resultLabel.isEditable = false
        setLabelBorder();
        fillHistory();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    
    func fillHistory(){
        var tempValue:String = "";
        for opr in resultLogSave {
            let sepVal : [String] = opr.components(separatedBy: " ")
            
            for spVl in sepVal {
                tempValue += "\n" + spVl  + " "
            }
            tempValue += "\n <-------->"
            print(opr)
        }
        resultLabel.text = tempValue;
        
    }
    
    func setLabelBorder(){
        resultLabel.layer.borderColor = UIColor.lightGray.cgColor
        resultLabel.layer.borderWidth = 2.0
    }

    @IBAction func clear(_ sender: Any) {
        resultLogSave = [String]();
        resultLabel.text = " " ;
        
        let alert = UIAlertController(title: "History Cleaned", message: "", preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
            (UIAlertAction) in
            self.startSeque();
        });
        alert.addAction(okButton);
        self.present(alert,animated: true,completion: nil);
        
        
        
    }
    
    func startSeque(){
        performSegue(withIdentifier: "GoToMain", sender: nil);
    }
    
    @IBAction func back(_ sender: Any) {
        performSegue(withIdentifier: "GoToMain", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "GoToMain" {
            let destinationVC = segue.destination as! ViewController;
            destinationVC.LogSave = resultLogSave;
        }
    }
    
}

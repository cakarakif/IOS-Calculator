//
//  ViewController.swift
//  Cme4428_Calculator
//
//  Created by Akif Cakar on 1.04.2020.
//  Copyright © 2020 akif.cakar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var label: UILabel!
    
    public var LogSave = [String]();
    private var isFirstOperation:Bool=true;
    
    private var isCommaActive:Bool=true;
    private var isClickedEqual:Bool=false;
    private var isCleanable:Bool=false;
    private var tempElement:String = "0";
    private var result:String = "0";
    private var lastOperation:String = "=";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        label.isUserInteractionEnabled = true;
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        label.addGestureRecognizer(tap);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    //sequePart
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        performSegue(withIdentifier: "GoToResult", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "GoToResult" {
            let destinationVC = segue.destination as! ResultPage;
            destinationVC.resultLogSave = LogSave;
        }
    }
    
    //////////////////////////////////////////////////////////////
    //helper functions
    
    func setNumeric(numeric:String){ // her sayı işleminde label güncellenir
        if lastOperation.elementsEqual("="){
            isClickedEqual = false;
            tempElement = "0"
        }
        
        if isCleanable {
            label.text = "0";
            isCleanable = false;
        }
        if numeric != "." {
            label.text = convertValue(val: String(label.text!) + numeric);
        }else{
            label.text = String(label.text!) + numeric;
        }
    }
    
    func setValue2Label(){ // güncel sonuc degeri labele yazılır
        if !isFirstOperation && lastOperation !=  "="{
            LogSave.append(convertValue(val: String(Double(tempElement)!)) + " " + lastOperation + " " + convertValue(val: String(getLabelDouble())) + " = " + convertValue(val: result)) ;
        }else {
            isFirstOperation = false;
        }
        label.text = convertValue(val: result);
    }
    
    func convertValue(val:String) -> String{
        if Double(val)! > 999999999999999999.0{
            return "0"
        }
        
        let isInteger = floor(Double(val)!) == Double(val)
        
        if isInteger {
            return String(Int(Double(val)!));
        }else {
            return val;
        }
    }
    
    func getLabelDouble() -> Double{ //label'deki deger double'a cevrilir
        if isClickedEqual && lastOperation != "%" && lastOperation != "+/-"{
            if lastOperation == "*" || lastOperation == "/"{
                print("burda111")
                return 1;
            }
            print("burda222")
            return 0;
        }
        
        if let text = label.text {
            let numberFormatter = NumberFormatter();

            return (numberFormatter.number(from: text)?.doubleValue)! ;
        }
        return 0;
    }
    
    func generalSettingAfterOperation(){// aritmetik işlemlerden sonra genel setleme ve resetlemeler
        setValue2Label();
        tempElement = label.text!;
        isCleanable = true; // yeni deger girişi takibi
        isCommaActive = true; // nokta islemi takibi
        isClickedEqual = false; //3 + 4 = + 3
    }
    
    //////////////////////////////////////////////////////////////
    //main functions
    
    func calculateDirect() -> String {
        var uptTemp = " ";
        if Double(tempElement)! == 0 {
            uptTemp = String(getLabelDouble());
        }else {
            uptTemp = String(Double(tempElement)!);
        }
        let s = uptTemp + " " + lastOperation + " " + String(getLabelDouble());
        let expn = NSExpression(format:s)
        return "\(expn.expressionValue(with: nil, context: nil) ?? "0")"
    }
    
    //comma
    @IBAction func comma(_ sender: Any) {
        if(isCommaActive){
            isCommaActive=false;
            setNumeric(numeric: ".")
        }
    }
    
    //Equal
    @IBAction func equal(_ sender: Any) {
        if !lastOperation.elementsEqual("=") && lastOperation != "%" && lastOperation != "+/-"{
            let s = String(Double(tempElement)!) + " " + lastOperation + " " + String(getLabelDouble());
            let expn = NSExpression(format:s)
            result = "\(expn.expressionValue(with: nil, context: nil) ?? "0")"
            generalSettingAfterOperation();
            lastOperation = "=";
            isClickedEqual = true;
        }
    }
    
    //Operations
    @IBAction func plus(_ sender: Any) {
        if !isCleanable || isClickedEqual{
            
            if lastOperation != "+" &&  lastOperation != "=" && lastOperation != "%" && lastOperation != "+/-"{
                result = calculateDirect();
            }else {
                result = String(Double(tempElement)! + getLabelDouble());
            }
            generalSettingAfterOperation();
            lastOperation = "+";
        }else{
            lastOperation = "+";
        }
        
    }
    
    @IBAction func minus(_ sender: Any) {
        if !isCleanable || isClickedEqual{
            
            if lastOperation != "-" &&  lastOperation != "=" && lastOperation != "%" && lastOperation != "+/-"{
                result = calculateDirect();
            }else {
                result = Double(tempElement)! == 0 ? String(getLabelDouble()) : String(Double(tempElement)! - getLabelDouble());
            }
            generalSettingAfterOperation();
            lastOperation = "-";
            
        }else{
            lastOperation = "-";
        }
    }
    
    @IBAction func multiply(_ sender: Any) {
        if !isCleanable || isClickedEqual{
            
            if lastOperation != "*" &&  lastOperation != "=" && lastOperation != "%" && lastOperation != "+/-"{
                result = calculateDirect();
            }else {
                var labelVal = getLabelDouble();
                if(labelVal == 0){
                    labelVal = 1;
                }
                
                result = Double(tempElement)! == 0 ? String(getLabelDouble()) : String(Double(tempElement)! * labelVal);
            }
            
            generalSettingAfterOperation();
            lastOperation = "*";
        }else{
            lastOperation = "*";
        }
    }
    
    @IBAction func division(_ sender: Any) {
        if !isCleanable || isClickedEqual{
            if lastOperation != "/" &&  lastOperation != "=" && lastOperation != "%" && lastOperation != "+/-"{
                result = calculateDirect();
            }else {
                var labelVal = getLabelDouble();
                if(labelVal == 0){
                    labelVal = 1;
                }
                result = Double(tempElement)! == 0 ? String(getLabelDouble()) : String(Double(tempElement)! / labelVal);
            }
            generalSettingAfterOperation();
            lastOperation = "/";
        }else{
            lastOperation = "/";
        }
    }
    
    @IBAction func percentage(_ sender: Any) {
        lastOperation = "%";
        result = String(getLabelDouble() / 100);
        generalSettingAfterOperation();
    }
    
    @IBAction func plusminus(_ sender: Any) {
        lastOperation = "+/-";
        result = String(-getLabelDouble());
        generalSettingAfterOperation();
    }
    
    @IBAction func ac(_ sender: Any) {
        label.text = "0";
        tempElement = "0";
        isCommaActive=true;
        isClickedEqual=false;
        isFirstOperation=true;
    }
    
    //numerics
    @IBAction func zero(_ sender: Any) {
        setNumeric(numeric: "0")
    }
    
    @IBAction func one(_ sender: Any) {
        setNumeric(numeric: "1")
    }
    
    @IBAction func two(_ sender: Any) {
        setNumeric(numeric: "2")
    }
    
    @IBAction func three(_ sender: Any) {
        setNumeric(numeric: "3")
    }
    
    @IBAction func four(_ sender: Any) {
        setNumeric(numeric: "4")
    }
    
    @IBAction func five(_ sender: Any) {
        setNumeric(numeric: "5")
    }
    
    @IBAction func six(_ sender: Any) {
        setNumeric(numeric: "6")
    }
    
    @IBAction func seven(_ sender: Any) {
        setNumeric(numeric: "7")
    }
    
    @IBAction func eight(_ sender: Any) {
        setNumeric(numeric: "8")
    }
    
    @IBAction func nine(_ sender: Any) {
        setNumeric(numeric: "9")
    }
    
}


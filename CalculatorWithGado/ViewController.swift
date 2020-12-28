//
//  ViewController.swift
//  CalculatorWithGado
//
//  Created by ahmed gado on 27/12/2020.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var calculatorWorkthings: UILabel!
    @IBOutlet weak var calculatorResults: UILabel!
    @IBOutlet weak var timeTXT: UITextField!
    var workChanges : String = ""
    var workTimeChanges : String = ""
    fileprivate let pickerView = ToolbarPickerView()
    var timeData = [5,10,15,20,25,30,35,40,45,50,55,60,65,70]
    var timeOut : Double?
    var isTimeSelected = false
    override func viewDidLoad(){
        super.viewDidLoad()
        timeTXT.attributedPlaceholder = NSAttributedString(string: "Time",attributes:[NSAttributedString.Key.foregroundColor: UIColor.green])
        self.timeTXT.inputView = self.pickerView
        self.timeTXT.inputAccessoryView = self.pickerView.toolbar
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.toolbarDelegate = self
        self.pickerView.reloadAllComponents()
    }
    
    
    
    @IBAction func allClear(_ sender: Any) {
        workChanges = ""
        calculatorResults.text = ""
        calculatorWorkthings.text = ""
    }
    func addToWorkChanges(value : String){
        workChanges = workChanges + value
        calculatorWorkthings.text = workChanges
    }
    @IBAction func zeroTap(_ sender: Any) {
        addToWorkChanges(value: "0")
    }
    @IBAction func dotTap(_ sender: Any) {
        addToWorkChanges(value: ".")
    }
    @IBAction func oneTap(_ sender: Any) {
        addToWorkChanges(value: "1")
    }
    @IBAction func twoTap(_ sender: Any) {
        addToWorkChanges(value: "2")
    }
    @IBAction func threeTap(_ sender: Any) {
        addToWorkChanges(value: "3")
    }
    @IBAction func fourTap(_ sender: Any) {
        addToWorkChanges(value: "4")
    }
    @IBAction func fiveTap(_ sender: Any) {
        addToWorkChanges(value: "5")
    }
    @IBAction func sixTap(_ sender: Any) {
        addToWorkChanges(value: "6")
    }
    @IBAction func sevenTap(_ sender: Any) {
        addToWorkChanges(value: "7")
    }
    @IBAction func eightTap(_ sender: Any) {
        addToWorkChanges(value: "8")
    }
    @IBAction func nineTap(_ sender: Any) {
        addToWorkChanges(value: "9")
    }
    @IBAction func divTap(_ sender: Any) {
        addToWorkChanges(value: "/")
    }
    @IBAction func mulTap(_ sender: Any) {
        addToWorkChanges(value: "*")
    }
    @IBAction func subTap(_ sender: Any) {
        addToWorkChanges(value: "-")
    }
    @IBAction func addTap(_ sender: Any) {
        addToWorkChanges(value: "+")
        
    }
    @IBAction func calculateResultTap(_ sender: Any) {
        print("Update UI Forground")
        if !isTimeSelected {
            let alert = UIAlertController(title: "Erorr", message: "You should choces time", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if calculatorWorkthings.text! == ""{
            let alert = UIAlertController(title: "Erorr", message: "You should make operation ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func validInput() -> Bool {
        var count = 0
        var charIndexes = [Int]()
        for char in workChanges{
            if specialChar(char: char) {
                charIndexes.append(count)
            }
            count += 1
        }
        var previous : Int = -1
        for index in charIndexes{
            if index == 0 {return false}
            if index == workChanges.count - 1 { return false}
            if previous != -1 {
                if index - previous == 1 {
                    return false
                }
            }
            previous = index
        }
        return true
    }
    func specialChar(char : Character) -> Bool {
        if char == "*" {return true}
        if char == "/" {return true}
        if char == "+" {return true}
        return false
    }
    func formateResult(result : Double) -> String {
        if result.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", result)
        }else{
            return String(format: "%.2f", result)
        }
    }
    
    func updateUI() {
        
        print("Update UI Background")
        self.updateTime()
//        let date = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "H:mm:ss"
//        let current_date_time = dateFormatter.string(from: date)
//        print("Time \(current_date_time)")
        let dispatchQueue = DispatchQueue.global(qos: .background)
        dispatchQueue.async { [weak self] in
            guard let self = self else {return}
            dispatchQueue.asyncAfter(deadline: .now() + self.timeOut!) {
                if self.validInput() {
                    let chekWork = self.workChanges.replacingOccurrences(of: "%", with: "*0.01")
                    let exe = NSExpression(format: chekWork)
                    let result = exe.expressionValue(with: nil, context: nil) as! Double
                    let resultString = self.formateResult(result: result)
                    DispatchQueue.main.async {
                        self.calculatorResults.text = resultString
                    }
                }else {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Invalid Input", message: "Unable to do math on input", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    func updateTime(){
        var secondsRemaining : Int  = Int(timeOut!)
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self](Timer) in
            guard let self = self else {return}
            if secondsRemaining > 0 {
                print ("\(secondsRemaining)")
                self.timeTXT.text =  ("\(secondsRemaining)")
                secondsRemaining -= 1
            } else {
                Timer.invalidate()
                self.timeTXT.text = nil
            }
            
        }
        
    }
    
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.timeData.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String( self.timeData[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.timeTXT.text = String( self.timeData[row])
    }
}

extension ViewController: ToolbarPickerViewDelegate {
    
    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
        self.timeTXT.text = String( self.timeData[row])
        self.timeOut = Double(self.timeData[row])
        isTimeSelected = true
        self.timeTXT.resignFirstResponder()
    }
    
    func didTapCancel() {
        self.timeTXT.text = nil
        self.timeTXT.resignFirstResponder()
    }
}

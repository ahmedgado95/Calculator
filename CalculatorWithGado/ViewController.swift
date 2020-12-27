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
    var workChanges : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        if validInput() {
        let chekWork = workChanges.replacingOccurrences(of: "%", with: "*0.01")
        let exe = NSExpression(format: chekWork)
        let result = exe.expressionValue(with: nil, context: nil) as! Double
        let resultString = formateResult(result: result)
        calculatorResults.text = resultString
        }else {
            let alert = UIAlertController(title: "Invalid Input", message: "Unable to do math on input", preferredStyle: .alert)
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
}


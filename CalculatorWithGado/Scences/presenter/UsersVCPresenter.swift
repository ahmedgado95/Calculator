//
//  UsersVCPresenter.swift
//  CalculatorWithGado
//
//  Created by ahmed gado on 28/12/2020.
//

import Foundation


protocol UsersView: class {
    func fetchingDataSuccess(Tex:String)
    func fetchingTimeSuccess(Tex:String)
    func showError()
}


class UsersVCPresenter {
    
    private weak var view: UsersView?
//    private let interactor = UsersInteractor()
//    private var users = [User]()
    
    init(view: UsersView) {
        self.view = view
    }
    
    func viewDidLoad(timeOut: Double, workChanges: String) {
        updateUI(timeOut: timeOut, workChanges: workChanges)
    }
    
    func validInput(workChanges :String) -> Bool {
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
    
    func updateUI(timeOut: Double , workChanges :String) {
        
        print("Update UI Background")
        self.updateTime(timeOut: timeOut)
        let dispatchQueue = DispatchQueue.global(qos: .background)
        dispatchQueue.async { [weak self] in
            guard let self = self else {return}
            dispatchQueue.asyncAfter(deadline: .now() + timeOut) {
                if self.validInput(workChanges: workChanges) {
                    let chekWork = workChanges.replacingOccurrences(of: "%", with: "*0.01")
                    let exe = NSExpression(format: chekWork)
                    let result = exe.expressionValue(with: nil, context: nil) as! Double
                    let resultString = self.formateResult(result: result)
                    DispatchQueue.main.async {
//                        self.calculatorResults.text = resultString
                        self.view?.fetchingDataSuccess(Tex: resultString)

                    }
                }else {
                    DispatchQueue.main.async {

                        self.view?.showError()
                    }
                }
            }
        }
    }
    func updateTime(timeOut : Double){
        var secondsRemaining : Int  = Int(timeOut)
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self](Timer) in
            guard let self = self else {return}
            if secondsRemaining > 0 {
                self.view?.fetchingTimeSuccess(Tex: String(secondsRemaining))
                secondsRemaining -= 1
            } else {
                Timer.invalidate()
                self.view?.fetchingTimeSuccess(Tex: "")
            }
            
        }
        
    }
    
 
}

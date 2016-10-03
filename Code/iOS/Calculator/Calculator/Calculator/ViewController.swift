//
//  ViewController.swift
//  Calculator
//
//  Created by Student on 02/10/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    // Instance variable is a property in swift
    @IBOutlet weak var display: UILabel! // UILabel! is the type, ! means implicitly unwrapped optional

    var userInMiddleOfNumber = false
    
    @IBAction func appendDigit(_ sender: UIButton) {
        // let is constant var
        // ! unwraps optional, crashes is nil
        let digit = sender.currentTitle!
        if userInMiddleOfNumber {
            display.text = display.text! + digit
        }
        else {
            display.text = digit
            userInMiddleOfNumber = true
        }
        
    }
    
    @IBAction func operate(_ sender: UIButton) {
        let operation = sender.currentTitle!
        if userInMiddleOfNumber{
            enter()
        }
        switch operation {
        // closures: passing functions as args so common that can put the function into the arg itself
            case "×": performOperation { $0 * $1 } // infers return from method, last arg can go outside ()
            case "÷": performOperation { $1 / $0 }
            case "+": performOperation { $0 + $1 }
            case "−": performOperation { $1 - $0 }
            case "√": performOperation { sqrt($0) }
            default: break
        }
        
    }
    
    func performOperation(operation: (Double, Double) -> Double){
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(),operandStack.removeLast())
            enter()
        }
    }
    
    @nonobjc
    func performOperation(operation: (Double) -> Double){
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userInMiddleOfNumber = false;
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)")
    }
    
    var displayValue: Double {
        get {
            return NumberFormatter().number(from: display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userInMiddleOfNumber = false
        }
    }
}


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
    
    var brain = CalculatorBrain()
    
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
        if userInMiddleOfNumber{
            enter()
        }
        if let operation = sender.currentTitle {
            
            if let result = brain.performOperation(symbol: operation) {
                displayValue = result
            }
            else{
                displayValue = 0
            }
        }
    }
    
    
    @IBAction func enter() {
        userInMiddleOfNumber = false;
        if let result = brain.pushOperand(operand: displayValue){
            displayValue = result
        }
        else {
            displayValue = 0
        }
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


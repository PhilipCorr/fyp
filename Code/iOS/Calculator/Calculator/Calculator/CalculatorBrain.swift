//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Student on 03/10/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import Foundation

class CalculatorBrain{
    
    private enum Op {
        case Operand(Double)
        case UnaryOperation(String, (Double) -> Double)
        case BinaryOperation(String, (Double,Double) -> Double)
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]() //Dictionary
    
    init(){
        knownOps["×"]=Op.BinaryOperation("×", *)
        knownOps["÷"]=Op.BinaryOperation("÷"){$1 / $0}
        knownOps["+"]=Op.BinaryOperation("+", +)
        knownOps["−"]=Op.BinaryOperation("−"){$1 - $0}
        knownOps["√"]=Op.UnaryOperation("√",sqrt)
    }
    
    //let brain = CalculatorBrain() // calls init with matching args
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){ // returns a tuple
        
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation): // ignore string
                let operandEvaluation = evaluate(ops: remainingOps)
                if let operand = operandEvaluation.result{
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation): // ignore string
                let op1Evaluation = evaluate(ops: remainingOps)
                if let operand1 = op1Evaluation.result{
                    let op2Evaluation = evaluate(ops: op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return(nil, ops)
    }
    
    func evaluate() -> Double? { // returns optional in case user enters operation with no operands, need to return nil
        let (result, _) = evaluate(ops: opStack)
        return result
    }
    
    func pushOperand(operand: Double){
        opStack.append(Op.Operand(operand))
    }
    
    func performOperation(symbol: String){
        if let operation = knownOps[symbol]{ // returns optional op, if able to look up op in dictionary
            opStack.append(operation)
        }
    }
    
}

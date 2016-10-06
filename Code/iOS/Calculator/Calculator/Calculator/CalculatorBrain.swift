//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Student on 03/10/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum    Op: CustomStringConvertible
    {
        case Operand(Double)
        case UnaryOperation(String, (Double) -> Double)
        case BinaryOperation(String, (Double,Double) -> Double)
        
        var description: String {
            get {
                switch self{
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]() // array
    private var knownOps = [String:Op]() //Dictionary
    
    init(){
        func learnOp(op: Op){
            knownOps[op.description] = op
        }
        learnOp(op: Op.BinaryOperation("×", *))
        learnOp(op: Op.BinaryOperation("÷"){$1 / $0})
        learnOp(op: Op.BinaryOperation("+", +))
        learnOp(op: Op.BinaryOperation("−"){$1 - $0})
        learnOp(op: Op.UnaryOperation("√",sqrt))
    }
    
    typealias PropertyList = Array<AnyObject>
    var program: PropertyList { // gauranteed to be prop list
        get {
            var returnValue = Array<AnyObject>()
            for op in opStack {
                returnValue.append(op.description as AnyObject)
            }
            return returnValue
        }
        set {
            //make sure it is array of strings
            if let opSymbols = newValue as? Array<String>{
                var newOpStack = [Op]()
                for opSymbol in opSymbols{
                    if let op = knownOps[opSymbol]{
                        newOpStack.append(op)
                    }
                    //? here is chained optional, if any fail, return nil
                    else if let operand = NumberFormatter().number(from: opSymbol)?.doubleValue{
                        newOpStack.append(.Operand(operand))
                    }
                }
            }
        }
        
    }
    
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
    
    func evaluate() -> Double? { // returns optional in case user enters operation with no operands
        let (result, remainder) = evaluate(ops: opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol]{ // returns optional op, if able to look up op in dictionary
            opStack.append(operation)
        }
        return evaluate()
    }
    
}

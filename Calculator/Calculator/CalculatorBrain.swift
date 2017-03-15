//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Maxence de Cussac on 01/03/2017.
//  Copyright © 2017 Maxence de Cussac. All rights reserved.
//

import Foundation

struct CalculatorBrain {

    // MARK: - Enums
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }

	private let spaceString = " "

    private var accumulator: Double?

	private var resultIsPending: Bool {
		return pendingBinaryOperation != nil
	}

	public var description: String? = "" {
		didSet {
			print("description : \(description ?? spaceString)")
		}
	}

    private var operations: Dictionary<String, Operation> = [
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "Rand": Operation.constant(Double(arc4random())),
        "cos": Operation.unaryOperation(cos),
        "√": Operation.unaryOperation(sqrt),
        "sin": Operation.unaryOperation(sin),
        "×": Operation.binaryOperation { $0 * $1},
        "÷": Operation.binaryOperation { $0 / $1 },
        "+": Operation.binaryOperation { $0 + $1 },
        "−": Operation.binaryOperation { $0 - $1 },
        "10ˣ": Operation.unaryOperation { pow(10, $0) },
        "=": Operation.equals
    ]

    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
				description?.append(symbol)
            case .unaryOperation(let function):
                if accumulator != nil {
                    description?.append("\(symbol)" + "(\(String(accumulator!)))")
                    accumulator = function(accumulator!)
//					if description != nil && resultIsPending {
//						description = ("\(symbol)(\(description!))")
//					} else {
//						description = ("\(symbol)(\(accumulator))")
//					}
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    description?.append(String(accumulator!) + spaceString + symbol + spaceString)
                    accumulator = nil
                }
                break
            case .equals:
                if accumulator != nil && resultIsPending {
//                    description = description?.replacingOccurrences(of: "=", with: "")
                    description?.append(String(accumulator!) + spaceString + "=")
                    accumulator = pendingBinaryOperation?.perform(with: accumulator!)
                }
            }
        }
    }

    private mutating func performPendingBinaryOperation() {
        if accumulator != nil && pendingBinaryOperation != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }

    private var pendingBinaryOperation: PendingBinaryOperation?

    struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double

        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }

    }

    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }

    var result: Double? {
        get {
            return accumulator
        }
    }

}

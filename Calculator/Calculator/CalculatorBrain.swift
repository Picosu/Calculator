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

	private var accumulator: Double? {
		didSet {
			if accumulator != nil {
				description?.append(spaceString + String(accumulator!))
			}
		}
	}

	var resultIsPending: Bool {
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
			description?.append(spaceString + symbol)
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
					if resultIsPending {
						performPendingBinaryOperation(withDescription: false)
					}
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
				}
                break
            case .equals:
                if accumulator != nil && resultIsPending {
                    accumulator = pendingBinaryOperation?.perform(with: accumulator!)
					let stringToRemove = spaceString + "=" + spaceString + String(accumulator!)
					description = description?.replacingOccurrences(of: stringToRemove, with: "")
					pendingBinaryOperation = nil
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

	private mutating func performPendingBinaryOperation(withDescription shouldAddToDescription: Bool) {
		performPendingBinaryOperation()
		guard let accumulator = accumulator else {
			return
		}
		let stringToRemove = spaceString + String(accumulator)

		description = description?.replacingOccurrences(of: stringToRemove, with: "")
	}

    private var pendingBinaryOperation: PendingBinaryOperation?

    struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double

        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }

    }

	mutating func clear() {
		description = ""
		accumulator = 0.0
		pendingBinaryOperation = nil
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

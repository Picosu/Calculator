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

    // MARK: - Public properties
    var resultIsPending: Bool {
        return pendingBinaryOperation != nil
    }

    var description: String? = "" {
        didSet {
            description?.append(spaceString)
        }
    }
    var result: Double? {
        get {
            return accumulator
        }
    }

    // MARK: - Private properties
    private let spaceString = " "

	private var accumulator: Double?

	private var tupleAccumulator: (value: Double, description: String)?

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
				description?.append(String(accumulator!))

            case .unaryOperation(let function):
                if accumulator != nil {
					if resultIsPending {
						description?.append("\(symbol)(\(String(accumulator!)))")
					} else if description != nil {
						description = "\(symbol)(\(description!))"
					}
                    accumulator = function(accumulator!)
					tupleAccumulator?.description = "\(symbol)(\(tupleAccumulator?.description))"
                }

            case .binaryOperation(let function):
                if accumulator != nil {
					description?.append(String(accumulator!))
					description?.append(symbol)
					tupleAccumulator = (accumulator!, "\(accumulator!) \(symbol)")
					if resultIsPending {
						performPendingBinaryOperation()
					}
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
				}

            case .equals:
				if resultIsPending {
					description?.append(String(accumulator!))
				}
                performPendingBinaryOperation()
//				tupleAccumulator = (accumulator!, description!)
				print(tupleAccumulator!)
            }
        }
    }

    private mutating func performPendingBinaryOperation() {
        if accumulator != nil && pendingBinaryOperation != nil {
			tupleAccumulator?.description.append(spaceString + String(accumulator!))
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
			tupleAccumulator?.value = accumulator!
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

	mutating func clear() {
		accumulator = 0
        description = ""
		pendingBinaryOperation = nil
	}

    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }

}

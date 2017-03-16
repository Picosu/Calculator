//
//  ViewController.swift
//  Calculator
//
//  Created by Maxence de Cussac on 01/03/2017.
//  Copyright © 2017 Maxence de Cussac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	// MARK: - Properties
	static let spaceString = " "
    var userIsInTheMiddleOfTyping = false
	var displayValue: Double {
		get {
			return Double(display.text!)!
		}
		set {
			display.text = String(newValue)
		}
	}
	private var brain = CalculatorBrain()

	// MARK: - Outlets
    @IBOutlet weak var display: UILabel!
	@IBOutlet weak var operations: UILabel!

	// MARK: - Actions
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!

        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if Double(textCurrentlyInDisplay + digit) != nil {
				display.text = textCurrentlyInDisplay + digit
			}
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }

    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }

        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }

        if let result = brain.result {
            displayValue = result
        }

		operations.text = brain.description
		if let description = brain.description, !description.isEmpty {
			operations.text?.append((brain.resultIsPending ? " …" : " ="))
		}
    }

	@IBAction func clear() {
		displayValue = 0
		operations.text = " "
		brain.clear()
		userIsInTheMiddleOfTyping = false
	}

}

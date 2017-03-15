//
//  BorderedButton.swift
//  Calculator
//
//  Created by Maxence DE CUSSAC on 14/03/2017.
//  Copyright © 2017 Maxence de Cussac. All rights reserved.
//

import UIKit

@IBDesignable
class BorderedButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

	@IBInspectable
	var borderWidth: CGFloat = 0.3

	@IBInspectable
	var borderColor: UIColor = UIColor.darkGray

	private func setup() {
		layer.borderWidth = borderWidth
		layer.borderColor = borderColor.cgColor
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		setup()
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	override public func layoutSubviews() {
		super.layoutSubviews()
		setup()
	}

}

//
//  ViewController.swift
//  Calculator
//
//  Created by Brian Morales on 8/30/17.
//  Copyright © 2017 Bamzii. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    
    private func showSizeClasses() -> String {
        let horizontalDescription = traitCollection.horizontalSizeClass.description
        let verticalDescription = traitCollection.verticalSizeClass.description
        return ("Width: \(horizontalDescription)  height: \(verticalDescription)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(showSizeClasses())
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (coordinator) in
            print(self.showSizeClasses())
        }, completion: nil)
        //		print(showSizeClasses())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brain.addUnaryOperation(named: "✅"){ [ unowned self] in
            self.display.textColor = UIColor.green
            return sqrt($0)
        }
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        }
        else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
       
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()

    @IBAction func PerformOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
        }
        userIsInTheMiddleOfTyping = false
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        
        if let result = brain.result {
            displayValue = result
        }
    }
}

extension UIUserInterfaceSizeClass: CustomStringConvertible {
    public var description: String {
        switch self {
        case .compact: return "compact"
        case .regular: return "regular"
        default: return "unspecified"
        }
    }
}

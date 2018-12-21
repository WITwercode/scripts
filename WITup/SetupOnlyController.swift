//
//  SetupOnlyController.swift
//  WITup
//
//  Created by Bradley Ramos and John Wu on 9/27/18.
//  Copyright © 2018 Weinberg IT. All rights reserved.
//

import Cocoa
import Foundation

class SetupOnlyController: NSViewController {
    @IBOutlet weak var firstNameBox: NSTextField!
    @IBOutlet weak var lastNameBox: NSTextField!
    @IBOutlet weak var updates: NSButton!
    @IBOutlet weak var warningLabel: NSTextField!
    @IBOutlet weak var aPass: NSSecureTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func runButtonClicked(_ sender: Any) {
        
        // Finds scripts location by moving back twich from .app bundle location.
        var bundPath = Bundle.main.bundleURL
        bundPath = bundPath.deletingLastPathComponent()
        bundPath = bundPath.deletingLastPathComponent()
        
        // Creates actual location of base script
        let scriptName = "simple_setup.sh"
        let scriptPath = bundPath.path + "/"
        let path = bundPath.path + "/" + scriptName
        
        // checkboxes
        var launch = String()
        switch updates.state {
            case .on:
                launch = "y"
            case .off:
                launch = "n"
            case .mixed:
                print("mixed")
            default: break
        }
        
        warningLabel.stringValue = "Script is running. Please Wait."
        // Run script
        var command = String()
        command = "'" + path + "' '" + firstNameBox.stringValue + "' '" + lastNameBox.stringValue + "' 'nosource' n " + launch + " n n '" + scriptPath + "' '" + aPass.stringValue + "'"

        var error: NSDictionary?
        let scommand = "do shell script \"sudo sh " + command + "\" with administrator " + "privileges"

        NSAppleScript(source: scommand)!.executeAndReturnError(&error)
        print("error1: \(String(describing: error))")
        
        warningLabel.stringValue = "Script has completed running."
    }
}

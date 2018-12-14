//
//  TransferController.swift
//  WITup
//
//  Created by Bradley Ramos and John Wu on 9/20/18.
//  Copyright © 2018 Weinberg IT. All rights reserved.
//

import Cocoa
import Foundation

class TransferController: NSViewController {
    @IBOutlet weak var sourceButton: NSButton!
    @IBOutlet weak var sourceField: NSTextField!
    @IBOutlet weak var firstName: NSTextField!
    @IBOutlet weak var lastName: NSTextField!
    @IBOutlet weak var libraryFiles: NSButton!
    @IBOutlet weak var launchUpdates: NSButton!
    @IBOutlet weak var runCommands: NSButton!
    @IBOutlet weak var aPass: NSSecureTextField!
    @IBOutlet weak var warningLabel: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    @IBAction func selectDirectory(_ sender: NSButton) {
        
        
        
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a directory";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = true;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        dialog.canChooseFiles          = false;
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                sourceField.stringValue = path
            }
        } else {
            // User clicked on "Cancel"
            return
        }
        
    }
    
    // Set up bash commands
    @discardableResult
    func shell(_ args: String...) -> Int32 {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = args
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
    
    @IBAction func runBash(_ sender: Any) {
        
        // Finds scripts location by moving back twich from .app bundle location.
        var bundPath = Bundle.main.bundleURL
        bundPath = bundPath.deletingLastPathComponent()
        bundPath = bundPath.deletingLastPathComponent()
        
        // Creates actual location of base script
        let scriptName = "simple_setup.sh"
        let scriptPath = bundPath.path + "/"
        let path = bundPath.path + "/" + scriptName
        
        // checkboxes
        var lib = String()
        switch libraryFiles.state {
        case .on:
            lib = "y"
        case .off:
            lib = "n"
        case .mixed:
            print("mixed")
        default: break
        }
        var launch = String()
        switch launchUpdates.state {
        case .on:
            launch = "y"
        case .off:
            launch = "n"
        case .mixed:
            print("mixed")
        default: break
        }
        
        // Run script
        warningLabel.stringValue = "Scripts are Currently Running. Please Wait."
        var command = String()
        let oldSource = sourceField.stringValue
        command = "'" + path + "' '" + firstName.stringValue + "' '" + lastName.stringValue + "' '" + oldSource + "' " + lib + " " + launch + " y n '" + scriptPath + "' '" + aPass.stringValue + "'"
        
        var error: NSDictionary?
        
        let scommand = "do shell script \"sudo sh " + command + "\" with administrator " + "privileges"
        
        NSAppleScript(source: scommand)!.executeAndReturnError(&error)
        
 
        print("error2: \(String(describing: error))")
        
        warningLabel.stringValue = "Thanks for using WITup!"
        
        
    }

}

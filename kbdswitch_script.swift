#!/usr/bin/env swift

import Foundation
import Carbon

func listKeyboardLayouts() {
    if let sourceList = TISCreateInputSourceList(nil, false)?.takeRetainedValue() as? [TISInputSource] {
        for source in sourceList {
            if let sourceID = TISGetInputSourceProperty(source, kTISPropertyInputSourceID) {
                let idString = Unmanaged<CFString>.fromOpaque(sourceID).takeUnretainedValue() as String
                print(idString)
            }
        }
    }
}

func changeKeyboardLayout(to layoutID: String) {
    if let sourceList = TISCreateInputSourceList(nil, false)?.takeRetainedValue() as? [TISInputSource] {
        for source in sourceList {
            if let sourceIDRef = TISGetInputSourceProperty(source, kTISPropertyInputSourceID) {
                let sourceID = Unmanaged<CFString>.fromOpaque(sourceIDRef).takeUnretainedValue() as String
                if sourceID == layoutID {
                    TISSelectInputSource(source)
                    print("Keyboard layout changed to: \(layoutID)")
                    return
                }
            }
        }
    }
    print("Error: Layout \(layoutID) not found.")
}

// Main execution
guard CommandLine.arguments.count > 1 else {
    print("Usage:\n  kbdswitch list\n  kbdswitch set <layout_name>")
    exit(1)
}

let command = CommandLine.arguments[1]

switch command {
case "list":
    listKeyboardLayouts()
case "set":
    guard CommandLine.arguments.count > 2 else {
        print("Error: Please provide a layout ID.")
        exit(1)
    }
    changeKeyboardLayout(to: CommandLine.arguments[2])
default:
    print("Unknown command: \(command)")
    exit(1)
}


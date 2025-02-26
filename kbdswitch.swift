#!/usr/bin/env swift

import Carbon
import Foundation

func listKeyboardLayouts() {
    if let sourceList = TISCreateInputSourceList(nil, false)?.takeRetainedValue()
        as? [TISInputSource]
    {
        for source in sourceList {
            if let sourceIDRef = TISGetInputSourceProperty(source, kTISPropertyInputSourceID) {
                let sourceID = unsafeBitCast(sourceIDRef, to: CFString.self) as String
                print(sourceID)
            }
        }
    }
}

func changeKeyboardLayout(to layoutID: String) {
    if let sourceList = TISCreateInputSourceList(nil, false)?.takeRetainedValue()
        as? [TISInputSource]
    {
        for source in sourceList {
            if let sourceIDRef = TISGetInputSourceProperty(source, kTISPropertyInputSourceID) {
                let sourceID = unsafeBitCast(sourceIDRef, to: CFString.self) as String
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

guard CommandLine.arguments.count > 1 else {
    print("Usage:\n  kbdswitch list\n  kbdswitch set <layout_id>")
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

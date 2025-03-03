import Foundation
import Carbon

// Function to get the current keyboard layout
func getCurrentKeyboardLayout() -> String? {
    guard let source = TISCopyCurrentKeyboardInputSource()?.takeUnretainedValue() else {
        return nil
    }
    
    if let sourceCFString = TISGetInputSourceProperty(source, kTISPropertyInputSourceID) {
        return Unmanaged<CFString>.fromOpaque(sourceCFString).takeUnretainedValue() as String
    }
    
    return nil
}

// Function to list available keyboard layouts
func listKeyboardLayouts() {
    if let sourceList = TISCreateInputSourceList(nil, false)?.takeRetainedValue() as? [TISInputSource] {
        for source in sourceList {
            if let sourceCFString = TISGetInputSourceProperty(source, kTISPropertyInputSourceID) {
                let sourceID = Unmanaged<CFString>.fromOpaque(sourceCFString).takeUnretainedValue() as String
                print(sourceID)
            }
        }
    }
}

// Function to set the keyboard layout
func setKeyboardLayout(to layoutID: String) -> Bool {
    guard let sources = TISCreateInputSourceList(nil, false)?.takeRetainedValue() as? [TISInputSource] else {
        return false
    }
    
    for source in sources {
        if let sourceCFString = TISGetInputSourceProperty(source, kTISPropertyInputSourceID) {
            let sourceID = Unmanaged<CFString>.fromOpaque(sourceCFString).takeUnretainedValue() as String
            if sourceID == layoutID {
                TISSelectInputSource(source)
                return true
            }
        }
    }
    
    return false
}

// Function to run as a daemon and listen for commands
func runDaemon() {
    while true {
        guard let input = readLine() else { continue }
        let parts = input.split(separator: " ")

        if parts.count == 1 && parts[0] == "get" {
            if let layout = getCurrentKeyboardLayout() {
                print(layout)
            } else {
                print("error")
            }
        } else if parts.count == 1 && parts[0] == "list" {
            listKeyboardLayouts()
        } else if parts.count == 2 && parts[0] == "set" {
            let success = setKeyboardLayout(to: String(parts[1]))
            print(success ? "ok" : "error")
        }

        fflush(stdout) // Ensure output is immediately flushed
    }
}

// Main execution logic
if CommandLine.arguments.count > 1 {
    let command = CommandLine.arguments[1]

    switch command {
    case "get":
        if let layout = getCurrentKeyboardLayout() {
            print(layout)
            exit(0)
        } else {
            print("error")
            exit(1)
        }

    case "list":
        listKeyboardLayouts()
        exit(0)

    case "set":
        guard CommandLine.arguments.count > 2 else {
            print("Error: Please provide a layout ID.")
            exit(1)
        }
        let success = setKeyboardLayout(to: CommandLine.arguments[2])
        exit(success ? 0 : 1)

    case "daemon":
        runDaemon()

    default:
        print("Unknown command: \(command)")
        exit(1)
    }
} else {
    print("""
    Usage:
      kbdswitch get               - Get the current keyboard layout
      kbdswitch list              - List all available keyboard layouts
      kbdswitch set <layout_id>   - Change the keyboard layout
      kbdswitch daemon            - Run in daemon mode (for Neovim integration)
    """)
    exit(1)
}

#!/usr/bin/swift

// FILE: swift-copy-testresources.sh
// verify swift path with "which -a swift"
// macOS: /usr/bin/swift 
// Ubuntu: /opt/swift/current/usr/bin/swift 

import Foundation

func copyTestResources() {
    let argv = ProcessInfo.processInfo.arguments
//     for i in 0..<argv.count {
//         print("argv[\(i)] = \(argv[i])")
//     }
    
    let pwd = argv[argv.count-1]
    print("Executing swift-copy-testresources")
    print("  PWD=\(pwd)")
    
    let fm = FileManager.default
    
    let pwdUrl = URL(fileURLWithPath: pwd, isDirectory: true)
    let srcUrl = pwdUrl
        .appendingPathComponent("TestResources", isDirectory: true)
    let dstUrl = pwdUrl
        .appendingPathComponent(".build", isDirectory: true)
        .appendingPathComponent("TestResources", isDirectory: true)
    
    do {
        let contents = try fm.contentsOfDirectory(at: srcUrl, includingPropertiesForKeys: [])
        do { try fm.removeItem(at: dstUrl) } catch { }
        try fm.createDirectory(at: dstUrl, withIntermediateDirectories: true)
        for fromUrl in contents {
            try fm.copyItem(
                at: fromUrl, 
                to: dstUrl.appendingPathComponent(fromUrl.lastPathComponent)
            )
        }
    } catch {
        print("  SKIP TestResources not copied. ")
        return
    }
            
    print("  SUCCESS TestResources copy completed.\n  FROM \(srcUrl)\n  TO \(dstUrl)")
}

copyTestResources()

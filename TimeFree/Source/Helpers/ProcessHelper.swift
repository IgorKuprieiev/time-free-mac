//
//  ProcessHelper.swift
//  TimeFree
//
//  Created by Oleksii Naboichenko on 9/1/16.
//  Copyright © 2016 Oleksii Naboichenko. All rights reserved.
//

import Foundation

typealias ProcessOutput = (terminationStatus: Int?, output: String?, error: String?)

@discardableResult
func executeShellCommand(_ command: String) -> ProcessOutput {
    guard command.characters.count > 0 else {
        return ProcessOutput(nil, nil, "command is not valid")
    }
    
    return launchProcess("/bin/sh", arguments: ["-c", command])
}

@discardableResult
func executeAppleScript(path: String, scriptArguments: [String]? = nil) -> ProcessOutput {
    var arguments = [path]
    if scriptArguments != nil {
        arguments.append(contentsOf: scriptArguments!)
    }
    
    return launchProcess("/usr/bin/osascript", arguments: arguments)
}

@discardableResult
func launchProcess(_ launchPath: String, arguments: [String]? = nil) -> ProcessOutput {
    guard launchPath.characters.count > 0 else {
        return ProcessOutput(nil, nil, "launchPath is not valid")
    }
    
    let standardOutput = Pipe()
    let standardError = Pipe()
    
    //Create process
    let process = Process()
    process.launchPath = launchPath
    process.arguments = arguments
    process.standardOutput = standardOutput
    process.standardError = standardError
    
    //Run process
    process.launch()
    process.waitUntilExit()
    
    //Get output info
    var appleScriptExecuteOutput = ProcessOutput(Int(process.terminationStatus), nil, nil)
    
    let outputData = standardOutput.fileHandleForReading.readDataToEndOfFile()
    appleScriptExecuteOutput.output = String(bytes: outputData, encoding: .utf8)
    
    let errorData = standardError.fileHandleForReading.readDataToEndOfFile()
    appleScriptExecuteOutput.error = String(bytes: errorData, encoding: .utf8)
    
    return appleScriptExecuteOutput
}

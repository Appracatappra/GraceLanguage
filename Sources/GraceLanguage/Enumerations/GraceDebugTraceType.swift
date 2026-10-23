//
//  File.swift
//  GraceLanguage
//
//  Created by Kevin Mullins on 10/23/26.
//

import Foundation

/// Defines the types of debug traces that can be logged.
public enum GraceDebugTraceType:String, CaseIterable {
    /// A generic log trace.
    case generic
    
    /// Trace locating of variables.
    case variableLocation
    
    /// Trace location of function.
    case functionLocation
    
    /// Trace location of exnumerations.
    case enumLocation
    
    /// Trace location of containers.
    case containerLocation
    
    /// Trace global instruction execution.
    case globalInstruction
    
    /// Trace function execution.
    case functionExe
    
    /// Trace array execution.
    case arrayExe
    
    /// Trace constant execution.
    case constantExe
    
    /// Trace enumeration execution.
    case enumExe
    
    /// Trace formula execution.
    case formulaExe
    
    /// Trace new structure execution.
    case newExe
    
    /// Trace not execution.
    case notExe
    
    /// Trace variable execution.
    case variableExe
    
    /// Trace call execution.
    case callExe
    
    /// Trace loop execution.
    case loopExe
    
    /// Trace conditionExe.
    case conditionExe
    
    /// Trace return execution.
    case returnExe
}

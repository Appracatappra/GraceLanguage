//
//  GraceAbortable.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/30/23.
//

import Foundation

/// Defines a class that can be aborted by a Grace `return` command.
public protocol GraceAbortable {
    
    /// If `true`, stop executing `GraceInstructions` and return to the caller.
    var shouldAbort:Bool {get set}
    
    /// A `GraceVariable` holding the results to return to the caller.
    var returnResult:GraceVariable? {get set}
}

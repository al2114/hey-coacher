//
//  RemoteEngine.swift
//  hey-coacher
//
//  Created by Andrew Li on 30/05/2017.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import Foundation

import UIKit

func mod(_ a: Int, _ n: Int) -> Int {
  precondition(n > 0, "modulus must be positive")
  let r = a % n
  return r >= 0 ? r : r + n
}

extension String {
    func deleteSpaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    func deleteHTMLTag() -> String {
        return self.replacingOccurrences(of:"<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
    }
    func deleteLines() -> String {
        return components(separatedBy: CharacterSet.newlines).joined()
    }
    mutating func formatting() -> String{
        self = self.deleteLines()
        self = self.deleteSpaces()
        self = self.deleteHTMLTag()
        return self
    }
    mutating func format() -> String{
        self = self.deleteLines()
        self = self.deleteHTMLTag()
        return self
    }
}

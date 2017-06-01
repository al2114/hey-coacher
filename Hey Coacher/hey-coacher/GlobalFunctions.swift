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

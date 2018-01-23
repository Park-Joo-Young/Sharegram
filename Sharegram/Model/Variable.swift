//
//  Variable.swift
//  Sharegram
//
//  Created by apple on 2018. 1. 10..
//  Copyright © 2018년 박주영. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class variable {
 // 공통적으로 쓰는 변수들 여따가
    var lat : Double = 0
    var lon : Double = 0
}

struct HashtagTokenizer : TokenizerType, DefaultTokenizerType {
    func tokenCanStart(with scalar: UnicodeScalar) -> Bool {
        return scalar == UnicodeScalar(35)
    }
    public func tokenCanTake(_ scalar: UnicodeScalar) -> Bool {
        return CharacterSet.letters.contains(scalar)
    }
}
//protocol Function {
//    func
//}


//
//  NetworkChecks.swift
//  ParseChat
//
//  Created by Linus Liang on 11/4/15.
//  Copyright © 2015 Linus Liang. All rights reserved.
//

import Foundation
import UIKit
import ReachabilitySwift

func networkIsAvailable() -> Bool {
    do {
        let reachability = try Reachability.reachabilityForInternetConnection()
        if reachability.isReachable() {return true}
        if reachability.isReachableViaWiFi() {return true}
        if reachability.isReachableViaWWAN() {return true}
    } catch {
        return false
    }
    return false
}
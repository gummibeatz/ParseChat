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
        if reachability.isReachable() {
            print("reachable by wifi")
            return true
        }
        if reachability.isReachableViaWiFi() {
            print("is Reachable")
            return true
        }
        if reachability.isReachableViaWWAN() {
            print("reachable by wifi")
            return true
        }
    } catch {
        print("unreachable")
        return false
    }
    print("unreachable")
    return false
}
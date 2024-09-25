//
//  Extension +  Double.swift
//  Runner
//
//  Created by Chondro on 22/05/23.
//

import Foundation

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
    var secondsOfDouble: Int {
        return Int(self) % 60
    }

    var minutesOfDouble: Int {
        return (Int(self) / 60 ) % 60
    }

    var hoursOfDouble: Int {
        return Int(self) / 3600
    }
    
    
    
    var stringTimeDouble: String {
        if hoursOfDouble != 0 {
            if hoursOfDouble < 9 {
                if minutesOfDouble < 10 {
                    if secondsOfDouble < 10 {
                        return "0\(hoursOfDouble):0\(minutesOfDouble):0\(secondsOfDouble)"
                    } else {
                        return "0\(hoursOfDouble):0\(minutesOfDouble):\(secondsOfDouble)"
                    }
                } else {
                    if secondsOfDouble < 10 {
                        return "0\(hoursOfDouble):\(minutesOfDouble):0\(secondsOfDouble)"
                    } else {
                        return "0\(hoursOfDouble):\(minutesOfDouble):\(secondsOfDouble)"
                    }
                }
            } else {
                if minutesOfDouble < 10 {
                    if seconds < 10 {
                        return "\(hoursOfDouble):0\(minutesOfDouble):0\(secondsOfDouble)"
                    } else {
                        return "\(hoursOfDouble):0\(minutesOfDouble):\(secondsOfDouble)"
                    }
                } else {
                    if secondsOfDouble < 10 {
                        return "\(hoursOfDouble):\(minutesOfDouble):0\(secondsOfDouble)"
                    } else {
                        return "\(hoursOfDouble):\(minutesOfDouble):\(secondsOfDouble)"
                    }
                }
            }
            
        } else if minutesOfDouble != 0 {
            if minutesOfDouble < 10 {
                if secondsOfDouble < 10 {
                    return "0\(minutesOfDouble):0\(secondsOfDouble)"
                } else {
                    return "0\(minutesOfDouble):\(secondsOfDouble)"
                }
            } else {
                if secondsOfDouble < 10 {
                    return "\(minutesOfDouble):0\(secondsOfDouble)"
                } else {
                    return "\(minutesOfDouble):\(secondsOfDouble)"
                }
            }
        }  else {
            if secondsOfDouble < 10 {
                return "00:0\(minutesOfDouble):0\(secondsOfDouble)"
            } else {
                return "00:0\(minutesOfDouble):\(secondsOfDouble)"
            }
            
        }
    }
}


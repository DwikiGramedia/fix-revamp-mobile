//
//  Extension + TimeInterval.swift
//  Runner
//
//  Created by Chondro on 22/05/23.
//

extension TimeInterval {
    var milliseconds: Int {
        return Int((truncatingRemainder(dividingBy: 1)) * 1000)
    }

    var seconds: Int {
        return Int(self) % 60
    }

    var minutes: Int {
        return (Int(self) / 60 ) % 60
    }

    var hours: Int {
        return Int(self) / 3600
    }
    
    var totalSeconds:Int {
        return ((hours * 60) + minutes) * 60 + seconds
    }

    var stringTime: String {
        if hours != 0 {
            if hours < 9 {
                if minutes < 10 {
                    if seconds < 10 {
                        return "0\(hours):0\(minutes):0\(seconds)"
                    } else {
                        return "0\(hours):0\(minutes):\(seconds)"
                    }
                } else {
                    if seconds < 10 {
                        return "0\(hours):\(minutes):0\(seconds)"
                    } else {
                        return "0\(hours):\(minutes):\(seconds)"
                    }
                }
            } else {
                if minutes < 10 {
                    if seconds < 10 {
                        return "\(hours):0\(minutes):0\(seconds)"
                    } else {
                        return "\(hours):0\(minutes):\(seconds)"
                    }
                } else {
                    if seconds < 10 {
                        return "\(hours):\(minutes):0\(seconds)"
                    } else {
                        return "\(hours):\(minutes):\(seconds)"
                    }
                }
            }
            
        } else if minutes != 0 {
            if minutes < 10 {
                if seconds < 10 {
                    return "0\(minutes):0\(seconds)"
                } else {
                    return "0\(minutes):\(seconds)"
                }
            } else {
                if seconds < 10 {
                    return "\(minutes):0\(seconds)"
                } else {
                    return "\(minutes):\(seconds)"
                }
            }
        }  else {
            if seconds < 10 {
                return "00:0\(minutes):0\(seconds)"
            } else {
                return "00:0\(minutes):\(seconds)"
            }
            
        }
    }
}

extension String {
    func convertToTimeInterval() -> TimeInterval {
            guard self != "" else {
                return 0
            }

            var interval:Double = 0

            let parts = self.components(separatedBy: ":")
            for (index, part) in parts.reversed().enumerated() {
                interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
            }

            return interval
        }
    func timeInterval(from string: String) -> TimeInterval? {
        let components = string.components(separatedBy: ":").map { Double($0) }
        guard
            components.count == 3,
            let hours = components[0],
            let minutes = components[1],
            let seconds = components[2]
        else { return nil }

        return ((hours * 60) + minutes) * 60 + seconds
    }
    }


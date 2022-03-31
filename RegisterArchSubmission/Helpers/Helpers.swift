import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(to places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

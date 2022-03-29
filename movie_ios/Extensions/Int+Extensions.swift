import Foundation

extension Int {
    func secondsToHoursMinutes(_ minutes: Int) -> (Int, Int) {
        return (minutes / 60, (minutes % 60))
    }
    
    func formatMinutesToHoursMinutes() -> String {
        let minutes = self
        let (h, m) = secondsToHoursMinutes(minutes)
        return "\(h) Hours, \(m) Minutes"
    }
}

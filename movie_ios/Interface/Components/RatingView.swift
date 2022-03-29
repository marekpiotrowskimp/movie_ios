import UIKit

final class RatingView: UIView {

    // MARK: RatingView properties
    
    private var color: UIColor = UIColor.clear
    private var backgroundTrackColor: UIColor = UIColor.clear
    private var percentage: CGFloat = 100
    var rating: CGFloat {
        get { percentage }
        set {
            if newValue < 0 {
                percentage = 0
            } else if newValue > 100 {
                percentage = 100
            } else {
                percentage = newValue
            }
            setNeedsDisplay()
        }
    }

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor.clear
    }
    
    // MARK: - setup UI

    override func draw(_ rect: CGRect) {
        calculateColors()
        drawPercentage(rect)
        drawText(rect)
        return
    }
    
    private func drawPercentage(_ rect: CGRect) {
        let center: CGPoint = CGPoint(x: rect.midX, y: rect.midY)
        let radius: CGFloat = rect.width / 2
        var pathWidth: CGFloat = 5
        
        if radius < pathWidth {
            pathWidth = radius
        }
        let (trackStartingPoint, trackPercentageEndingPoint) = self.calculateStartAndEnd()

        let backgroundTrackPath = UIBezierPath(arcCenter: center, radius: radius - (pathWidth / 2), startAngle: trackStartingPoint, endAngle: 2.0 * .pi, clockwise: true)
        backgroundTrackPath.lineWidth = pathWidth
        self.backgroundTrackColor.setStroke()
        backgroundTrackPath.stroke()

        let percentageTrackPath = UIBezierPath(arcCenter: center, radius: radius - (pathWidth / 2), startAngle: trackStartingPoint, endAngle: trackPercentageEndingPoint, clockwise: true)
        percentageTrackPath.lineWidth = pathWidth
        percentageTrackPath.lineCapStyle = .round
        self.color.setStroke()
        percentageTrackPath.stroke()
    }
    
    private func drawText(_ rect: CGRect) {
        let percentageString = "\(Int(self.percentage))"
        let size  = Fonts.bold12.sizeOfString(string: percentageString, constrainedToWidth: Double(self.frame.width))
        percentageString.draw(at: CGPoint(x: rect.midX - size.width / 2 - 3, y: rect.midY - size.height / 2), withAttributes: [
            NSAttributedString.Key.font: Fonts.bold12,
            NSAttributedString.Key.foregroundColor: UIColor(named: "white") ?? UIColor.clear])
        
        let percentageStr = "%"
        percentageStr.draw(at: CGPoint(x: rect.midX + size.width / 2 - 3, y: rect.midY - size.height / 2), withAttributes: [
            NSAttributedString.Key.font: Fonts.bold8,
            NSAttributedString.Key.foregroundColor: UIColor(named: "white") ?? UIColor.clear])
    }
    
    // MARK: - support methods
    
    private func calculateStartAndEnd() -> (trackStartingPoint: CGFloat, trackPercentageEndingPoint: CGFloat) {
        let initialPoint: CGFloat = -25
        let trueFillPercentage = self.percentage + initialPoint
        let startPoint: CGFloat = ((2 * .pi) / 100) * (CGFloat(initialPoint))
        let endPoint: CGFloat = ((2 * .pi) / 100) * (CGFloat(trueFillPercentage))
        return(startPoint, endPoint)
    }
    
    private func calculateColors() {
        color = self.percentage < 50 ? UIColor(named: "yellow") ?? UIColor.clear : UIColor(named: "green") ?? UIColor.clear
        
        backgroundTrackColor = self.percentage < 50 ? UIColor(named: "yellow_dark") ?? UIColor.clear : UIColor(named: "green_dark") ?? UIColor.clear
    }
}

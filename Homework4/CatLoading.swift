import UIKit

class CustomSpinnerView: UIView {

    private let spinnerLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSpinner()
        startAnimating()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSpinner()
        startAnimating()
    }

    private func setupSpinner() {
        let radius: CGFloat = 25
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let circularPath = UIBezierPath(arcCenter: center,
                                        radius: radius,
                                        startAngle: 0,
                                        endAngle: 2 * .pi,
                                        clockwise: true)

        spinnerLayer.path = circularPath.cgPath
        spinnerLayer.strokeColor = UIColor.gray.cgColor
        spinnerLayer.lineWidth = 4
        spinnerLayer.fillColor = UIColor.clear.cgColor
        spinnerLayer.lineCap = .round
        layer.addSublayer(spinnerLayer)
    }

    private func startAnimating() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: 2 * Double.pi)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = .infinity
        layer.add(rotation, forKey: "rotationAnimation")
    }
}

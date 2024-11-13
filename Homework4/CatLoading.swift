import UIKit
// https://www.hackingwithswift.com/example-code/uikit/how-to-use-uiactivityindicatorview-to-show-a-spinner-when-work-is-happening
// https://developer.apple.com/documentation/uikit/uiactivityindicatorview
class CustomSpinnerView: UIView {
    
    private let activityIndicator: UIActivityIndicatorView
    
    init(style: UIActivityIndicatorView.Style = .large) {
        self.activityIndicator = UIActivityIndicatorView(style: style)
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        self.activityIndicator = UIActivityIndicatorView(style: .large)
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
        isHidden = false
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
        isHidden = true
    }
}

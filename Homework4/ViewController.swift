import UIKit
import Combine

// https://www.ralfebert.com/ios-examples/uikit/uitableviewcontroller/
// https://developer.apple.com/tutorials/app-dev-training/creating-a-list-view
// https://stackoverflow.com/questions/34565570/conforming-to-uitableviewdelegate-and-uitableviewdatasource-in-swift
class ViewController: UIViewController {
    
    private let imageView = UIImageView()
    private let likeButton = UIButton(type: .system)
    private let dislikeButton = UIButton(type: .system)
    private let spinnerView = CustomSpinnerView()
    private let viewModel = CatViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchCatImage()
    }
    
    private func setupUI() {
        view.backgroundColor = .white

        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinnerView)
        
        NSLayoutConstraint.activate([
            spinnerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        ])

        setupButtons()
        // https://poojababusingh.medium.com/from-taps-to-swipes-20614644c695
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        imageView.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        imageView.addGestureRecognizer(swipeRight)

        imageView.isUserInteractionEnabled = true
    }
    
    private func setupButtons() {
        likeButton.setTitle("❤️", for: .normal)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        likeButton.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(likeButton)
        
        dislikeButton.setTitle("❌", for: .normal)
        dislikeButton.addTarget(self, action: #selector(dislikeButtonTapped), for: .touchUpInside)
        dislikeButton.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        dislikeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dislikeButton)
        
        NSLayoutConstraint.activate([
            likeButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 20),
            likeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            likeButton.widthAnchor.constraint(equalToConstant: 200),
            likeButton.heightAnchor.constraint(equalToConstant: 200),
            dislikeButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -20),
            dislikeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            dislikeButton.widthAnchor.constraint(equalToConstant: 200),
            dislikeButton.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$catImage
            .sink { [weak self] image in
                self?.imageView.image = image
                self?.imageView.isHidden = (image == nil)
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .sink { [weak self] isLoading in
                isLoading ? self?.spinnerView.startAnimating() : self?.spinnerView.stopAnimating()
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .sink { errorMessage in
                if let errorMessage = errorMessage {
                    print("Error: \(errorMessage)")
                }
            }
            .store(in: &cancellables)
    }
    
    @objc private func likeButtonTapped() {
        viewModel.likeCat()
        animateImageOffScreen(direction: .right)
        if let currentImage = imageView.image,
           let likedVC = (tabBarController?.viewControllers?[2] as? UINavigationController)?.topViewController as? LikedViewController {
            likedVC.addLikedImage(currentImage)
        }
    }
    
    @objc private func dislikeButtonTapped() {
        viewModel.dislikeCat()
        animateImageOffScreen(direction: .left)
    }
    
    @objc private func handleSwipeLeft() {
        dislikeButtonTapped()
    }
    
    @objc private func handleSwipeRight() {
        likeButtonTapped()
    }
    // https://developer.apple.com/documentation/uikit/uiswipegesturerecognizer/direction
    private func animateImageOffScreen(direction: UISwipeGestureRecognizer.Direction) {
        let translationX: CGFloat = direction == .right ? view.bounds.width : -view.bounds.width
        UIView.animate(
            withDuration: 0.5, animations: {
                self.imageView.transform = CGAffineTransform(translationX: translationX, y: 0)
            }, completion: { [weak self] _ in
                self?.imageView.transform = .identity
                self?.viewModel.fetchCatImage()
            }
        )
    }
}

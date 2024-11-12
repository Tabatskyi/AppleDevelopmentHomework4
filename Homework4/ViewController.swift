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
    private let catAPIService = CatAPIService()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadCatImage()
    }

    private func setupUI() {
        view.backgroundColor = .white

        spinnerView.frame = CGRect(x: view.center.x - 25, y: view.center.y - 25, width: 50, height: 50)
        view.addSubview(spinnerView)

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
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(likeButton)

        NSLayoutConstraint.activate([
            likeButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -20),
            likeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            likeButton.widthAnchor.constraint(equalToConstant: 50),
            likeButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        dislikeButton.setTitle("💔", for: .normal)
        dislikeButton.addTarget(self, action: #selector(dislikeButtonTapped), for: .touchUpInside)
        dislikeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dislikeButton)

        NSLayoutConstraint.activate([
            dislikeButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 20),
            dislikeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            dislikeButton.widthAnchor.constraint(equalToConstant: 50),
            dislikeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func loadCatImage() {
        spinnerView.isHidden = false
        imageView.isHidden = true

        catAPIService.fetchCats(limit: 1, format: "jpg", breedID: nil)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure = completion {
                    print("Error loading cat image")
                    self?.spinnerView.isHidden = true
                }
            }, receiveValue: { [weak self] cats in
                if let url = URL(string: cats.first?.url ?? "") {
                    self?.downloadImage(from: url)
                }
            })
            .store(in: &cancellables)
    }

    private func downloadImage(from url: URL) {
        catAPIService.fetchImage(at: url)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] image in
                self?.spinnerView.isHidden = true
                self?.imageView.isHidden = false
                self?.imageView.image = image
            })
            .store(in: &cancellables)
    }

    @objc private func likeButtonTapped() {
        print("Liked the cat!")
        animateImageOffScreen(direction: .right)
    }

    @objc private func dislikeButtonTapped() {
        print("Disliked the cat!")
        animateImageOffScreen(direction: .left)
    }

    @objc private func handleSwipeLeft() {
        dislikeButtonTapped()
    }

    @objc private func handleSwipeRight() {
        likeButtonTapped()
    }

    private func animateImageOffScreen(direction: UISwipeGestureRecognizer.Direction) {
        let translationX: CGFloat = direction == .right ? view.bounds.width : -view.bounds.width
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.transform = CGAffineTransform(translationX: translationX, y: 0)
        }) { _ in
            self.imageView.transform = .identity
            self.loadCatImage()
        }
    }
}

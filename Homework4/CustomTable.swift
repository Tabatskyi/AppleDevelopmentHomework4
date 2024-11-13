import UIKit
import Combine

// https://www.waldo.com/blog/how-to-use-uitableviewcell
class BreedsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView()
    private let viewModel = BreedsViewModel()
    private let spinnerView = CustomSpinnerView()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Cat Breeds"
        view.backgroundColor = .white
        
        setupTableView()
        bindViewModel()
        
        viewModel.loadBreeds()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BreedsTableCell.self, forCellReuseIdentifier: "BreedCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func bindViewModel() {
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinnerView)
        
        NSLayoutConstraint.activate([
            spinnerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        viewModel.$breeds
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$breedImages
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.spinnerView.startAnimating()
                    self?.tableView.isHidden = true
                } else {
                    self?.spinnerView.stopAnimating()
                    self?.tableView.reloadData()
                    self?.tableView.isHidden = false
                }
            }
            .store(in: &cancellables)
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.breeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BreedCell", for: indexPath) as? BreedsTableCell else {
            return UITableViewCell()
        }
        
        let breed = viewModel.breeds[indexPath.row]
        let breedImage = viewModel.breedImages[breed.id] ?? UIImage(systemName: "photo")!
        
        cell.configure(with: breed, breedImage)
        
        return cell
    }
}

class BreedsTableCell: UITableViewCell {
    private let breedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let breedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(breedImageView)
        contentView.addSubview(breedLabel)

        // https://www.hackingwithswift.com/example-code/uikit/how-to-activate-multiple-auto-layout-constraints-using-activate
        NSLayoutConstraint.activate([
            breedImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            breedImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            breedImageView.widthAnchor.constraint(equalToConstant: 40),
            breedImageView.heightAnchor.constraint(equalToConstant: 40),

            breedLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            breedLabel.leadingAnchor.constraint(equalTo: breedImageView.trailingAnchor, constant: 10)
        ])
    }

    func configure(with breed: Breed, _ image: UIImage) {
        breedImageView.image = image
        breedLabel.text = breed.name
    }
}

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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BreedCell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "BreedCell", for: indexPath)
        
        let breed = viewModel.breeds[indexPath.row]
        cell.textLabel?.text = breed.name
        cell.imageView?.image = viewModel.breedImages[breed.id] ?? UIImage(systemName: "photo")
        
        return cell
    }
}

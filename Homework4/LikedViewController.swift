import UIKit

class LikedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView()
    private var likedImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Liked Images"
        view.backgroundColor = .white
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LikedImageCell.self, forCellReuseIdentifier: "LikedImageCell")
        tableView.rowHeight = 200 
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func addLikedImage(_ image: UIImage) {
        likedImages.append(image)
        tableView.reloadData()
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LikedImageCell", for: indexPath) as? LikedImageCell else {
            return UITableViewCell()
        }
        let image = likedImages[indexPath.row]
        cell.configure(with: image)
        return cell
    }
}

class LikedImageCell: UITableViewCell {
    
    let likedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(likedImageView)
        NSLayoutConstraint.activate([
            likedImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            likedImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            likedImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            likedImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func configure(with image: UIImage) {
        likedImageView.image = image
    }
}

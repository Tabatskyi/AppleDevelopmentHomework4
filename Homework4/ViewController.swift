import UIKit

// https://www.ralfebert.com/ios-examples/uikit/uitableviewcontroller/
// https://developer.apple.com/tutorials/app-dev-training/creating-a-list-view
// https://stackoverflow.com/questions/34565570/conforming-to-uitableviewdelegate-and-uitableviewdatasource-in-swift
class StudentListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let studentsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()

    private let tableView = UITableView()
    private var students: [Student] = []
    private let profileImages = ["person1", "person2", "person3", "person4", "person5", "person6"]

    init(title: String, students: [Student]) {
        super.init(nibName: nil, bundle: nil)
        self.students = students
        studentsLabel.text = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(studentsLabel)
        studentsLabel.translatesAutoresizingMaskIntoConstraints = false
        studentsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        studentsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        studentsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        studentsLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: studentsLabel.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StudentCell.self, forCellReuseIdentifier: "StudentCell")
        tableView.rowHeight = 80
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
                .dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
                as? StudentCell else {
            return UITableViewCell()
        }
        let student = students[indexPath.row]
        let picture = profileImages[indexPath.row % profileImages.count]
        cell.configure(with: student, picture)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedStudent = students[indexPath.row]
        let selectedProfileImage = profileImages[indexPath.row % profileImages.count]

        let detailVC = StudentDetailViewController()
        detailVC.student = selectedStudent
        detailVC.profileImage = selectedProfileImage
        detailVC.allStudents = students

        navigationController?.pushViewController(detailVC, animated: true)
    }
}

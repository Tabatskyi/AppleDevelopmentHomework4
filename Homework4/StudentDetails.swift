import UIKit

class StudentDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var student: Student?
    var profileImage: String?
    var allStudents: [Student] = []

    private let subjectsTableView = UITableView()
    private var subjects: [(subject: String, score: Int)] = []

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let ageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        displayStudentDetails()
    }

    private func setupUI() {
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(ageLabel)
        view.addSubview(subjectsTableView)

        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),

            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            ageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            ageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        subjectsTableView.translatesAutoresizingMaskIntoConstraints = false
        subjectsTableView.delegate = self
        subjectsTableView.dataSource = self
        subjectsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SubjectCell")

        NSLayoutConstraint.activate([
            subjectsTableView.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 20),
            subjectsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subjectsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            subjectsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func displayStudentDetails() {
        guard let student = student else { return }

        profileImageView.image = UIImage(named: profileImage ?? "defaultProfile")
        nameLabel.text = student.name
        ageLabel.text = "Age: \(student.age ?? 0)"

        if let scores = student.scores {
            subjects = scores.map { ($0.key, $0.value ?? 0) }
        }

        subjectsTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectCell", for: indexPath)
        let subject = subjects[indexPath.row]
        cell.textLabel?.text = "\(subject.subject): \(subject.score)"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.backgroundColor = .lightGray
        cell.textLabel?.textAlignment = .center
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSubject = subjects[indexPath.row].subject
        let filteredStudents = allStudents.filter { $0.scores?.keys.contains(selectedSubject) == true }

        let subjectStudentsVC = StudentListViewController(title: selectedSubject, students: filteredStudents)
        navigationController?.pushViewController(subjectStudentsVC, animated: true)
    }
}

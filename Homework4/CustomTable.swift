import UIKit

// https://www.waldo.com/blog/how-to-use-uitableviewcell
class StudentCell: UITableViewCell {
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let ageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let scholarshipLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let scholarshipIndicator: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ageLabel)
        contentView.addSubview(scoreLabel)
        contentView.addSubview(scholarshipLabel)
        contentView.addSubview(scholarshipIndicator)

// https://www.hackingwithswift.com/example-code/uikit/how-to-activate-multiple-auto-layout-constraints-using-activate
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),

            ageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            ageLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),

            scoreLabel.centerYAnchor.constraint(equalTo: ageLabel.centerYAnchor),
            scoreLabel.leadingAnchor.constraint(equalTo: ageLabel.trailingAnchor, constant: 20),

            scholarshipLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            scholarshipLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60),

            scholarshipIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
            scholarshipIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -55),
            scholarshipIndicator.widthAnchor.constraint(equalToConstant: 10),
            scholarshipIndicator.heightAnchor.constraint(equalToConstant: 10)
        ])
    }

    func configure(with student: Student, _ profilePicture: String) {
        profileImageView.image = UIImage(named: profilePicture)

        nameLabel.text = student.name
        ageLabel.text = "Age: \(student.age ?? 0)"
        scoreLabel.text = "Score: \(student.average())"
        scholarshipLabel.text = "Shoolarship: "
        scholarshipIndicator.backgroundColor = student.hasScholarship == true ? .green : .red
    }
}

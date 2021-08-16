//
//  ToDoListViewController.swift
//  AccessiblitySample
//
//  Created by Delma Song on 2021/08/12.
//

import UIKit

protocol ToDoListTableViewCellDelegate: AnyObject {
    func checked(_ cell: UITableViewCell)
}

final class ToDoListViewController: UIViewController {

    private var toDoLists: [Task] = [
        Task(id: 0, title: "apple watch", isChecked: false),
        Task(id: 1, title: "iPad", isChecked: false),
        Task(id: 2, title: "iMac", isChecked: true),
    ]

    private var inputTopPadding: NSLayoutConstraint?
    private var isInputContainerOpend: Bool = false

    private lazy var inputContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        view.addSubview(submitButton)
        return view
    }()

    private lazy var textField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.borderStyle = .line
        view.autocorrectionType = .no
        return view
    }()

    private lazy var submitButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .gray
        view.setTitle("submit", for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleEdgeInsets = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        view.clipsToBounds = true
        view.layer.cornerRadius = 4

        let gesture = UITapGestureRecognizer(target: self, action: #selector(submitButtonDidTapped))
        view.addGestureRecognizer(gesture)
        return view
    }()

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(ToDoListTableViewCell.self, forCellReuseIdentifier: "ToDoListTableViewCell")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(addToDoList)
        )

        view.addSubview(inputContainer)
        view.addSubview(tableView)
        configureConstraints()
    }

    private func configureConstraints() {
        inputTopPadding = inputContainer.topAnchor.constraint(equalTo: view.topAnchor)

        let layouts = [
            inputTopPadding,
            inputContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputContainer.heightAnchor.constraint(equalToConstant: 40),

            textField.topAnchor.constraint(equalTo: inputContainer.topAnchor),
            textField.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 20),
            textField.heightAnchor.constraint(equalToConstant: 22),
            textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),

            submitButton.topAnchor.constraint(equalTo: textField.topAnchor),
            submitButton.heightAnchor.constraint(equalTo: textField.heightAnchor),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            submitButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 8),

            tableView.topAnchor.constraint(equalTo: inputContainer.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]

        layouts.forEach { $0?.isActive = true }
    }

    @objc private func addToDoList() {
        UIView.animate(withDuration: 0.3) {
            self.inputTopPadding?.constant = self.isInputContainerOpend ? 0 : 80
            self.view.layoutIfNeeded()
        }
        isInputContainerOpend.toggle()
        toggleAddButton()
    }

    @objc private func submitButtonDidTapped() {
        guard let title = textField.text else { return }
        let task = Task(id: toDoLists.count + 1, title: title, isChecked: false)
        toDoLists.insert(task, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        textField.text = ""
    }

    private func toggleAddButton() {
        navigationItem.rightBarButtonItem?.image = isInputContainerOpend ? UIImage(systemName: "minus") : UIImage(systemName: "plus")
        view.layoutIfNeeded()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoLists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ToDoListTableViewCell",
            for: indexPath
        ) as! ToDoListTableViewCell
        cell.configure(task: toDoLists[indexPath.row])
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

// MARK: - ToDoListTableViewCellDelegate

extension ToDoListViewController: ToDoListTableViewCellDelegate {
    func checked(_ cell: UITableViewCell) {
        guard let cell = cell as? ToDoListTableViewCell,
              let indexPath = tableView.indexPath(for: cell) else { return }

        toDoLists[indexPath.row].isChecked.toggle()
        let movedTask = toDoLists[indexPath.row]

        tableView.moveRow(
            at: indexPath,
            to: IndexPath(
                row: movedTask.isChecked ? toDoLists.count - 1 : 0,
                section: 0
            )
        )

        toDoLists.remove(at: indexPath.row)
        toDoLists.insert(movedTask, at: movedTask.isChecked ? toDoLists.count : 0)
    }
}

// MARK: - ToDoListTableViewCell

final class ToDoListTableViewCell: UITableViewCell {
    weak var delegate: ToDoListTableViewCellDelegate?

    private lazy var checkButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "square"), for: .normal)
        view.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        view.translatesAutoresizingMaskIntoConstraints = false
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(checkButtonDidTapped))
        view.addGestureRecognizer(recognizer)
        return view
    }()

    private(set) lazy var label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(task: Task) {
        label.text = task.title
        if task.isChecked {
            checkButtonDidTapped()
        }
    }

    private func configure() {
        contentView.addSubview(checkButton)
        contentView.addSubview(label)
        configureConstraints()
    }

    private func configureConstraints() {
        let layouts = [
            checkButton.widthAnchor.constraint(equalToConstant: 20),
            checkButton.heightAnchor.constraint(equalToConstant: 20),
            checkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            label.centerYAnchor.constraint(equalTo: checkButton.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            label.heightAnchor.constraint(equalToConstant: 20)

        ]

        layouts.forEach { $0.isActive = true }
    }

    @objc private func checkButtonDidTapped() {
        guard let title = label.text else { return }
        checkButton.isSelected.toggle()
        let attributeString = NSMutableAttributedString(string: title)
        let range = NSMakeRange(0,attributeString.length)

        if checkButton.isSelected {
            label.textColor = .gray
            attributeString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        } else {
            label.textColor = .black
            attributeString.removeAttribute(.strikethroughStyle, range: range)
        }

        label.attributedText = attributeString
        delegate?.checked(self)
    }

}

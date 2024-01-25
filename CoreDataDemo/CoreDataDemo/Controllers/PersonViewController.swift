//
//  PersonViewController.swift
//  CoreDataDemo
//
//  Created by Nikolai Maksimov on 24.01.2024.
//

import UIKit

final class PersonViewController: UIViewController {
    
    //MARK: - Private properties
    private lazy var tableView = UITableView()
    private var persons = [Person]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        fetchPersons()
    }
}

//MARK: - Private Methods
extension PersonViewController {
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func fetchPersons() {
        persons = CoreDataManager.shared.fetchPersons()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Автолюбители"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewPerson)
        )
    }
    
    @objc
    private func addNewPerson() {
        showAlert(withTitle: "Новый владелец") {
            let newPerson = CoreDataManager.shared.createPerson(name: $0)
            self.persons.append(newPerson)
        }
    }
    
    private func updatePerson(_ person: Person, at indexPath: IndexPath ) {
        showAlert(withTitle: "Изменить", currentText: person.name) { name in
            person.name = name
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            CoreDataManager.shared.update()
        }
    }
    
    private func showAlert(withTitle title: String, currentText: String? = nil, action: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        let save = UIAlertAction(title: "Сохранить", style: .default)  { _ in
            guard let name = alert.textFields?[0].text, !name.isEmpty else {
                return
            }
            action(name)
        }
        alert.addAction(cancel)
        alert.addAction(save)
        alert.addTextField { tf in
            tf.placeholder = "Введите имя"
            tf.text = currentText
        }
        present(alert, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension PersonViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let person = persons[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = person.name
        
        cell.contentConfiguration = content
        return cell
    }
}

//MARK: - UITableViewDelegate
extension PersonViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "Обновить") { _, _, isDone in
            let person = self.persons[indexPath.row]
            self.updatePerson(person, at: indexPath)
            isDone(true)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, isDone in
            CoreDataManager.shared.delete(self.persons[indexPath.row])
            self.persons.remove(at: indexPath.row)
            isDone(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let carsVC = CarsViewController()
        let person = persons[indexPath.row]
        carsVC.person = person
        navigationController?.pushViewController(carsVC, animated: true)
    }
}

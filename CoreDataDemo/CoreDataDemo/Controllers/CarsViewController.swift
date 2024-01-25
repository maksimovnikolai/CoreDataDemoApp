//
//  CarsViewController.swift
//  CoreDataDemo
//
//  Created by Nikolai Maksimov on 24.01.2024.
//

import UIKit

final class CarsViewController: UIViewController {
    
    var person: Person!
    
    //MARK: - Private properties
    private lazy var tableView = UITableView()
    private var cars = [Car]()
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        fetchCarsForCurrentPerson()
    }
}

//MARK: - Private Methods
extension CarsViewController {
    
    private func setupNavigationBar() {
        title = "\(person.name ?? "") владеет:"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewCar))
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @objc
    private func addNewCar() {
        showAlert(withTitle: "Добавить авто") { brandTitle in
            let car = CoreDataManager.shared.createCar(for: self.person, brand: brandTitle)
            self.cars.append(car)
            self.tableView.reloadData()
        }
    }
    
    private func fetchCarsForCurrentPerson() {
        cars = person.cars?.allObjects as! [Car]
    }
    
    private func updateCarModel(_ car: Car, at indexPath: IndexPath) {
        showAlert(withTitle: "Изменить") { brandTitle in
            car.brand = brandTitle
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
            tf.placeholder = "BMW, Mercedes, Audi..."
            tf.text = currentText
        }
        present(alert, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension CarsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        person.cars?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let car = cars[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = car.brand
        cell.contentConfiguration = content
        return cell
    }
}

//MARK: - UITableViewDelegate
extension CarsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let action = UIContextualAction(style: .normal, title: "Обновить") { _, _, isDone in
            let car = self.cars[indexPath.row]
            self.updateCarModel(car, at: indexPath)
            isDone(true)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, isDone in
            CoreDataManager.shared.delete(self.cars[indexPath.row])
            self.cars.remove(at: indexPath.row)
            tableView.reloadData()
            isDone(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

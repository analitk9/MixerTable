//
//  ViewController.swift
//  MixerTable
//
//  Created by Denis Evdokimov on 11/12/23.
//

import UIKit

struct Data {
    var check: Bool = false
    let name: Int
}

class ViewController: UIViewController {
    
    
    private lazy var mockData: [Data] = Array(0...20).map{ Data(name: ($0)) }
    
    private var dataSource: UITableViewDiffableDataSource<Int, Int>?
    
    private let tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .insetGrouped)
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = .clear
        table.separatorStyle = .singleLine
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let identifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setupNavigation()
        setupTableView()
        setupDataSource()
        setupConstraint()
        updateSnapShot()
    }
    
    private func setupNavigation() {
        title = "Task 4"
        let barButton = UIBarButtonItem(title: "Shuffle", style: .plain, target: self, action: #selector(tapShuffle))
        navigationItem.rightBarButtonItem = barButton
        navigationItem.rightBarButtonItem?.tintColor = .systemBlue
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func tapShuffle() {
        mockData.shuffle()
        updateSnapShot()
        
    }
    
    private func updateSnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([.zero])
        snapshot.appendItems(mockData.map { $0.name }, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        mockData[indexPath.row].check.toggle()
        
        
        switch mockData[indexPath.row].check {
        case false:
            cell.accessoryType = .none
            return
        case true:
            cell.accessoryType = .checkmark
            
            mockData.insert(mockData.remove(at: indexPath.row), at: 0)
            
            updateSnapShot()
        }
    }
}

extension ViewController {
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { [weak self] tableView, indexPath, itemIdentifier in
            guard let self else { return .init() }
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            cell.accessoryType = self.mockData[indexPath.row].check ? .checkmark : .none
            
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = "\(self.mockData[indexPath.row].name)"
            cell.contentConfiguration = contentConfiguration
            
            return cell
        }
    }
}



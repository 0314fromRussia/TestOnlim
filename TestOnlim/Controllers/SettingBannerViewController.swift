//
//  SettingBannerViewController.swift
//  TestOnlim
//
//  Created by Никита Дмитриев on 04.10.2021.
//

import UIKit

class SettingBannerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var banners: [BannerModel]?
    
    //через эту переменную передаем модель в прошлый VC
    var closedSettingBanner: (([BannerModel]) -> Void)?
    
    var tableView: UITableView = {
        
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    var addButton: UIButton = {
        
        let addButton = UIButton(type: .system)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle("+", for: .normal)
        addButton.setTitleColor(.label, for: .normal)

        addButton.titleLabel?.font = addButton.titleLabel?.font.withSize(50)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

        return addButton
        
    }()
    
    @objc func addButtonTapped() {
        
        let newBanner = AddBannerViewController()
        newBanner.modalPresentationStyle = .formSheet
        navigationController?.present(UINavigationController(rootViewController: newBanner), animated: true)
        
        newBanner.closedNewBanner = { banner, index in
            self.banners?.insert(banner, at: index)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupViews()
        setupAutoLayout()
    }
    
    // MARK: - setup objects
    
    func setupViews() {
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(addButton)
    }
    
    func setupAutoLayout() {
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8).isActive = true

        
        addButton.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

    }
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(readyButton))

    }
    
    //dismiss отрабатывает после вызова метода viewDidDisappear
    @objc func readyButton() {
        guard let closedSettingBanner = closedSettingBanner else { dismiss(animated: true)
            return }
        guard let banners = banners else { dismiss(animated: true)
            return }
        closedSettingBanner(banners)
        dismiss(animated: true)
    }

    func setData(banners: [BannerModel]) {
        self.banners = banners
    }
    
    // MARK: - Table and Collection view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let banners = banners else { return 0 }
        return banners.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let banners = banners else { return UITableViewCell() }
        let banner = banners[indexPath.row]
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "")
        
        let uiSwitch = UISwitch()
        uiSwitch.isOn = banner.active
        uiSwitch.tag = indexPath.row
        uiSwitch.addTarget(self, action: #selector(switchValueChanged(uiSwitch:)), for: .valueChanged)
        
        cell.accessoryView = uiSwitch
        cell.textLabel?.text = banner.name
        
        return cell
    }
    
    @objc func switchValueChanged(uiSwitch: UISwitch) {
        banners![uiSwitch.tag].active = uiSwitch.isOn
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 60))
        
        let label = UILabel()
        label.font = label.font.withSize(25)
        
        label.frame = CGRect.init(x: 5, y: 5, width: header.frame.width, height: header.frame.height)
        label.text = "Настройки"
        header.addSubview(label)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            banners?.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}


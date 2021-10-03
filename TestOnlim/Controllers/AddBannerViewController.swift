//
//  AddBannerViewController.swift
//  TestOnlim
//
//  Created by Никита Дмитриев on 04.10.2021.
//

import UIKit

class NewBannerViewController: UIViewController {
    
    //через эту переменную передаем модель в прошлый VC
    var closedNewBanner: ((BannerModel, Int) -> Void)?
    
    var banner = BannerModel(name: "No Name", color: "#ffffff", active: true)
    
    var newBanner: UILabel = {
        
        let newBanner = UILabel()
        newBanner.font = newBanner.font.withSize(50)
        newBanner.text = "Новый Баннер"
        newBanner.translatesAutoresizingMaskIntoConstraints = false
        
        return newBanner
    }()
    
    var textFieldLabel: UILabel = {
        let textFieldLabel = UILabel()
        textFieldLabel.text = "Название Баннера"
        textFieldLabel.translatesAutoresizingMaskIntoConstraints = false
        return textFieldLabel
    }()
    
    var stackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 30
        
        return stackView
    }()
    
    
    var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.addTarget(self, action: #selector(changeText), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    @objc func changeText(_ textField: UITextField) {
        guard let text = textField.text else { return }
        banner.name = text
    }
    
    let colorLabel: UILabel = {
        
        let colorLabel = UILabel()
        colorLabel.text = "Цвет Баннера"
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        return colorLabel
        
    }()
    
    var colorStackView: UIStackView = {
        
        let colorStackView = UIStackView()
        colorStackView.translatesAutoresizingMaskIntoConstraints = false
        colorStackView.axis = .vertical
        colorStackView.spacing = 10
        
        return colorStackView
    }()
    
    
    let colorSegmentedControl: UISegmentedControl = {
        
        let typeColor = ["Белый", "Синий", "Зеленый"]
        
        let colorSegmentedControl = UISegmentedControl(items: typeColor)
        colorSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
       
        
        colorSegmentedControl.addTarget(self, action: #selector(changedSegmentedControl), for: .valueChanged)
        
        return colorSegmentedControl
        
    }()
    
    @objc func changedSegmentedControl(_ segmentedControl: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            banner.color = "#ffffff"
        case 1:
            banner.color = "#0000ff"
        case 2:
            banner.color = "#00ff00"
        default:
            break
        }
    }
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //secondarySystemGroupedBackground - цвет для содержимого расположенного поверх основного сгруппированного интерфейса
        view.backgroundColor = .secondarySystemGroupedBackground
        
        setupNavigationBar()
        setupViews()
        setupAutoLayout()
    }
    
    let line = CALayer()
    
    //viewDidLayoutSubviews - уведомляет контроллер о том, что вью настроены
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        textField.layoutIfNeeded()
        
        line.frame = CGRect(x: 0.0, y: textField.bounds.height, width: stackView.bounds.width, height: 1.0)
    }

    
    // MARK: - setup objects
    
    func setupViews() {
        
        view.addSubview(newBanner)
        
        line.backgroundColor = UIColor.label.cgColor
        textField.layer.addSublayer(line)
        
        //стеквью гарантирует, что массив arrangedSubviews всегда является подмножеством его массива subviews.
        stackView.addArrangedSubview(textFieldLabel)
        stackView.addArrangedSubview(textField)
        
        view.addSubview(stackView)
        colorStackView.addArrangedSubview(colorLabel)
        colorStackView.addArrangedSubview(colorSegmentedControl)
        
        view.addSubview(colorStackView)
    }
    
    func setupAutoLayout() {
        
        newBanner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        newBanner.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        newBanner.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

        stackView.topAnchor.constraint(equalTo: newBanner.bottomAnchor, constant: 10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        colorStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10).isActive = true
        colorStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        colorStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

    }
    
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(readyButton))
    }
    
    //dismiss отрабатывает после вызова метода viewDidDisappear
    @objc func readyButton() {
        guard let closedNewBanner = closedNewBanner else { dismiss(animated: true)
            return }
        closedNewBanner(banner, 0)
        dismiss(animated: true)
    }

}



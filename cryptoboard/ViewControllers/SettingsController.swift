//
//  SettingsController.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 21/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit


// Powered by News API : I promise to add an attribution link on my website or app to NewsAPI.org.
class SettingsController: UIViewController {
    
    let MENU_TITLE_CELL_ID = "menu-title-cell-id"
    let MENU_HEADER_CELL_ID = "menu-header-cell-id"
    let MENU_CELL_ID = "settings-menu-cell-id"
    
    enum Sections: Int {
        case title, wallet, preferences, other, total
    }
    
    var sectionCells: [Sections: [String]] = [
        .title: ["Settings"],
        .wallet: ["My follow list", "List all currencies"],
        .preferences: ["My currency"],
        .other: ["About", "Developer", "Leave a review"]
    ]
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuTitleCell.self, forCellReuseIdentifier: MENU_TITLE_CELL_ID)
        tableView.register(MenuContentCell.self, forCellReuseIdentifier: MENU_CELL_ID)
        tableView.register(MenuHeaderCell.self, forHeaderFooterViewReuseIdentifier: MENU_HEADER_CELL_ID)

        return tableView
    }()
    
    lazy var gradientBorder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var closeBtn: UIButton = {
        let image = UIImage.init(named: "cross")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        let button = UIButton(type: UIButtonType.custom)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: UIControlState.normal)
        button.tintColor = UIColor.theme.textIntermediate.value
        button.addTarget(self, action: #selector(handleClose(_:)), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.theme.bg.value
        view.addSubview(tableView)
        view.addSubview(gradientBorder)
        view.addSubview(closeBtn)
        
        let views: [String: Any] = [
            "tableView": tableView,
            "close": closeBtn,
            "gradient": gradientBorder
        ]
        let constraints = [
            "H:|[tableView]|",
            "H:|[gradient]|",
            "H:|-18-[close(26)]",
            "V:[close(26)]-[tableView]|",
        ]
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
        NSLayoutConstraint.activate([
            closeBtn.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 9),
            gradientBorder.topAnchor.constraint(equalTo: tableView.topAnchor),
            gradientBorder.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        gradientBorder.applyGradient(colours: [UIColor.theme.bg.value, UIColor.theme.bg.withAlpha(0)])
    }
    
    @objc private func handleClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension SettingsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.total.rawValue
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: MENU_HEADER_CELL_ID) as! MenuHeaderCell
        
        if let tableSection = Sections(rawValue: section) {
            switch tableSection {
            case .wallet:
                cell.setup(title: "Wallet")
            case .preferences:
                cell.setup(title: "Preferences")
            case .other:
                cell.setup(title: "Other")
            default:
                break
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 0
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tableSection = Sections(rawValue: section), let section = sectionCells[tableSection] {
            return section.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tableSection = Sections(rawValue: indexPath.section), let cellTitles = sectionCells[tableSection] {
            if (tableSection == .title) {
                let cell = tableView.dequeueReusableCell(withIdentifier: MENU_TITLE_CELL_ID, for: indexPath) as! MenuTitleCell
                
                cell.setup(title: cellTitles[indexPath.row])
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: MENU_CELL_ID, for: indexPath) as! MenuContentCell
                
                cell.setup(title: cellTitles[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
}

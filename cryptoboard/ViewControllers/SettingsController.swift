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
    
    class SettingsCell {
        
        var name: String
        var ft: (() -> Void)?
        
        init(_ name: String) {
            self.name = name
        }
        
        init(_ name: String, ft: @escaping () -> Void) {
            self.name = name
            self.ft = ft
        }
        
    }
    
    var sectionCells = [Sections: [SettingsCell]]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.theme.bg.value
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuTitleCell.self, forCellReuseIdentifier: MENU_TITLE_CELL_ID)
        tableView.register(MenuContentCell.self, forCellReuseIdentifier: MENU_CELL_ID)
        tableView.register(MenuHeaderCell.self, forHeaderFooterViewReuseIdentifier: MENU_HEADER_CELL_ID)

        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sectionCells = [
            .title: [SettingsCell("Settings")],
            .wallet: [SettingsCell("My follow list"), SettingsCell("List all currencies")],
            .preferences: [SettingsCell("My local currency")],
            .other: [SettingsCell("About"), SettingsCell("Developer"), SettingsCell("Leave a review", ft: handleReviewButton), SettingsCell("Reset app", ft: handleResetButton)]
        ]

        view.backgroundColor = UIColor.theme.redDark.value
        view.addSubviewsAutoConstraints([tableView])
        
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupConstraints() {
        let views: [String: Any] = [
            "tableView": tableView,
            ]
        let constraints = [
            "H:|[tableView]|",
            "V:[tableView]|",
            ]
        
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 8)])
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
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
//            case .wallet:
//                cell.setup(title: "Wallet")
//            case .preferences:
//                cell.setup(title: "Preferences")
//            case .other:
//                cell.setup(title: "Other")
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
            let currentCell = cellTitles[indexPath.row]
            
            if (tableSection == .title) {
                let cell = tableView.dequeueReusableCell(withIdentifier: MENU_TITLE_CELL_ID, for: indexPath) as! MenuTitleCell
                
                cell.setup(title: currentCell.name)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: MENU_CELL_ID, for: indexPath) as! MenuContentCell
                
                cell.setup(title: currentCell.name)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tableSection = Sections(rawValue: indexPath.section), let cellTitles = sectionCells[tableSection] {
            let currentCell = cellTitles[indexPath.row]
            
            if let ft = currentCell.ft {
                ft()
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func handleResetButton() {
        let alert = UIAlertController(title: "Reset application", message: "All settings will be deleted", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            UserSettingsController().reset()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (acton) in

        }))

        present(alert, animated: true, completion: nil)
    }
    
    private func handleReviewButton() {
        let appId = "1382998431"
        
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            return
        }
        
        let alert = UIAlertController(title: "Review the app", message: "Help us by giving your advice", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Lets go !", style: .default, handler: { (action) in
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (acton) in
            
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
}

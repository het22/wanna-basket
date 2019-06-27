//
//  TeamTableView
//  WannaBasket
//
//  Created by Het Song on 24/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class TeamTableView: UITableView {
    
    var _delegate: TeamTableViewDelegate?
    
    private var teams: [Team] = []
    
    let padding: CGFloat = 10
    let buttonHeight: CGFloat = 30
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rowHeight = 50
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        register(TeamTableViewCell.self)
        register(AddButtonCell.self)
        dataSource = self
        delegate = self
    }
    
    func reloadData(with teams: [Team]) {
        self.teams = teams
        reloadData()
    }
    
    func highlightCell(at index: Int, bool: Bool) {
        if let cell = cellForRow(at: IndexPath(row: 0, section: index + 1)) as? TeamTableViewCell {
            cell.highlight = bool
        }
    }
}

extension TeamTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return teams.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section==0 ? 0 : padding
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == IndexPath(row: 0, section: 0) { return buttonHeight }
        else {
            let cellHeight = (bounds.height - buttonHeight) / 5 - padding
            return cellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == IndexPath(row: 0, section: 0) {
            let cell = dequeueReusableCell(forIndexPath: indexPath) as AddButtonCell
            return cell
        } else {
            let cell = dequeueReusableCell(forIndexPath: indexPath) as TeamTableViewCell
            cell.setup(name: teams[indexPath.section - 1].name)
            return cell
        }
    }
}

protocol TeamTableViewDelegate {
    func didAddTeamButtonTap()
    func didDeleteTeamButtonTap()
    func didTeamCellTap(at index: Int)
}

extension TeamTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 0) {
            _delegate?.didAddTeamButtonTap()
        } else {
            _delegate?.didTeamCellTap(at: indexPath.section - 1)
        }
    }
}

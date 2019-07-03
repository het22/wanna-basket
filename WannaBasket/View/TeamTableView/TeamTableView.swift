//
//  TeamTableView
//  WannaBasket
//
//  Created by Het Song on 24/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

protocol TeamTableViewDelegate {
    func didDeleteTeamButtonTap()
    func didTeamCellTap(at indexPath: IndexPath, onLeft: Bool)
}

class TeamTableView: UITableView {
    
    var _delegate: TeamTableViewDelegate?
    
    @IBInspectable var spacing: CGFloat = 10
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        
        register(TeamTableViewCell.self)
        dataSource = self
        delegate = self
    }
    
    private var teamList: [Team] = []
    func reloadData(with teamList: [Team]) {
        self.teamList = teamList
        reloadData()
    }
    
    func highlightCell(at index: Int, onLeft: Bool, bool: Bool) {
        if let cell = cellForRow(at: IndexPath(row: 0, section: index)) as? TeamTableViewCell {
            if onLeft { cell.highlightOnLeft = bool }
            else { cell.highlightOnRight = bool }
        }
    }
}

extension TeamTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = cellForRow(at: indexPath) as? TeamTableViewCell {
            _delegate?.didTeamCellTap(at: indexPath, onLeft: cell.tapOnLeft)
        }
    }
}

extension TeamTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return teamList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section==0 ? 0 : spacing
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight = bounds.height / 5 - spacing
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(forIndexPath: indexPath) as TeamTableViewCell
        cell.setup(name: teamList[indexPath.section].name)
        return cell
    }
}

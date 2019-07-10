//
//  TeamTableView
//  WannaBasket
//
//  Created by Het Song on 24/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

protocol TeamTableViewDelegate {
    func didDeleteTeamAction(at index: Int)
    func didTapTeamCell(at index: Int, onLeft: Bool)
    func didDequeueTeamCell() -> (home: Int?, away: Int?)
}

class TeamTableView: UITableView {
    
    var _delegate: TeamTableViewDelegate?
    
    @IBInspectable var placeholder: String = "Placeholder"
    @IBInspectable var cellSpacing: CGFloat = 5
    @IBInspectable var cellCount: CGFloat = 4.5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: cellSpacing, right: 0)
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        
        register(TeamTableViewCell.self)
        dataSource = self
        delegate = self
    }
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.text = placeholder
        label.textColor = Constants.Color.Silver
        label.font = UIFont(name: "DoHyeon-Regular", size: 20)
        label.textAlignment = .center
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        return label
    }()
    
    private var teamList: [Team] = []
    func reloadData(with teamList: [Team]) {
        placeholderLabel.isHidden = (teamList.count != 0)
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
            _delegate?.didTapTeamCell(at: indexPath.section, onLeft: cell.tapOnLeft)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "삭제") {
            (action, indexPath) in
            self._delegate?.didDeleteTeamAction(at: indexPath.section)
        }
        deleteAction.backgroundColor = Constants.Color.AwayDefault
        return [deleteAction]
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
        return section==0 ? 0 : cellSpacing
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight = bounds.height / cellCount - cellSpacing
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(forIndexPath: indexPath) as TeamTableViewCell
        cell.setup(name: teamList[indexPath.section].name)
        if let currentTeamIndex = _delegate?.didDequeueTeamCell() {
            if let homeTeamIndex = currentTeamIndex.home {
                cell.highlightOnLeft = (indexPath.section == homeTeamIndex)
            }
            if let awayTeamIndex = currentTeamIndex.away {
                cell.highlightOnRight = (indexPath.section == awayTeamIndex)
            }
        }
        return cell
    }
}

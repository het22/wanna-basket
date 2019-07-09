//
//  PlayerTableView.swift
//  WannaBasket
//
//  Created by Het Song on 25/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

@objc protocol PlayerTableViewDelegate {
    @objc optional func didDeletePlayerAction(at index: Int, of home: Bool)
    func didTapPlayerCell(at index: Int, of home: Bool)
}

class PlayerTableView: UITableView {
    
    var _delegate: PlayerTableViewDelegate?
    var home = true
    
    @IBInspectable var placeholderNoTeam: String = "팀을 선택하세요"
    @IBInspectable var placeholderNoPlayer: String = "선수를 생성하세요"
    @IBInspectable var spacing: CGFloat = 5
    @IBInspectable var highlightColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    @IBInspectable var cellCount: CGFloat = 4.5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: spacing, right: 0)
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        
        register(PlayerTableViewCell.self)
        dataSource = self
        delegate = self
    }
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
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
    
    private var playerList: [Player]?
    func reloadData(with playerList: [Player]?) {
        placeholderLabel.isHidden = (playerList != nil) && (playerList?.count != 0)
        if playerList == nil { placeholderLabel.text = placeholderNoTeam }
        if playerList?.count == 0 { placeholderLabel.text = placeholderNoPlayer }
        self.playerList = playerList
        reloadData()
    }
    
    func highlightCell(at index: Int, bool: Bool) {
        if let cell = cellForRow(at: IndexPath(row: 0, section: index)) as? PlayerTableViewCell {
            cell.isHighlighted = bool
        }
    }
    
    func blinkCell(at index: Int, completion: ((Bool)->Void)?) {
        if let cell = cellForRow(at: IndexPath(row: 0, section: index)) {
            self.isUserInteractionEnabled = false
            cell.animateBlink { bool in
                completion?(bool)
                self.isUserInteractionEnabled = true
            }
        }
    }
}

extension PlayerTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = cellForRow(at: indexPath) as? PlayerTableViewCell {
            _delegate?.didTapPlayerCell(at: indexPath.section, of: home)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let didDeletePlayerAction = _delegate?.didDeletePlayerAction else {
            return []
        }
        let deleteAction = UITableViewRowAction(style: .destructive, title: "삭제") { (UITableViewRowAction, IndexPath) in
            didDeletePlayerAction(indexPath.section, self.home)
        }
        deleteAction.backgroundColor = Constants.Color.AwayDefault
        return [deleteAction]
    }
}

extension PlayerTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return playerList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section==0) ? 0 : spacing
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight = bounds.height / cellCount - spacing
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(forIndexPath: indexPath) as PlayerTableViewCell
        let player = playerList![indexPath.section]
        cell.setup(home: home,
                   name: player.name,
                   number: player.number,
                   highlightColor: highlightColor)
        return cell
    }
}

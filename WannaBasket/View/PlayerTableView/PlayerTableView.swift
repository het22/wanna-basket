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
    
    @IBInspectable var ofHome: Bool = true
    @IBInspectable var highlightColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    @IBInspectable var cellSpacing: CGFloat = 5
    @IBInspectable var cellCount: CGFloat = 5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: cellSpacing, right: 0)
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        
        register(PlayerTableViewCell.self)
        dataSource = self
        delegate = self
    }
    
    @IBInspectable var placeholderNoTeam: String = "Placeholder No Team"
    @IBInspectable var placeholderNoPlayer: String = "Placeholder No Player"
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
    func showPlaceholder(with count: Int?) {
        placeholderLabel.isHidden = (count != nil) && (count != 0)
        if count == nil { placeholderLabel.text = placeholderNoTeam }
        if count == 0 { placeholderLabel.text = placeholderNoPlayer }
    }
    
    private var playerList: [Player]? {
        didSet { showPlaceholder(with: playerList?.count) }
    }
    func reloadData(with playerList: [Player]?) {
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
            _delegate?.didTapPlayerCell(at: indexPath.section, of: ofHome)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let didDeletePlayerAction = _delegate?.didDeletePlayerAction else {
            return []
        }
        let deleteAction = UITableViewRowAction(style: .destructive, title: "삭제") { (UITableViewRowAction, IndexPath) in
            didDeletePlayerAction(indexPath.section, self.ofHome)
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
        return (section==0) ? 0 : cellSpacing
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight = bounds.height / cellCount - cellSpacing
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(forIndexPath: indexPath) as PlayerTableViewCell
        let player = playerList![indexPath.section]
        cell.setup(home: ofHome,
                   name: player.name,
                   number: player.number,
                   highlightColor: highlightColor)
        return cell
    }
}

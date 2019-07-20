//
//  PlayerTableView.swift
//  WannaBasket
//
//  Created by Het Song on 25/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

@objc protocol PlayerTableViewDelegate: class {
    @objc optional func didDeletePlayerAction(at index: Int, of home: Bool)
    func didTapPlayerCell(at index: Int, of home: Bool)
    func didDequeuePlayerCell(of home: Bool) -> [Int]
}

class PlayerTableView: UITableView {
    
    weak var _delegate: PlayerTableViewDelegate?
    var playerTuples: [(player: PlayerOfTeam, records: [Record])]? {
        didSet {
            showPlaceholder(with: playerTuples?.count)
            reloadData()
        }
    }
    
    @IBInspectable var isCustomScrollEnabled: Bool = false {
        didSet(oldVal) {
            if oldVal == isCustomScrollEnabled { return }
            cellCount += (isCustomScrollEnabled ? 0.5 : -0.5)
            isScrollEnabled = isCustomScrollEnabled
            reloadInputViews()
            if let _ = cellForRow(at: IndexPath(row: 0, section: 0)) {
                scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        }
    }
    @IBInspectable var isRecordEnabled: Bool = false {
        didSet(oldVal) {
            if oldVal == isRecordEnabled { return }
            reloadData()
        }
    }
    @IBInspectable var home: Bool = true
    @IBInspectable var cellSpacing: CGFloat = 5
    @IBInspectable var cellCount: CGFloat = 5
    @IBInspectable var cellSize: CGFloat = 0
    @IBInspectable var highlightColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: cellSpacing, right: 0)
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        
        register(PlayerCell.self)
        register(PlayerRecordCell.self)
        dataSource = self
        delegate = self
    }
    
    var placeholderSelectTeam: String = Constants.Text.Message.SelectTeam
    var placeholderAddPlayer: String = Constants.Text.Message.AddPlayer
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
        if count == nil { placeholderLabel.text = placeholderSelectTeam }
        if count == 0 { placeholderLabel.text = placeholderAddPlayer }
    }
    
    func highlightCell(at index: Int, bool: Bool) {
        if let cell = cellForRow(at: IndexPath(row: 0, section: index)) as? PlayerCell {
            cell.isCustomHighlighted = bool
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
        if let _ = cellForRow(at: indexPath) as? PlayerCell {
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
        return playerTuples?.count ?? 0
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
        let cellHeight = (cellCount == 0) ? cellSize : (bounds.height / cellCount - cellSpacing)
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let playerTuple = playerTuples![indexPath.section]
        if isRecordEnabled {
            let cell = dequeueReusableCell(forIndexPath: indexPath) as PlayerRecordCell
            let model = PlayerRecordModel(home: home,
                                          player: playerTuple.player,
                                          records: playerTuple.records,
                                          color: highlightColor)
            cell.setup(with: model)
            cell.isCustomHighlighted = _delegate?.didDequeuePlayerCell(of: home).contains(indexPath.section) ?? false
            return cell
        } else {
            let cell = dequeueReusableCell(forIndexPath: indexPath) as PlayerCell
            let model = PlayerCellModel(home: home,
                                        player: playerTuple.player,
                                        color: highlightColor)
            cell.setup(with: model)
            cell.isCustomHighlighted = _delegate?.didDequeuePlayerCell(of: home).contains(indexPath.section) ?? false
            return cell
        }
    }
}

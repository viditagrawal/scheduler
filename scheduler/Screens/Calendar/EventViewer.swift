//
//  EventViewer.swift
//  scheduler
//
//  Created by Collin Qian on 4/22/23.
//

import Foundation
import UIKit

final class EventViewer: UIView {
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Select event to view the description"
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        return view
    }()
    
    var text: String? {
        didSet {
            textLabel.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        reloadFrame(frame: CGRect(origin: .zero, size: frame.size))
        addSubview(textLabel)
        addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadFrame(frame: CGRect) {
        textLabel.frame = frame
        lineView.frame = CGRect(origin: .zero, size: CGSize(width: 1, height: frame.height))
    }
}

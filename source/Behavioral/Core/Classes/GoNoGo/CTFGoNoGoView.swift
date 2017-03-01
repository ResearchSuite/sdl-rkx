//
//  CTFGoNoGoView.swift
//  ORKCatalog
//
//  Created by James Kizer on 9/28/16.
//  Copyright © 2016 researchkit.org. All rights reserved.
//

import UIKit

enum CTFGoNoGoState {
    case blank
    case cross
    case goCue
    case noGoCue
    case goCueNoGoTarget
    case noGoCueNoGoTarget
    case goCueGoTarget
    case noGoCueGoTarget
}

protocol CTFGoNoGoViewDelegate {
    func goNoGoViewDidTap(_ goNoGoView: CTFGoNoGoView)
}

class CTFGoNoGoView: UIView {

    let crossView = UIImageView(image: UIImage(named: "cross"))
    let horizontalRectangle = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
    let verticalRectangle = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
    
    
    var delegate: CTFGoNoGoViewDelegate?
    
    var goColor = UIColor(red: 46.0/255.0, green: 204.0/255.0, blue: 113.0/255.0, alpha: 1.0)
    var noGoColor = UIColor(red: 41.0/255.0, green: 128.0/255.0, blue: 185.0/255.0, alpha: 1.0)
    
    let RFC3339DateFormatter = DateFormatter()
    
    func configureHorizontalViewForState(_ state: CTFGoNoGoState) {
        self.horizontalRectangle.isHidden = !(
            state == .goCue ||
                state == .goCueGoTarget ||
                state == .goCueNoGoTarget
        )
        
        if state == .goCueGoTarget {
            horizontalRectangle.backgroundColor = self.goColor
        }
        else if self.state == .goCueNoGoTarget {
            horizontalRectangle.backgroundColor = self.noGoColor
        }
        else {
            horizontalRectangle.backgroundColor = UIColor.white
        }
    }
    
    func configureVerticalViewForState(_ state: CTFGoNoGoState) {
        self.verticalRectangle.isHidden = !(
            state == .noGoCue ||
                state == .noGoCueGoTarget ||
                state == .noGoCueNoGoTarget
        )
        
        if state == .noGoCueGoTarget {
            verticalRectangle.backgroundColor = self.goColor
        }
        else if self.state == .noGoCueNoGoTarget {
            verticalRectangle.backgroundColor = self.noGoColor
        }
        else {
            verticalRectangle.backgroundColor = UIColor.white
        }
    }
    
    var state: CTFGoNoGoState = .blank {
        didSet {
            self.crossView.isHidden = !(self.state == .cross)
            self.configureVerticalViewForState(self.state)
            self.configureHorizontalViewForState(self.state)
            self.isUserInteractionEnabled = (
                self.state == .goCueNoGoTarget ||
                    self.state == .noGoCueNoGoTarget ||
                    self.state == .goCueGoTarget ||
                    self.state == .noGoCueGoTarget
            )
            
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.setupView()
    }
    
    func setupView() {
        
        self.RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        self.RFC3339DateFormatter.dateFormat = "HH:mm:ss.SSS"
        
        self.crossView.contentMode = UIViewContentMode.scaleAspectFit
        self.addSubview(self.crossView)
        
        self.horizontalRectangle.layer.borderColor = UIColor.black.cgColor
        self.horizontalRectangle.layer.borderWidth = 4.0
        self.addSubview(self.horizontalRectangle)
        
        self.verticalRectangle.layer.borderColor = UIColor.black.cgColor
        self.verticalRectangle.layer.borderWidth = 4.0
        self.addSubview(self.verticalRectangle)
        
        let tapRec = CTFGoNoGoGestureRecognizer { [weak self] in
            self?.screenTapped()
        }
        self.addGestureRecognizer(tapRec)
        self.isUserInteractionEnabled = false
        
    }
    
    override func layoutSubviews() {
        self.crossView.center = self.center
        self.horizontalRectangle.center = self.center
        self.verticalRectangle.center = self.center
    }
    
    func screenTapped() {
        print("Screen tapped: \(self.RFC3339DateFormatter.string(from: Date()))")
        self.delegate?.goNoGoViewDidTap(self)
        
    }
    
    
    
    
    
    
    
    
    
//    override func sizeThatFits(size: CGSize) -> CGSize {
//        let minDimension: CGFloat = min(size.height, size.width)
//        return CGSizeMake(minDimension, minDimension)
//    }
    
//    override func intrinsicContentSize() -> CGSize {
//        return CGSizeMake(375.0, 375.0)
//    }

}

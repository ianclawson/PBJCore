//
//  Tooltip.swift
//  stars2apples
//
//  Created by Ian Clawson on 2/15/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

import UIKit

class ToolTip: UIView {
    
    enum Location {
        case top
        case bottom
        case left
        case right
        case none
    }
    
    enum Style {
        case dark
        case light
        
        func effect() -> UIBlurEffect {
            switch self {
            case .dark:
                return UIBlurEffect(style: .dark)
            case .light:
                return UIBlurEffect(style: .extraLight)
            }
        }
        
        func textColor() -> UIColor {
            switch self {
            case .dark:
                return .white
            case .light:
                return .black
            }
        }
    }
    
    var message: String = ""
    var location: Location = .none
    var style: Style = .dark
    var textWidth: Double = 100.0
    var topImage: UIImage? = nil
    
    let effectBackground = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let label = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    init(message: String, style: Style = .dark, location: Location = .none, textWidth: Double = 100.0, topImage: UIImage? = nil) {
        self.message = message
        self.style = style
        self.location = location
        self.textWidth = textWidth
        self.topImage = topImage
        
        super.init(frame: .zero)
        commonInit()
    }
    
    func commonInit()  {
        backgroundColor = .clear
        layer.masksToBounds = false
        
        label.text = message
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = style.textColor()
        label.textAlignment = .center
        label.numberOfLines = 0
        
        effectBackground.effect = style.effect()
        effectBackground.layer.masksToBounds = true
        
        let textSize = message.boundingRect(with: CGSize(width: textWidth, height: .greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .medium)], context: nil)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        effectBackground.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        addSubview(effectBackground)
        sendSubviewToBack(effectBackground)
        
        let horizontalPadding: CGFloat = 50
        let verticalPadding: CGFloat = 42
        
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            effectBackground.topAnchor.constraint(equalTo: self.topAnchor),
            effectBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            effectBackground.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            effectBackground.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.widthAnchor.constraint(equalToConstant: textSize.width + horizontalPadding),
        ])
        
        if let topImage = self.topImage {
            let imageView = UIImageView(image: topImage)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.isUserInteractionEnabled = false
            imageView.contentMode = .scaleAspectFit
            let imageViewHeight: CGFloat = CGFloat(textWidth)
            addSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
                imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                imageView.heightAnchor.constraint(equalToConstant: imageViewHeight),
                label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
                // text + image + space between text/image + padding
                self.heightAnchor.constraint(equalToConstant: textSize.height + imageViewHeight + 10 + verticalPadding)
            ])
        } else {
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
                self.heightAnchor.constraint(equalToConstant: textSize.height + verticalPadding)
            ])
        }
        
        self.frame.size = CGSize(width: textSize.width + horizontalPadding, height: textSize.height + verticalPadding)
        
        refreshBackground()
        effectBackground.isUserInteractionEnabled = false
        label.isUserInteractionEnabled = false
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedView)))
    }
    
    func refreshBackground() {
        let path = drawBackground(frame: self.bounds)
                
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
                
        let maskView = ShapeLayerView(frame: self.bounds)
        maskView.shapeLayer.path = path.cgPath
        maskView.shapeLayer.fillColor = UIColor.white.cgColor
        
        effectBackground.mask = maskView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        refreshBackground()
    }
    
    override var bounds: CGRect {
        didSet {
            refreshBackground()
        }
    }
    
    @objc func tappedView() {
        dismiss()
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    func drawBackground(frame: CGRect, radius: CGFloat = 4) -> UIBezierPath {
        
        // This non-generic function dramatically improves compilation times of complex expressions.
        func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }
        
        let totalPath = UIBezierPath()

        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: frame.minX + 10, y: frame.minY + 9, width: frame.width - 20, height: frame.height - 17), cornerRadius: radius)
        
        totalPath.append(rectanglePath)

        if location != .none {
            let rectangle2Path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 12, height: 12), byRoundingCorners: [.topLeft, .bottomRight], cornerRadii: CGSize(width: radius, height: radius))
            rectangle2Path.close()
            
            let rotation: CGFloat
            let translationX: CGFloat
            let translationY: CGFloat
            
            switch location {
            case .bottom:
                rotation = 45 * .pi / 180
                translationX = frame.width / 2.0
                translationY = 3.0
            case .top:
                rotation = 45 * .pi / 180
                translationX = frame.width / 2.0
                translationY = frame.height - 18
            case .left:
                rotation = -45 * .pi / 180
                translationX = frame.width - 20
                translationY = frame.height / 2.0
            case .right:
                rotation = -45 * .pi / 180
                translationX = 3.0
                translationY = frame.height / 2.0
            case .none:
                rotation = 0
                translationX = 0
                translationY = 0
            }
            
            rectangle2Path.apply(CGAffineTransform(rotationAngle: rotation))
            rectangle2Path.apply(CGAffineTransform(translationX: translationX, y: translationY))
            
            totalPath.append(rectangle2Path)
        }
        
        return totalPath
    }
    
    class ShapeLayerView: UIView {
        var shapeLayer: CAShapeLayer {
            return layer as! CAShapeLayer
        }
         
        override class var layerClass: AnyClass {
            return CAShapeLayer.self
        }
    }
}


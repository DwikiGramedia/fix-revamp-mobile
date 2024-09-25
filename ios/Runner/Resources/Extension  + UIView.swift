//
//  Extension + UIView.swift
//  SCOOP
//
//  Created by Maul on 12/08/22.
//

import UIKit

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

//MARK: Setup Constraints ad Layout View
extension UIView {
    func center(view: UIView) {
        self.centerXAnchor(centerX: view.centerXAnchor)
        self.centerYAnchor(centerY: view.centerYAnchor)
    }
    
    func centerXYAnchor(centerX: NSLayoutXAxisAnchor, centerY: NSLayoutYAxisAnchor) {
        self.centerXAnchor(centerX: centerX)
        self.centerYAnchor(centerY: centerY)
    }
    
    func centerXAnchor(centerX: NSLayoutXAxisAnchor) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: centerX).isActive = true
    }
    
    func centerYAnchor(centerY: NSLayoutYAxisAnchor) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerYAnchor.constraint(equalTo: centerY).isActive = true
    }
    
    func anchorSize(to view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        self.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        self.anchor(top: self.superview?.topAnchor, bottom: self.superview?.bottomAnchor, leading: self.superview?.leadingAnchor, trailing: self.superview?.trailingAnchor, padding: padding)
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?,
                padding: UIEdgeInsets) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        if let topConstraint = top {
            self.topAnchor.constraint(equalTo: topConstraint, constant: padding.top).isActive = true
        }
        if let bottomConstraint = bottom {
            self.bottomAnchor.constraint(equalTo: bottomConstraint, constant: -padding.bottom).isActive = true
        }
        if let leadingConstraint = leading {
            self.leadingAnchor.constraint(equalTo: leadingConstraint, constant: padding.left).isActive = true
        }
        if let trailingConstraint = trailing {
            self.trailingAnchor.constraint(equalTo: trailingConstraint, constant: -padding.right).isActive = true
        }
    }
    
    func anchor(to view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    @IBInspectable var cornersRadius: CGFloat {

        get{
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var bordersWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var bordersColor: UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            else {
                return nil
            }
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
}

//MARK: - Shadow
extension UIView {
    func setDefaultShadow(cornerRadius: CGFloat) {
        self.backgroundColor = UIColor.white
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.15
        self.layer.shadowPath = UIBezierPath(rect: self.layer.bounds).cgPath
    }
    
    func setDefaultShadowWithoutCornerRadius() {
        self.backgroundColor = UIColor.white
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.15
        self.layer.shadowPath = UIBezierPath(rect: self.layer.bounds).cgPath
    }
    
    func setCustomShadowViewWith(cornerRadius: CGFloat, shadowColor: CGColor = UIColor.black.cgColor, shadowOpacity: Float = 0.2, shadowOffset: CGSize = .zero, width: CGFloat? = nil, height: CGFloat? = nil) {
        self.clipsToBounds = false
        self.layer.shadowColor = shadowColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = cornerRadius
        self.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: width ?? self.bounds.width, height: height ?? self.bounds.height), cornerRadius: cornerRadius).cgPath
    }
    
    enum VerticalLocation: String {
        case bottom
        case top
        case center
    }
    
    func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0, height: CGFloat = 10) {
        switch location {
        case .bottom:
            addShadow(offset: CGSize(width: 0, height: height), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -(height)), color: color, opacity: opacity, radius: radius)
        case .center:
            addShadow(offset: CGSize(width: height, height: height), color: color, opacity: opacity, radius: radius)
        }
    }
    
    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    func addShadow(shadowColor: UIColor, offSet: CGSize, opacity: Float, shadowRadius: CGFloat, cornerRadius: CGFloat, corners: UIRectCorner, fillColor: UIColor = .white) {
        
        let shadowLayer = CAShapeLayer()
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let cgPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size).cgPath //1
        shadowLayer.path = cgPath //2
        shadowLayer.fillColor = fillColor.cgColor //3
        shadowLayer.shadowColor = shadowColor.cgColor //4
        shadowLayer.shadowPath = cgPath
        shadowLayer.shadowOffset = offSet //5
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = shadowRadius
        self.layer.insertSublayer(shadowLayer, at: 0)
    }
}

extension UIView {
 
 func preventScreenshot(for view: UIView) {
     let textField = UITextField()
     textField.isSecureTextEntry = true
     textField.isUserInteractionEnabled = true
     guard let hiddenView = textField.layer.sublayers?.first?.delegate as? UIView else {
         return
     }
     
     hiddenView.subviews.forEach { $0.removeFromSuperview() }
     hiddenView.translatesAutoresizingMaskIntoConstraints = false
     self.addSubview(hiddenView)
     hiddenView.fillSuperview()
     hiddenView.addSubview(view)
     NSLayoutConstraint.activate([
             hiddenView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             hiddenView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
             hiddenView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
             hiddenView.topAnchor.constraint(equalTo: self.topAnchor)
         ])
 }
}


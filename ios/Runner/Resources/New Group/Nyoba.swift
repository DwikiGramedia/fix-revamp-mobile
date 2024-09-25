
import Foundation
import UIKit

func createButton(title: String) -> UIButton {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    var imageCleaarConfiguration = UIImage.SymbolConfiguration(pointSize:UIDevice.isIPad ? 28 : 20, weight: .medium, scale: .medium)
    button.setImage(UIImage(systemName: title,withConfiguration: imageCleaarConfiguration), for: .normal)

    button.tintColor = .init(red: 0, green: 96/255, blue: 175/255, alpha: 1)
    button.backgroundColor = .clear
    button.layer.cornerRadius = 12

    return button
}

func createAssetBlackButton(imageAsset: String) -> UIButton {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    var imageCleaarConfiguration = UIImage.SymbolConfiguration(pointSize:UIDevice.isIPad ? 28 : 20, weight: .bold, scale: .medium)
    button.setImage(UIImage(named: imageAsset, in: nil,with: imageCleaarConfiguration), for: .normal)

    button.tintColor = .init(red: 74/255, green: 74/255, blue: 104/255, alpha: 1)
    button.backgroundColor = .clear
    button.layer.cornerRadius = 12

    return button
}


func createBlackButton(title: String) -> UIButton {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    var imageCleaarConfiguration = UIImage.SymbolConfiguration(pointSize:UIDevice.isIPad ? 28 : 20, weight: .bold, scale: .medium)
    button.setImage(UIImage(systemName: title,withConfiguration: imageCleaarConfiguration), for: .normal)

    button.tintColor = .init(red: 74/255, green: 74/255, blue: 104/255, alpha: 1)
    button.backgroundColor = .clear
    button.layer.cornerRadius = 12

    return button
}

func createButtonConfiguration(systemName:String,withConfiguration:UIImage.Configuration)->UIButton{
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false

    button.setImage(UIImage(systemName: systemName,withConfiguration:withConfiguration), for: .normal)

    button.tintColor = .blue
    button.backgroundColor = .clear
    button.layer.cornerRadius = 12

    return button
}

func createButtonEraser(systemName:String,withConfiguration:UIImage.Configuration)->UIButton{
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false

    button.setImage(UIImage(named: systemName,in: nil,with: withConfiguration), for: .normal)

    button.tintColor = .blue
    button.backgroundColor = .clear
    button.layer.cornerRadius = 12

    return button
}

func createTitleButton(title: String,color:UIColor) -> UIButton {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false

    button.setTitle(title, for: .normal)

    button.tintColor = .blue
    button.backgroundColor = color
    button.layer.cornerRadius = 8

    return button
}

func configurationCreateButton(title: String) -> UIButton {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false

    button.setImage(UIImage(systemName: title), for: .normal)
    
    button.layer.borderColor = UIColor.black.cgColor
    button.layer.borderWidth = 1.0
    button.tintColor = .blue
    button.backgroundColor = .clear
    button.layer.cornerRadius = 4

    return button
}


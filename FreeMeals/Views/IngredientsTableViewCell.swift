//
//  IngredientsTableViewCell.swift
//  FreeMeals
//
//  Created by Bharat Kumar on 8/27/21.
//

import UIKit

class IngredientsTableViewCell: UITableViewCell {
    
    //MARK: -Properties
    var ingredientslabel = UILabel()
    var measureLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
       handleConstraints()
    }
    
    //MARK: -Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        handleConstraints()
     }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        handleConstraints()
    }
    
    //MARK: -Methods
    func handleConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        
        ingredientslabel.font = UIFont(name: "AvenirNext-Semibold", size: 17)
        ingredientslabel.textColor = UIColor(named: "#4A4A4A")
        ingredientslabel.textAlignment = .center
        ingredientslabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ingredientslabel)
        
        // ingredientslabel label Constraints
        ingredientslabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10).isActive = true
        ingredientslabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
      
        // measureLabel name setup
        measureLabel.font = UIFont(name: "AvenirNext-Semibold", size: 17)
        measureLabel.textColor = UIColor(named: "#4A4A4A")
        measureLabel.textAlignment = .center
        measureLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(measureLabel)
        
        // mealNameLabel name constraints
        measureLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10).isActive = true
        measureLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        
    }
    
}

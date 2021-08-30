//
//  IngredientsTableViewController.swift
//  FreeMeals
//
//  Created by Bharat Kumar on 8/27/21.
//

import UIKit

class IngredientsTableViewController: UITableViewController {
    
    //MARK: - Properties
    private var ingredientsCellIdentifier = "ingredientsCell"
    var ingredients: [MealIngredients] = []
    
    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        registerIngredientsTableViewCell()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    //MARK: - Methods
    private func setUpTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        view.backgroundColor = .lightGray
        tableView.backgroundColor = .lightGray
    }
    
    private func registerIngredientsTableViewCell() {
        self.tableView.register(IngredientsTableViewCell.self, forCellReuseIdentifier: ingredientsCellIdentifier)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ingredients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ingredientsCellIdentifier, for: indexPath) as? IngredientsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.ingredientslabel.text = ingredients[indexPath.row].name
        cell.measureLabel.text = ingredients[indexPath.row].quantity
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        return "Ingredients"
    }
}

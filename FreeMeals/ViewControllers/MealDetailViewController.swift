//
//  MealDetailViewController.swift
//  FreeMeals
//
//  Created by Bharat Kumar on 8/23/21.
//

import UIKit

class MealDetailViewController: UIViewController {
    
    //MARK: - Properties
    private var ingredientsButton = UIButton()
    private var mealImageView = UIImageView()
    private var mealNameLabel = UILabel()
    private var instructionTitle = UILabel()
    private var instructionsLabel = UILabel()
    var meal: Meals.Meal?
    var ingredients: [MealIngredients] = []
    var mealDetail: MealDetail?
    
    //MARK: - Computed Properties.
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubviews()
        guard let meal = meal else { return }
        getMealDetails(meal: meal)
        setupScrollView()
        view.backgroundColor = .white
    }
    
    //MARK: - Methods
    /// ScrollView implementation was necessary because the instructions has long information for which the view controller needs to scroll.
    private func setupScrollView(){
        // ScrollView setup
        let contentViewCenterY = contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        contentViewCenterY.priority = .defaultLow
        let contentViewHeight = contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        contentViewHeight.priority = .defaultLow
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        self.scrollView.contentSize = contentView.frame.size
        
        // Scroll View Constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentViewCenterY,
            contentViewHeight
        ])
    }
    
    private func setUpSubviews() {
        // Meal Image Setup
        mealImageView.contentMode = .scaleToFill
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        mealImageView.backgroundColor = .gray
        mealImageView.layer.cornerRadius = 5
        contentView.addSubview(mealImageView)
        // Meal Image Constraints
        mealImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        mealImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        mealImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        mealImageView.heightAnchor.constraint(equalTo: mealImageView.widthAnchor, constant: 1.0).isActive = true
        
        // Meal Name Set up
        mealNameLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        mealNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mealNameLabel)
        
        //mEAL name Constraints
        mealNameLabel.topAnchor.constraint(equalTo: mealImageView.bottomAnchor, constant: 20).isActive = true
        mealNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50).isActive = true
        mealNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50).isActive = true
        
        // Instructions Title Setup
        instructionTitle.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        instructionTitle.lineBreakMode = .byWordWrapping
        instructionTitle.numberOfLines = 0
        instructionTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(instructionTitle)
        
        // Instruction title Label Constraints
        instructionTitle.topAnchor.constraint(equalTo: mealNameLabel.bottomAnchor, constant: 10).isActive = true
        instructionTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50).isActive = true
        instructionTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50).isActive = true
        
        // Instructions Label Setup
        instructionsLabel.font = UIFont(name: "Avenir", size: 12)
        instructionsLabel.lineBreakMode = .byWordWrapping
        instructionsLabel.numberOfLines = 0
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(instructionsLabel)
        
        // Instructions Constraints
        instructionsLabel.topAnchor.constraint(equalTo: instructionTitle.bottomAnchor, constant: 10).isActive = true
        instructionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50).isActive = true
        instructionsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50).isActive = true
        
        // Ingredients Button Set up
        ingredientsButton.setTitle("View Ingredients", for: .normal)
        ingredientsButton.layer.cornerRadius = 12
        ingredientsButton.layer.borderColor = UIColor.black.cgColor
        ingredientsButton.layer.backgroundColor = UIColor.orange.cgColor
        ingredientsButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ingredientsButton)
        
        // Ingredients Button Constraints
        ingredientsButton.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 10).isActive = true
        ingredientsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50).isActive = true
        ingredientsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50).isActive = true
        ingredientsButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5).isActive = true
        ingredientsButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        ingredientsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        ingredientsButton.addTarget(self, action: #selector(ingredientsViewController), for: .touchUpInside)
    }
    
    @objc private func ingredientsViewController() {
        let detailVC = IngredientsTableViewController(nibName: nil, bundle: nil)
        detailVC.ingredients = ingredients
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    //MARK: - Helper Methods
    
    /// Fetching Call for meal details like instructions, ingredients, mealName, measurements.
    /// This method was important to call in the detail view controller so we can grab the existing meal id to fetch meal details
    /// - Parameter meal: Meals.Meal to get the id of the meal
    private func getMealDetails(meal: Meals.Meal) {
        ModelController.shared.getMealsById(mealID: meal.id) { mealDetail, error in
            if let error = error {
                NSLog("There is an error fetching meal details: \(error)")
                return
            }
            guard let mealDetail = mealDetail else { return }
            self.updateViews(mealDetail: mealDetail)
            self.mealDetail = mealDetail
            
            ModelController.shared.getImages(imageURL: mealDetail.mealThumb) { image, _ in
                DispatchQueue.main.async {
                    self.mealImageView.image = image
                }
            }
        }
    }
    
    private func updateViews(mealDetail: MealDetail) {
        self.instructionTitle.text = "Instructions"
        self.mealNameLabel.text = mealDetail.mealName
        self.instructionsLabel.text = mealDetail.instructions
        self.ingredients = mealDetail.ingredients
        
    }
    
}

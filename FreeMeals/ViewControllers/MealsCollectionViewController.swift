//
//  MealsCollectionViewController.swift
//  FreeMeals
//
//  Created by Bharat Kumar on 8/20/21.
//

import UIKit

/// I used storyboard for this part of the app, which is the meals view controller and programmatic constraints for the second part of the project which is meals detail view .
/// This way I can show the both way of implementation.
class MealsViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pickerViewController: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Properties
    private let customCellIdentifier = "mealCellIdentifier"
    private let categoryNames: [String] = []
    private var categories: [Categories.Category] = []
    private var meals: [Meals.Meal] = []
    private var horizontalMeals: CGFloat = 2
    
    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        pickerViewController.delegate = self
        pickerViewController.dataSource = self
        registerCollectionViewCell()
        getAllCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    // MARK: - Helper Methods
    private func setUpCollectionView() {
        view.backgroundColor = .lightGray
        collectionView.backgroundColor = .lightGray
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func registerCollectionViewCell() {
        collectionView.register(MealCollectionViewCell.self, forCellWithReuseIdentifier: customCellIdentifier)
        navigationItem.title = "Home"
        collectionView.backgroundColor = UIColor.white
    }
    
    private func getAllCategories() {
        // Weak self will help us to avoid retain cycle and free up memory.
        ModelController.shared.getCategories { [weak self] categories, error in
            
            if let error = error {
                NSLog("error in fetching categories: \(error)")
                return
            }
            guard let categories = categories else {
                NSLog("Categories not found")
                return
            }
            
            self?.categories = categories.categories
            DispatchQueue.main.async {
                
                self?.pickerViewController.reloadAllComponents()
                self?.collectionView.reloadData()
            }
        }
    }
    
    /// Fetch meals by category name method
    /// - Parameter category: String -> implemented this method to use pickerview controller categories selection value
    private func fetchMealsByCategory(category: String) {
        ModelController.shared.getMeals(category: category) { [weak self] meals, error in
            
            if let error = error {
                NSLog("error in fetching meals: \(error)")
                return
            }
            
            guard let meals = meals else {
                NSLog("meals not found")
                return
            }
            
            self?.meals = meals.meals
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
    }
    
}

// MARK: UICollectionViewDataSource
extension MealsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalInsets = collectionView.contentInset.left + collectionView.contentInset.right
        let itemSpacing = (collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing * (horizontalMeals - 1)
        let width = (collectionView.frame.width - horizontalInsets - itemSpacing) / horizontalMeals
        return CGSize(width: width, height: width * 1.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.meals.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: customCellIdentifier, for: indexPath) as? MealCollectionViewCell else { return UICollectionViewCell() }
        
        cell.meal = meals[indexPath.row]
        cell.setNeedsLayout()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mealsDetailViewController = MealDetailViewController()
        
        let collectionMeal = meals[indexPath.row]
        mealsDetailViewController.meal = collectionMeal
        navigationController?.pushViewController(mealsDetailViewController, animated: true)
    }
}

extension MealsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].category
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCat = categories[row].category
        print("selectedCat   \(selectedCat)")
        self.fetchMealsByCategory(category: selectedCat)
        
    }
}

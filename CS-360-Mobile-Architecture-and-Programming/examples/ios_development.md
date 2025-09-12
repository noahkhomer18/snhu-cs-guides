# CS-360 iOS Development

## 🎯 Purpose
Demonstrate iOS app development with Swift, including ViewControllers, Core Data, and networking.

## 📝 iOS Development Examples

### Basic iOS ViewController (Swift)
```swift
// ViewController.swift
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var greetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        // Configure text field
        nameTextField.placeholder = "Enter your name"
        nameTextField.borderStyle = .roundedRect
        
        // Configure button
        greetButton.setTitle("Greet", for: .normal)
        greetButton.backgroundColor = .systemBlue
        greetButton.layer.cornerRadius = 8
        
        // Configure label
        greetingLabel.text = ""
        greetingLabel.textAlignment = .center
        greetingLabel.numberOfLines = 0
    }
    
    @IBAction func greetButtonTapped(_ sender: UIButton) {
        greetUser()
    }
    
    private func greetUser() {
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(title: "Error", message: "Please enter your name")
            return
        }
        
        let greeting = "Hello, \(name)! Welcome to iOS!"
        greetingLabel.text = greeting
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
```

### Table View Controller
```swift
// UsersTableViewController.swift
import UIKit

class UsersTableViewController: UITableViewController {
    
    private var users: [User] = []
    private let dataManager = DataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadUsers()
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UserCell")
        navigationItem.title = "Users"
        
        // Add bar button items
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addUserTapped)
        )
    }
    
    private func loadUsers() {
        dataManager.fetchUsers { [weak self] users in
            DispatchQueue.main.async {
                self?.users = users
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc private func addUserTapped() {
        let alert = UIAlertController(title: "Add User", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Name"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Phone"
            textField.keyboardType = .phonePad
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let name = alert.textFields?[0].text,
                  let email = alert.textFields?[1].text,
                  let phone = alert.textFields?[2].text else { return }
            
            let user = User(name: name, email: email, phone: phone)
            self?.addUser(user)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func addUser(_ user: User) {
        dataManager.saveUser(user) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.loadUsers()
                } else {
                    self?.showAlert(title: "Error", message: "Failed to save user")
                }
            }
        }
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = users[indexPath.row]
        showUserDetail(user)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let user = users[indexPath.row]
            deleteUser(user, at: indexPath)
        }
    }
    
    private func showUserDetail(_ user: User) {
        let alert = UIAlertController(title: user.name, message: "Email: \(user.email)\nPhone: \(user.phone)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func deleteUser(_ user: User, at indexPath: IndexPath) {
        dataManager.deleteUser(user) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.users.remove(at: indexPath.row)
                    self?.tableView.deleteRows(at: [indexPath], with: .fade)
                } else {
                    self?.showAlert(title: "Error", message: "Failed to delete user")
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
```

### User Model
```swift
// User.swift
import Foundation

struct User: Codable {
    let id: Int?
    let name: String
    let email: String
    let phone: String
    
    init(id: Int? = nil, name: String, email: String, phone: String) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
    }
}

// MARK: - Equatable
extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
```

### Core Data Manager
```swift
// CoreDataManager.swift
import CoreData
import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UserModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func saveUser(_ user: User, completion: @escaping (Bool) -> Void) {
        let userEntity = UserEntity(context: context)
        userEntity.name = user.name
        userEntity.email = user.email
        userEntity.phone = user.phone
        
        do {
            try context.save()
            completion(true)
        } catch {
            print("Error saving user: \(error)")
            completion(false)
        }
    }
    
    func fetchUsers(completion: @escaping ([User]) -> Void) {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        
        do {
            let userEntities = try context.fetch(request)
            let users = userEntities.map { entity in
                User(name: entity.name ?? "", email: entity.email ?? "", phone: entity.phone ?? "")
            }
            completion(users)
        } catch {
            print("Error fetching users: \(error)")
            completion([])
        }
    }
    
    func deleteUser(_ user: User, completion: @escaping (Bool) -> Void) {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@ AND email == %@", user.name, user.email)
        
        do {
            let userEntities = try context.fetch(request)
            for entity in userEntities {
                context.delete(entity)
            }
            try context.save()
            completion(true)
        } catch {
            print("Error deleting user: \(error)")
            completion(false)
        }
    }
}
```

### Network Manager
```swift
// NetworkManager.swift
import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let session = URLSession.shared
    private let baseURL = "https://api.example.com"
    
    private init() {}
    
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/users") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                completion(.success(users))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func createUser(_ user: User, completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/users") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            completion(.failure(error))
            return
        }
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let createdUser = try JSONDecoder().decode(User.self, from: data)
                completion(.success(createdUser))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func updateUser(_ user: User, completion: @escaping (Result<User, Error>) -> Void) {
        guard let id = user.id,
              let url = URL(string: "\(baseURL)/users/\(id)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            completion(.failure(error))
            return
        }
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let updatedUser = try JSONDecoder().decode(User.self, from: data)
                completion(.success(updatedUser))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func deleteUser(id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/users/\(id)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        session.dataTask(with: request) { _, _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}
```

### Data Manager
```swift
// DataManager.swift
import Foundation

class DataManager {
    static let shared = DataManager()
    
    private let coreDataManager = CoreDataManager.shared
    private let networkManager = NetworkManager.shared
    
    private init() {}
    
    func fetchUsers(completion: @escaping ([User]) -> Void) {
        // First try to fetch from network
        networkManager.fetchUsers { [weak self] result in
            switch result {
            case .success(let users):
                // Save to Core Data
                for user in users {
                    self?.coreDataManager.saveUser(user) { _ in }
                }
                completion(users)
            case .failure:
                // Fallback to Core Data
                self?.coreDataManager.fetchUsers(completion: completion)
            }
        }
    }
    
    func saveUser(_ user: User, completion: @escaping (Bool) -> Void) {
        // Save to Core Data first
        coreDataManager.saveUser(user) { [weak self] success in
            if success {
                // Then try to sync with network
                self?.networkManager.createUser(user) { result in
                    switch result {
                    case .success:
                        completion(true)
                    case .failure:
                        // Still return success since it's saved locally
                        completion(true)
                    }
                }
            } else {
                completion(false)
            }
        }
    }
    
    func deleteUser(_ user: User, completion: @escaping (Bool) -> Void) {
        // Delete from Core Data
        coreDataManager.deleteUser(user) { [weak self] success in
            if success {
                // Try to delete from network if we have an ID
                if let id = user.id {
                    self?.networkManager.deleteUser(id: id) { _ in }
                }
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
```

### Custom Collection View Cell
```swift
// UserCollectionViewCell.swift
import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        // Configure cell appearance
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        
        // Configure labels
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        emailLabel.font = UIFont.systemFont(ofSize: 14)
        phoneLabel.font = UIFont.systemFont(ofSize: 12)
        
        // Configure image view
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.clipsToBounds = true
        avatarImageView.backgroundColor = .systemBlue
    }
    
    func configure(with user: User) {
        nameLabel.text = user.name
        emailLabel.text = user.email
        phoneLabel.text = user.phone
        
        // Generate initials for avatar
        let initials = user.name.components(separatedBy: " ").compactMap { $0.first }.map { String($0) }.joined()
        avatarImageView.image = generateAvatarImage(initials: initials)
    }
    
    private func generateAvatarImage(initials: String) -> UIImage? {
        let size = CGSize(width: 50, height: 50)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            UIColor.systemBlue.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.white,
                .font: UIFont.boldSystemFont(ofSize: 20)
            ]
            
            let textSize = initials.size(withAttributes: attributes)
            let textRect = CGRect(
                x: (size.width - textSize.width) / 2,
                y: (size.height - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            
            initials.draw(in: textRect, withAttributes: attributes)
        }
    }
}
```

## 🔍 iOS Concepts
- **ViewControllers**: Main components of iOS apps
- **Storyboards**: Visual interface design
- **Core Data**: Local database storage
- **Table Views**: List display components
- **Collection Views**: Grid display components
- **Networking**: URLSession for HTTP requests
- **Model-View-Controller**: Architecture pattern
- **Delegates**: Communication between objects

## 💡 Learning Points
- **ViewControllers** manage screen content and user interaction
- **Storyboards** provide visual interface design
- **Core Data** offers powerful local data persistence
- **Table Views** efficiently display lists of data
- **Collection Views** create flexible grid layouts
- **URLSession** handles network communication
- **MVC pattern** separates concerns in app architecture
- **Delegates** enable loose coupling between components

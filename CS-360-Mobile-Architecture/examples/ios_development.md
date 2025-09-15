# CS-360 iOS Mobile Development

## 🎯 Purpose
Demonstrate iOS app development with Swift and SwiftUI, including UI design, data management, and iOS-specific features.

## 📝 iOS Development Examples

### SwiftUI Basic App Structure
```swift
import SwiftUI

// Main App Structure
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// Content View with Navigation
struct ContentView: View {
    @StateObject private var userStore = UserStore()
    @State private var showingAddUser = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(userStore.users) { user in
                    UserRowView(user: user)
                }
                .onDelete(perform: deleteUsers)
            }
            .navigationTitle("Users")
            .navigationBarItems(
                trailing: Button("Add User") {
                    showingAddUser = true
                }
            )
            .sheet(isPresented: $showingAddUser) {
                AddUserView(userStore: userStore)
            }
        }
    }
    
    func deleteUsers(offsets: IndexSet) {
        userStore.users.remove(atOffsets: offsets)
    }
}

// User Model
struct User: Identifiable, Codable {
    let id = UUID()
    var name: String
    var email: String
    var age: Int
    var profileImage: String?
}

// User Row View
struct UserRowView: View {
    let user: User
    
    var body: some View {
        HStack {
            // Profile Image
            AsyncImage(url: URL(string: user.profileImage ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Image(systemName: "person.circle.fill")
                    .foregroundColor(.gray)
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.headline)
                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Age: \(user.age)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// Add User View
struct AddUserView: View {
    @ObservedObject var userStore: UserStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var email = ""
    @State private var age = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User Information")) {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    TextField("Age", text: $age)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Add User")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveUser()
                }
                .disabled(name.isEmpty || email.isEmpty || age.isEmpty)
            )
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func saveUser() {
        guard let ageInt = Int(age), ageInt > 0 else {
            alertMessage = "Please enter a valid age"
            showingAlert = true
            return
        }
        
        guard email.contains("@") else {
            alertMessage = "Please enter a valid email"
            showingAlert = true
            return
        }
        
        let newUser = User(name: name, email: email, age: ageInt)
        userStore.users.append(newUser)
        presentationMode.wrappedValue.dismiss()
    }
}

// User Store (ObservableObject)
class UserStore: ObservableObject {
    @Published var users: [User] = []
    
    init() {
        loadUsers()
    }
    
    private func loadUsers() {
        // Load from UserDefaults or Core Data
        if let data = UserDefaults.standard.data(forKey: "users"),
           let decodedUsers = try? JSONDecoder().decode([User].self, from: data) {
            users = decodedUsers
        }
    }
    
    func saveUsers() {
        if let encoded = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(encoded, forKey: "users")
        }
    }
}
```

### Core Data Integration
```swift
import CoreData
import SwiftUI

// Core Data Stack
class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "UserModel")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}

// Core Data Model (UserModel.xcdatamodeld)
// Entity: UserEntity
// Attributes: id (UUID), name (String), email (String), age (Int32), createdAt (Date)

// User Entity Extension
extension UserEntity {
    convenience init(context: NSManagedObjectContext, name: String, email: String, age: Int32) {
        self.init(context: context)
        self.id = UUID()
        self.name = name
        self.email = email
        self.age = age
        self.createdAt = Date()
    }
}

// Core Data User Store
class CoreDataUserStore: ObservableObject {
    @Published var users: [UserEntity] = []
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchUsers()
    }
    
    func fetchUsers() {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \UserEntity.createdAt, ascending: false)]
        
        do {
            users = try context.fetch(request)
        } catch {
            print("Error fetching users: \(error)")
        }
    }
    
    func addUser(name: String, email: String, age: Int32) {
        let newUser = UserEntity(context: context, name: name, email: email, age: age)
        saveContext()
        fetchUsers()
    }
    
    func deleteUser(_ user: UserEntity) {
        context.delete(user)
        saveContext()
        fetchUsers()
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

// Core Data Content View
struct CoreDataContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var userStore: CoreDataUserStore
    @State private var showingAddUser = false
    
    init() {
        let context = PersistenceController.shared.container.viewContext
        _userStore = StateObject(wrappedValue: CoreDataUserStore(context: context))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(userStore.users, id: \.id) { user in
                    VStack(alignment: .leading) {
                        Text(user.name ?? "Unknown")
                            .font(.headline)
                        Text(user.email ?? "No email")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("Age: \(user.age)")
                            .font(.caption)
                    }
                }
                .onDelete(perform: deleteUsers)
            }
            .navigationTitle("Core Data Users")
            .navigationBarItems(
                trailing: Button("Add User") {
                    showingAddUser = true
                }
            )
            .sheet(isPresented: $showingAddUser) {
                AddUserView(userStore: userStore)
            }
        }
    }
    
    private func deleteUsers(offsets: IndexSet) {
        for index in offsets {
            let user = userStore.users[index]
            userStore.deleteUser(user)
        }
    }
}
```

### Network Requests and API Integration
```swift
import Foundation
import Combine

// API Service
class APIService: ObservableObject {
    static let shared = APIService()
    private let session = URLSession.shared
    private var cancellables = Set<AnyCancellable>()
    
    private init() {}
    
    // Generic API Request
    func request<T: Codable>(_ endpoint: APIEndpoint) -> AnyPublisher<T, Error> {
        guard let url = endpoint.url else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = endpoint.body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        
        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

// API Endpoints
enum APIEndpoint {
    case getUsers
    case createUser(UserRequest)
    case updateUser(id: String, UserRequest)
    case deleteUser(id: String)
    
    var url: URL? {
        let baseURL = "https://api.example.com"
        switch self {
        case .getUsers:
            return URL(string: "\(baseURL)/users")
        case .createUser:
            return URL(string: "\(baseURL)/users")
        case .updateUser(let id, _):
            return URL(string: "\(baseURL)/users/\(id)")
        case .deleteUser(let id):
            return URL(string: "\(baseURL)/users/\(id)")
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUsers:
            return .GET
        case .createUser:
            return .POST
        case .updateUser:
            return .PUT
        case .deleteUser:
            return .DELETE
        }
    }
    
    var body: Codable? {
        switch self {
        case .createUser(let userRequest), .updateUser(_, let userRequest):
            return userRequest
        default:
            return nil
        }
    }
}

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

enum APIError: Error {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
}

// API Models
struct UserRequest: Codable {
    let name: String
    let email: String
    let age: Int
}

struct UserResponse: Codable, Identifiable {
    let id: String
    let name: String
    let email: String
    let age: Int
    let createdAt: String
}

// Network User Store
class NetworkUserStore: ObservableObject {
    @Published var users: [UserResponse] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService = APIService.shared
    private var cancellables = Set<AnyCancellable>()
    
    func fetchUsers() {
        isLoading = true
        errorMessage = nil
        
        apiService.request<[UserResponse]>(.getUsers)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] users in
                    self?.users = users
                }
            )
            .store(in: &cancellables)
    }
    
    func createUser(name: String, email: String, age: Int) {
        let userRequest = UserRequest(name: name, email: email, age: age)
        
        apiService.request<UserResponse>(.createUser(userRequest))
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Error creating user: \(error)")
                    }
                },
                receiveValue: { [weak self] newUser in
                    self?.users.append(newUser)
                }
            )
            .store(in: &cancellables)
    }
    
    func deleteUser(id: String) {
        apiService.request<EmptyResponse>(.deleteUser(id: id))
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Error deleting user: \(error)")
                    }
                },
                receiveValue: { [weak self] _ in
                    self?.users.removeAll { $0.id == id }
                }
            )
            .store(in: &cancellables)
    }
}

struct EmptyResponse: Codable {}
```

### iOS-Specific Features
```swift
import SwiftUI
import CoreLocation
import UserNotifications
import AVFoundation

// Location Services
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startLocationUpdates() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            return
        }
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
    }
}

// Push Notifications
class NotificationManager: ObservableObject {
    @Published var authorizationStatus: UNAuthorizationStatus = .notDetermined
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                self.authorizationStatus = granted ? .authorized : .denied
            }
        }
    }
    
    func scheduleNotification(title: String, body: String, timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}

// Camera Integration
struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// Haptic Feedback
class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}

// Usage Example
struct FeatureDemoView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var notificationManager = NotificationManager()
    @State private var selectedImage: UIImage?
    @State private var showingCamera = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Location
            if let location = locationManager.location {
                Text("Lat: \(location.coordinate.latitude, specifier: "%.4f")")
                Text("Lng: \(location.coordinate.longitude, specifier: "%.4f")")
            } else {
                Text("Location not available")
            }
            
            Button("Request Location") {
                locationManager.requestLocationPermission()
                locationManager.startLocationUpdates()
            }
            
            // Camera
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
            }
            
            Button("Take Photo") {
                showingCamera = true
            }
            .sheet(isPresented: $showingCamera) {
                CameraView(image: $selectedImage)
            }
            
            // Notifications
            Button("Schedule Notification") {
                notificationManager.scheduleNotification(
                    title: "Test Notification",
                    body: "This is a test notification",
                    timeInterval: 5
                )
            }
            
            // Haptic Feedback
            VStack {
                Button("Light Impact") {
                    HapticManager.shared.impact(.light)
                }
                Button("Medium Impact") {
                    HapticManager.shared.impact(.medium)
                }
                Button("Heavy Impact") {
                    HapticManager.shared.impact(.heavy)
                }
            }
        }
        .padding()
        .onAppear {
            notificationManager.requestNotificationPermission()
        }
    }
}
```

## 🔍 iOS Development Concepts
- **SwiftUI**: Declarative UI framework for modern iOS development
- **Core Data**: Apple's object graph and persistence framework
- **Combine**: Reactive programming framework for handling asynchronous events
- **iOS Features**: Location services, push notifications, camera integration
- **Architecture**: MVVM pattern with ObservableObject and @Published properties

## 💡 Learning Points
- SwiftUI uses declarative syntax for building user interfaces
- Core Data provides powerful data persistence capabilities
- Combine enables reactive programming patterns
- iOS-specific features enhance user experience
- Proper error handling and loading states improve app reliability

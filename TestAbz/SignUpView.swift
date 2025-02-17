

import SwiftUI
import PhotosUI

struct SignUpView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var selectedPosition: TypePosition = .frontend
    @State private var isPhotoUploaded: Bool = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var photoPath: String? = nil
    @State private var uploadErrorMessage: String? = nil
    @State private var isLoading = false
    @State private var showError: Bool = false
    @State private var errorMessage: String?
    
    var positions: [TypePosition] = [.frontend, .backend, .designer, .qa]
    
    var canSignUp: Bool {
        ValidatorManager.isValid(name: name, email: email, phone: phone) &&
        !phone.isEmpty && isPhotoUploaded
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                CustomTextField(placeholder: "Your name", text: $name)
                CustomTextField(placeholder: "Email", text: $email, isEmail: true)
                CustomTextField(placeholder: "Phone", text: $phone, isPhone: true)
                
                Text("Select your position")
                    .font(.custom(NutinoSansFont.regular.rawValue, size: 18))
                    .foregroundColor(Color(Colors.textDarkDrayColor.rawValue))
                    .padding(.top, 10)
                
                ForEach(positions, id: \.self) { position in
                    HStack {
                        Image(selectedPosition == position ? "BlueRound" : "GrayRound")
                            .foregroundColor(.blue)
                        Text(position.rawValue)
                            .font(.custom(NutinoSansFont.regular.rawValue, size: 16))
                            .foregroundColor(Color(Colors.textDarkDrayColor.rawValue))
                            .padding(.leading, 15)
                    }
                    .padding(.top, 10)
                    .padding(.leading, 15)
                    .onTapGesture {
                        selectedPosition = position
                    }
                }
                
                Spacer(minLength: 10)
                HStack {
                    Text("Upload your photo")
                        .foregroundColor(isPhotoUploaded ? Color(Colors.textGrayColor.rawValue) : Color(Colors.redColor.rawValue))
                        .font(.custom(NutinoSansFont.regular.rawValue, size: 16))
                    Spacer()
                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                        Text("Upload")
                            .foregroundColor(Color(Colors.textBlueColor.rawValue))
                            .font(.custom(NutinoSansFont.regular.rawValue, size: 16))
                    }
                    .onChange(of: selectedPhotoItem) { newItem in
                        if let newItem {
                            Task {
                                do {
                                    if let data = try await newItem.loadTransferable(type: Data.self),
                                       let image = UIImage(data: data),
                                       let jpegData = image.jpegData(compressionQuality: 0.8) {
                                        let isValidSize = image.size.width >= 70 && image.size.height >= 70
                                        let isValidFormat = newItem.supportedContentTypes.contains(.jpeg) || newItem.supportedContentTypes.contains(.image)
                                        let isValidFileSize = jpegData.count <= 5_000_000
                                        
                                        if isValidSize && isValidFormat && isValidFileSize {
                                            selectedImage = image
                                            photoPath = saveImageToFile(image: image)
                                            isPhotoUploaded = true
                                            uploadErrorMessage = nil
                                        } else {
                                            isPhotoUploaded = false
                                            uploadErrorMessage = "Photo is required"
                                        }
                                    }
                                } catch {
                                    uploadErrorMessage = "Photo is required"
                                    isPhotoUploaded = false
                                }
                            }
                        }
                    }
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(isPhotoUploaded
                                                                  ? Color(Colors.textGrayColor.rawValue)
                                                                  : Color(Colors.redColor.rawValue), lineWidth: 1))
                
                if let uploadErrorMessage = uploadErrorMessage {
                    ErrorText(message: uploadErrorMessage)
                        .padding(.leading, 15)
                }
                
                if let errorMessage = errorMessage {
                    ErrorText(message: errorMessage)
                        .padding(.leading, 15)
                }
                
            }
          
                    Button(action: {
                        registerUser()
                    }) {
                        Text("Sign up")
                            .foregroundColor(canSignUp
                                             ? Color(Colors.textDarkDrayColor.rawValue)
                                             : Color(Colors.textLightGrayColor.rawValue))
                            .frame(minWidth: 140, maxHeight: 50)
                            .padding()
                            .background(canSignUp
                                        ? Color(Colors.yellowColor.rawValue)
                                        : Color(Colors.grayColor.rawValue))
                            .cornerRadius(24)
                    }
                    .disabled(!canSignUp || isLoading)
                    .padding()
                 
                }
             
                .padding(.horizontal, 16)
         
        }
   
    
    func handlePhotoSelection(_ newItem: PhotosPickerItem?) {
        guard let newItem else { return }
        Task {
            do {
                if let data = try await newItem.loadTransferable(type: Data.self),
                   let image = UIImage(data: data),
                   let jpegData = image.jpegData(compressionQuality: 0.8) {
                    let isValidSize = image.size.width >= 70 && image.size.height >= 70
                    let isValidFormat = newItem.supportedContentTypes.contains(.jpeg) || newItem.supportedContentTypes.contains(.image)
                    let isValidFileSize = jpegData.count <= 5_000_000
                    
                    if isValidSize && isValidFormat && isValidFileSize {
                        selectedImage = image
                        photoPath = saveImageToFile(image: image)
                        isPhotoUploaded = true
                        uploadErrorMessage = nil
                    } else {
                        isPhotoUploaded = false
                        uploadErrorMessage = "Photo must be JPG, at least 70x70px, max 5MB"
                    }
                }
            } catch {
                uploadErrorMessage = "Failed to load image"
                isPhotoUploaded = false
            }
        }
    }
    
    func saveImageToFile(image: UIImage) -> String? {
        if let data = image.jpegData(compressionQuality: 0.8) {
            let filename = UUID().uuidString + ".jpg"
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
            do {
                try data.write(to: url)
                return url.path
            } catch {
                print("Error saving photo: \(error)")
            }
        }
        return nil
    }
    
    func fetchUsers(page: Int, count: Int, completion: @escaping ([User]?, Error?) -> Void) {
        let urlString = "https://frontend-test-assignment-api.abz.agency/api/v1/users?page=\(page)&count=\(count)"
        
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "Invalid URL", code: 400, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No data", code: 404, userInfo: nil))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(UsersResponse.self, from: data)
                completion(decodedResponse.users, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    func fetchToken(completion: @escaping (String?, Error?) -> Void) {
        let urlString = "https://frontend-test-assignment-api.abz.agency/api/v1/token"
        
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "Invalid URL", code: 400, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No data", code: 404, userInfo: nil))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let token = json["token"] as? String {
                    print(" token = \(token)")
                    completion(token, nil)
                } else {
                    completion(nil, NSError(domain: "Invalid token format", code: 500, userInfo: nil))
                }
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    func getNextUserId(from users: [User]) -> Int {
        guard let maxId = users.map({ $0.id }).max() else {
            return 1
        }
        return maxId + 1
    }
    
    func registerUser() {
        print("Starting registration process...")
        
        fetchToken { token, error in
            if let error = error {
                print("Failed to fetch token: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch token: \(error.localizedDescription)"
                }
                return
            }
            
            guard let token = token else {
                print("No token received")
                DispatchQueue.main.async {
                    self.errorMessage = "No token received"
                }
                return
            }
            
            print("Token received: \(token)")
            
            self.fetchUsers(page: 1, count: 100) { users, error in
                if let error = error {
                    print("Failed to fetch users: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to fetch users: \(error.localizedDescription)"
                    }
                    return
                }
                
                guard let users = users else {
                    print("No users found")
                    DispatchQueue.main.async {
                        self.errorMessage = "No users found"
                    }
                    return
                }
                
                print("Users fetched successfully. Total users: \(users.count)")
                
                let nextUserId = self.getNextUserId(from: users)
                print("Next user ID: \(nextUserId)")
                
                self.registerNewUser(with: nextUserId, token: token)
            }
        }
    }
    
    func registerNewUser(with id: Int, token: String) {
        guard let photoPath = self.photoPath else {
            print("Photo is required")
            DispatchQueue.main.async {
                self.errorMessage = "Photo is required"
            }
            return
        }
        
        print("Preparing to register new user with ID: \(id)")
        
        let url = URL(string: "https://frontend-test-assignment-api.abz.agency/api/v1/users")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(token, forHTTPHeaderField: "Token")
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        let newline = "\r\n"
        
        func append(_ string: String) {
            if let data = string.data(using: .utf8) {
                body.append(data)
            }
        }
        
        append("--\(boundary)\(newline)")
        append("Content-Disposition: form-data; name=\"name\"\r\n\r\n")
        append("\(name)\r\n")
        
        append("--\(boundary)\(newline)")
        append("Content-Disposition: form-data; name=\"email\"\r\n\r\n")
        append("\(email)\r\n")
        
        append("--\(boundary)\(newline)")
        append("Content-Disposition: form-data; name=\"phone\"\r\n\r\n")
        append("\(phone)\r\n")
        
        append("--\(boundary)\(newline)")
        append("Content-Disposition: form-data; name=\"position_id\"\r\n\r\n")
        append("\(selectedPosition.id)\r\n")
        
        if let photoData = try? Data(contentsOf: URL(fileURLWithPath: photoPath)) {
            append("--\(boundary)\(newline)")
            append("Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n")
            append("Content-Type: image/jpeg\r\n\r\n")
            body.append(photoData)
            append("\r\n")
        }
        
        append("--\(boundary)--\r\n")
        request.httpBody = body
        
        self.isLoading = true
        self.errorMessage = nil
        
        print("Sending registration request...")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    print("Request failed: \(error.localizedDescription)")
                    self.errorMessage = "Request failed: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    self.errorMessage = "No data received"
                    return
                }
                
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Response: \(json)")
                    
                    if let success = json["success"] as? Bool, success {
                        print("User registered successfully!")
                        self.errorMessage = nil
                    } else {
                        let message = json["message"] as? String ?? "Registration failed"
                        print("Registration failed: \(message)")
                        self.errorMessage = message
                    }
                } else {
                    print("Invalid response format")
                    self.errorMessage = "Invalid response format"
                }
            }
        }.resume()
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var isEmail: Bool = false
    var isPhone: Bool = false
    
    var isValid: Bool {
        if text.isEmpty { return true }
        if isEmail {
            return ValidatorManager.isValidEmail(text)
        } else if isPhone {
            return ValidatorManager.isValidPhone(text)
        } else {
            return ValidatorManager.isValidName(text)
        }
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            TextField(placeholder, text: $text)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(isValid ? Color(Colors.tFBorderColor.rawValue)
                                                                  : Color(Colors.redColor.rawValue),
                                                                  lineWidth: 1))
                .font(.custom(NutinoSansFont.regular.rawValue, size: 16))
            
            Text(isEmail ? "Invalid email format" : isPhone ? "Invalid phone number" : "Name must be 2-10 characters")
                .foregroundColor(Color(Colors.redColor.rawValue))
                .font(.custom(NutinoSansFont.light.rawValue, size: 12))
                .padding(.leading, 15)
                .padding(.top, 3)
                .opacity(isValid ? 0 : 1)
        }
        
        
    }
}


struct ErrorText: View {
    var message: String
    
    var body: some View {
        Text(message)
            .foregroundColor(Color(Colors.redColor.rawValue))
            .font(.custom(NutinoSansFont.light.rawValue, size: 12))
            .padding(.leading, 5)
    }
}

#Preview {
    SignUpView()
}




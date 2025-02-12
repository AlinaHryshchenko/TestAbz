import SwiftUI
import PhotosUI

struct SignUpView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var selectedPosition: TypePosition = .frontend
    @State private var isPhotoUploaded: Bool = false
    @State private var showError: Bool = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var selectedPickerItem: PhotosPickerItem? = nil
    @State private var photoPath: String? = nil
    
    var positions: [TypePosition] = [.frontend, .backend, .designer, .qa]
        
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    var canSignUp: Bool {
        !name.isEmpty && isValidEmail && !phone.isEmpty && isPhotoUploaded
    }
    
   
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                CustomTextField(placeholder: "Your name", text: $name)
                CustomTextField(placeholder: "Email", text: $email, isEmail: true)
                CustomTextField(placeholder: "Phone", text: $phone)
                
                Text("Select your position")
                    .font(.custom(NutinoSansFont.regular.rawValue, size: 18))
                    .foregroundColor(Color(Colors.textDarkDrayColor.rawValue))
                    .padding(.top, 10)
                
                ForEach(positions, id: \.self) { position in
                    
                    HStack {
                        Image(systemName: selectedPosition == position ? "largecircle.fill.circle" : "circle")
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
                    
                    .onChange(of: selectedPickerItem) { newItem in
                        if let newItem {
                            Task {
                                if let data = try? await newItem.loadTransferable(type: Data.self),
                                   let image = UIImage(data: data) {
                                    selectedImage = image
                                    photoPath = saveImageToFile(image: image)
                                }
                            }
                        }
                    }
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(isPhotoUploaded
                    ? Color.blue
                    : Color(Colors.redColor.rawValue), lineWidth: 1))
                
                if !isPhotoUploaded && showError {
                    ErrorText(message: "Photo is required")
                }
            }
            .padding()
            Button(action: {
                showError = true
                // if canSignUp {
                //  let newUser = User(image: Image("EmptyPhoto"), name: name, email: email, phone: phone, position: selectedPosition)
                //  let newUser: [User] = []
                //  usersArray.append(newUser)
                //  selectedTab = 0
                // }
            }) {
                Text("Sign up")
                    .foregroundColor(canSignUp
                                     ? Color(Colors.textDarkDrayColor.rawValue)
                                     : Color(Colors.textLightGrayColor.rawValue)
                    )
                    .frame(minWidth: 140, maxHeight: 50)
                    .padding()
                    .background(canSignUp 
                                ? Color(Colors.yellowColor.rawValue)
                                : Color(Colors.grayColor.rawValue)
                    )
                    .cornerRadius(24)
            }
            .disabled(!canSignUp)
            .padding()
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
                   print("Ошибка сохранения фото: \(error)")
               }
           }
           return nil
       }
}


struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var isEmail: Bool = false
        
        var isValid: Bool {
            return !text.isEmpty && (!isEmail || NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: text))
        }
    
    var body: some View {
           VStack(alignment: .leading, spacing: 2) {
               TextField(placeholder, text: $text)
                   .padding()
                   .overlay(RoundedRectangle(cornerRadius: 8).stroke(isValid ? Color(Colors.tFBorderColor.rawValue)
                     : Color(Colors.redColor.rawValue),
                                                                     lineWidth: 1))
                   .font(.custom(NutinoSansFont.regular.rawValue, size: 16))
                   
               Text(isEmail ? "Invalid email format" : "Required field")
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
            .foregroundColor(.red)
            .font(.caption)
            .padding(.leading, 5)
    }
}

#Preview {
    SignUpView()
}

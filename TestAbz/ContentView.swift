
import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State var usersArray: [User] = []
  
    var body: some View {
        VStack {
            TopToolbar(title: "Working with GET request")
                .padding(.top, 10)
            
            if selectedTab == 0 {
                UsersListView(users: usersArray)
                
            } else {
                SignUpView()
            }
            
            Spacer()
            BottomTabBar(selectedTab: $selectedTab)
            
        }
        .onAppear {
                   fetchUsers(page: 1, count: 10) { users, error in
                       if let users = users {
                           DispatchQueue.main.async {
                               usersArray = users
                           }
                       } else {
                           print("Ошибка загрузки пользователей:", error?.localizedDescription ?? "Неизвестная ошибка")
                       }
                   }
            
               }
    }
}


struct UsersListView: View {
    var users: [User]

    var body: some View {
        List(users) { user in
            HStack(alignment: .top) {
                AsyncImage(url: URL(string: user.photo)) { image in
                    image.resizable()
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .padding(.horizontal, 10)
                    
                VStack(alignment: .leading) {
                    Text(user.name)
                        .font(.custom(NutinoSansFont.regular.rawValue, size: 18))
                    
                        .foregroundColor(Color("TextDarkDrayColor", bundle: nil))
                        .lineLimit(nil)
                    Spacer(minLength: 0)
                    
                    Text(user.position)
                        .font(.custom(NutinoSansFont.light.rawValue, size: 14))
                        .foregroundColor(Color("TextLightGrayColor", bundle: nil))
                        .lineLimit(nil)
                    Spacer(minLength: 0)
                    Text(user.email)
                        .font(.custom(NutinoSansFont.regular.rawValue, size: 14))
                        .foregroundColor(Color("TextDarkDrayColor", bundle: nil))
                        .lineLimit(nil)
                    Spacer(minLength: 5)
                    Text(user.phone)
                        .font(.custom(NutinoSansFont.regular.rawValue, size: 14))
                        .foregroundColor(Color("TextDarkDrayColor", bundle: nil))
                        .lineLimit(nil)
                }
            }
            .padding(.vertical, 15)
        }
        .listStyle(PlainListStyle())
        .background(Color.white)
        Spacer()

    }
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

#Preview {
    ContentView()
}



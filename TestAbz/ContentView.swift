
import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    var usersArray: [User] = [
        User(image: Image("EmptyPhoto"),
             name: "Malcolm Bailey", email: "jany_murazik51@hotmail.com", phone: "+38 (098) 278 76 24", position: .frontend),
        User(image: Image("EmptyPhoto"),
             name: "Seraphina Anastasia Isolde Aurelia Celestina von Hohenzollern", email: "jany_murazik51@hotmail.com", phone: "+38 (098) 278 76 24", position: .frontend)
    ]
    
    var body: some View {
        VStack {
            TopToolbar(title: "Working with GET request")
                .padding(.top, 10)
            if selectedTab == 0 {
                VStack {
                    List(usersArray, id: \.name) { user in
                        HStack(alignment: .top) {
                            user.image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .padding(.top, 0)
                            VStack(alignment: .leading) {
                                Text(user.name)
                                    .font(.custom("Nunito Sans", size: 18))
                                    .foregroundColor(Color("TextDarkDrayColor", bundle: nil))
                                    .lineLimit(nil)
                                Spacer(minLength: 5)
                                Text(user.position.rawValue)
                                    .font(.custom("Nunito Sans", size: 14))
                                    .foregroundColor(Color("TextLightGrayColor", bundle: nil))
                                    .lineLimit(nil)
                                Spacer(minLength: 5)
                                Text(user.email)
                                    .font(.custom("Nunito Sans", size: 14))
                                    .foregroundColor(Color("TextDarkDrayColor", bundle: nil))
                                
                                    .lineLimit(nil)
                                Spacer(minLength: 5)
                                Text(user.phone)
                                    .font(.custom("Nunito Sans", size: 14))
                                    .foregroundColor(Color("TextDarkDrayColor", bundle: nil))
                                    .lineLimit(nil)
                            }
                            .padding(.leading, 10)
                        }
                        .padding(.vertical, 15)
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.white)
                    Spacer()
                }
            } else {
                SignUpView()
            }
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    selectedTab = 0
                }) {
                    HStack {
                        Image("ThreePearson")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        
                        Text("Users")
                            .font(.custom("Nunito Sans", size: 16))
                            .foregroundColor(Color("BlueColor", bundle: nil))
                    }
                    .padding()
                }
                Spacer()
                Button(action: {
                    selectedTab = 1
                }) {
                    HStack {
                        Image("AddPearsonDark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        
                        Text("Sign up")
                            .font(.custom("Nunito Sans", size: 16))
                            .foregroundColor(Color("TextGrayColor", bundle: nil))
                    }
                    .padding()
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color.gray)
            .shadow(radius: 5)
        }        
    }
}

#Preview {
    ContentView()
}





import Foundation
import SwiftUI

struct BottomToolbar: View {
    var body: some View {
        //        HStack {
        //            NavigationLink(
        //                destination: ContentView().navigationBarBackButtonHidden(true),
        //                isActive: .constant(true)
        //            ) {
        //                        Label("Users", image: "ThreePearson")
        //                            .font(.custom("Nunito Sans", size: 16))
        //                            .foregroundColor(Color("BlueColor", bundle: nil))
        //                            .padding()
        //                            .frame(maxWidth: .infinity)
        //                    }
        //            
        //            NavigationLink(
        //                destination: SignUpView().navigationBarBackButtonHidden(true),
        //                isActive: .constant(true)
        //                    
        //            ) {
        //                Label("Sign up", image: "AddPearsonDark")
        //                    .font(.custom("Nunito Sans", size: 16))
        //                            .foregroundColor(Color("TextGrayColor", bundle: nil))
        //                            .padding()
        //                            .frame(maxWidth: .infinity)
        //                            .cornerRadius(8)
        //                    }
        //                    .buttonStyle(PlainButtonStyle()) 
        //                }
        //                .frame(height: 56)
        //                .background(Color("GrayColor", bundle: nil))
        //                .cornerRadius(0)
        //            }
        //        }
        
        TabView() {
            VStack{

            }
                ContentView()
          
                    .tabItem {
                        Label("Users", image: "ThreePearson")
                            .font(.custom("Nunito Sans", size: 16))
                            .foregroundColor(Color("BlueColor", bundle: nil))
                            .padding()
                            .frame(maxWidth: .infinity)
                        
                    }
                           SignUpView()
                      
                    .tabItem {
                        Label("Sign up", image: "AddPearsonDark")
                            .font(.custom("Nunito Sans", size: 16))
                            .foregroundColor(Color("TextGrayColor", bundle: nil))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
            
        }
        
        .frame(maxHeight: .infinity)
                .edgesIgnoringSafeArea(.bottom)
    }
}
            
          
      




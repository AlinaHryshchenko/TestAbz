

import Foundation

import SwiftUI

struct NoUsersView: View {
    var body: some View {
        NavigationStack {
            VStack {
                TopToolbar(title: "Working with GET request")
                Spacer()
                Image("NoUsers")
                       .resizable()
                       .frame(width: 200, height: 200)
                       .scaledToFit()
                       .padding()
                   
                Text("There are no users yet")
                    .font(.custom("Nunito Sans", size: 20))
                    .foregroundColor(Color("TextDarkDrayColor", bundle: nil))
                Spacer()

            }
            .padding()
           
          //  BottomToolbar()
        }
        .padding(.bottom, -35)
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    NoUsersView()
}

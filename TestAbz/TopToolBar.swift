

import Foundation
import SwiftUI

struct TopToolbar: View {
    var title: String 
    
    var body: some View {
        Text(title)
            .font(.custom("Nunito Sans", size: 20))
            .foregroundColor(.black)
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(Color.yellow)
            .cornerRadius(0)
            .padding(.horizontal, -20)
            .ignoresSafeArea(edges: .top)
    }
}

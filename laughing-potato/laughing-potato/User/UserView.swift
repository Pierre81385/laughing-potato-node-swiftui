//
//  UserView.swift
//  laughing-potato
//
//  Created by m1_air on 7/29/24.
//

import SwiftUI
import SwiftData

struct UserView: View {
    @State var user = UserData(id: "", name: "", timeStamp: 0.0)
    @State var proceed: Bool = false
    @Query var allUsers: [UserData]
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack{
            VStack{
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/).fontWeight(.bold)
                Text("I'm, ").fontWeight(.bold)
                TextField("What do we call you?", text: $user.name).multilineTextAlignment(.center)
                HStack{
                    Spacer()
                    Button(action: {
                        user.name = ""
                    }, label: {
                        Image(systemName: "xmark").tint(.black)
                    })
                    Spacer()
                    Button(action: {
                        modelContext.insert(user)
                    }, label: {
                        Image(systemName: "checkmark").tint(.black)
                    }).navigationDestination(isPresented: $proceed, destination: {
                        
                    })
                    Spacer()
                }.padding()
//                ScrollView{
//                    ForEach(allUsers) {
//                        u in
//                        Text(u.name)
//                    }
//                }
            }
        }
    }
}

#Preview {
    UserView().modelContainer(for: UserData.self, inMemory: true)
}

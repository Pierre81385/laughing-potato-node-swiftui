//
//  UserView.swift
//  laughing-potato
//
//  Created by m1_air on 7/29/24.
//

import SwiftUI
import SwiftData

//since the user in anonomys but we want to be able to attribut a name to a message
//the user information is stored locally.  There can be duplicate names but the
//user ID will be unique in the mongodb.

//if a user is in local storage, provide the option to continue as that user, or not.

struct UserView: View {
    @State var user = UserData(id: "", name: "", timeStamp: 0.0)
    @State var proceed: Bool = false
    @State var errorMessage: String = ""
    @Query var allUsers: [UserData]
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack{
            if(allUsers.isEmpty){
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
                            SocketService.shared.socket.emit("joined", ["message": "\(user.name) has entered the chat!"])
                        }, label: {
                            Image(systemName: "checkmark").tint(.black)
                        }).navigationDestination(isPresented: $proceed, destination: {
                            
                        })
                        Spacer()
                    }.padding()
                    Text(errorMessage).tint(.red)
                }
            } else {
                let u = allUsers[0]
                VStack{
                    Text("Continue as \(u.name)?")
                    HStack{
                        Spacer()
                        Button(action: {
                            do {
                                try modelContext.delete(model: UserData.self)
                            } catch {
                                errorMessage = "Oops something went wrong!  Kill the app and try again."
                            }
                        }, label: {
                            Text("No.")
                        })
                        Spacer()
                        Button(action: {
                            proceed = true
                        }, label: {
                            Text("Yep!")
                        })
                        Spacer()
                    }.padding()
                    Text(errorMessage).tint(.red)

                }
            }
        }
    }
}

#Preview {
    UserView().modelContainer(for: UserData.self, inMemory: true)
}

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
    @State var user = UserData(id: UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString, name: "", timeStamp: Date.now.timeIntervalSince1970)
    @State var proceed: Bool = false
    @State var rememberMe: Bool = true
    @State var errorMessage: String = ""
    @Query var allUsers: [UserData]
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack{
            
                VStack{
                    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/).fontWeight(.bold)
                    Text("I'm, ").fontWeight(.bold)
                    TextField("What do we call you today?", text: $user.name).multilineTextAlignment(.center)
                    HStack{
                        Spacer()
                        Toggle(isOn: $rememberMe, label: {
                            Text("Remember Me")
                        }).tint(.black)
                        Spacer()
                    }.padding()
                    HStack{
                        Spacer()
                        Button(action: {
                            user.name = ""
                            do {
                                try modelContext.delete(model: UserData.self)
                            } catch {
                                print("could not delete User data!")
                            }
                        }, label: {
                            Image(systemName: "xmark").tint(.black)
                        })
                        Spacer()
                        Button(action: {
                            modelContext.insert(user)
                            SocketService.shared.socket.emit("joined", ["message": "\(user.name) \(user.id) has entered the chat at \(user.timeStamp)!"])
                            proceed = true
                        }, label: {
                            Image(systemName: "checkmark").tint(.black)
                        }).navigationDestination(isPresented: $proceed, destination: {
                            MessageView(sender: $user).navigationBarBackButtonHidden(true)
                        })
                        Spacer()
                    }.padding()
                    if(errorMessage == "Socket connected") {
                        Image(systemName: "point.3.filled.connected.trianglepath.dotted").tint(.black)
                    } else {
                        Text(errorMessage).tint(.red)
                    }
                }.onAppear{
                    SocketService.shared.socket.connect()
                    do {
                        try modelContext.delete(model: UserData.self)
                    } catch {
                        print("could not delete User data!")
                    }
                }
                .onChange(of: SocketService.shared.message, {
                    errorMessage = SocketService.shared.message
                })
                .onChange(of: rememberMe, {
                    user.id = UUID().uuidString
                })
        }
    }
}

#Preview {
    UserView().modelContainer(for: UserData.self, inMemory: true)
}

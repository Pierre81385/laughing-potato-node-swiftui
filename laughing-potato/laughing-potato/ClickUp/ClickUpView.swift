//
//  ClickUpView.swift
//  laughing-potato
//
//  Created by m1_air on 8/3/24.
//

import SwiftUI

struct ClickUpView: View {
    
    @State var clickUpAPI: ClickUp = ClickUp()
    @State var name: String = ""
    let myAPItoken = "pk_54098740_LAOBI4UNGKBWPDCEUXVFHWBAYLYJKNZU"
    let task_id = "868988p05"
    
    var body: some View {
        VStack{
            Button(action: {
                clickUpAPI.getTask(task_id: task_id, token: myAPItoken)
                name = clickUpAPI.task?.name ?? ""
            }, label: {
                Text("GET")
            })
            Text(clickUpAPI.task?.name ?? "")
            Text(clickUpAPI.task?.id ?? "")
        }
    }
}

#Preview {
    ClickUpView()
}

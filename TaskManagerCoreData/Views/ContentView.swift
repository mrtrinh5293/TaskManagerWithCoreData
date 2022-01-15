//
//  ContentView.swift
//  TaskManagerCoreData
//
//  Created by duc on 2022-01-12.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @StateObject var taskModel : TaskViewModel = TaskViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            // MARK: LAzy Vstack with Pinned Header
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                Section {
                    // MARK: current week view
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(taskModel.currentWeek, id: \.self) { day in
                                Text(day.formatted(date: .abbreviated, time: .omitted))
                            }
                        }
                    }
                } header: {
                    HeaderView()
                }
                
            }
        }
    }
    
    func HeaderView() -> some View {
        HStack {
            VStack {
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(.gray)
                
                Text("Today")
                    .font(.largeTitle.bold())
            }
            .hLeading()
            
            Button {
                
            } label: {
                Image("Profile Pic")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .background(Color.orange)
                    .clipShape(Circle())
                    
            }

        }
        .padding()
        .background(Color.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// MARK: UI Design Helper

extension View {
    func hLeading() -> some View {
        self.frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hTrailing() -> some View {
        self.frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func hCenter() -> some View {
        self.frame(maxWidth: .infinity, alignment: .center)
    }
    
}

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
    @Namespace var animation
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            // MARK: LAzy Vstack with Pinned Header
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                Section {
                    // MARK: current week view
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(taskModel.currentWeek, id: \.self) { day in
                                VStack(spacing: 10) {
                                    
                                    Text(taskModel.extractDate(date: day, format: "dd"))
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                    Text(taskModel.extractDate(date: day, format: "EEE"))
                                        .font(.system(size: 14))
                                        .onAppear {
                                            print(day)
                                        }
                                    
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 8, height: 8)
                                        .opacity(taskModel.isToday(date: day) ? 1 : 0)
                                }
                                // MARK: foreground styling
                                .foregroundStyle(taskModel.isToday(date: day) ? .primary : .tertiary)
                                .foregroundColor(taskModel.isToday(date: day) ? .white : .black)
                                // MARK: Capsule Shape
                                .frame(width: 45, height: 90)
                                .background(
                                    ZStack {
                                        if taskModel.isToday(date: day) {
                                            Capsule()
                                                .fill(.black)
                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                        }
                                    }
                                )
                                .contentShape(Capsule())
                                .onTapGesture {
                                    withAnimation {
                                        taskModel.currentDate = day
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    TaskView()
                } header: {
                    HeaderView()
                }
                
            }
        }
    }
    
    // MARK: Task Card View
    func TaskCardView(task: Task) -> some View {
        HStack {
            Text(task.taskTitle)
        }
    }
    
    // MARK: Task View
    
    func TaskView() -> some View {
        LazyVStack(spacing: 18) {
            if let tasks = taskModel.filteredTasK {
                if tasks.isEmpty {
                    Text("No Task Found!")
                        .font(.system(size: 16))
                        .fontWeight(.light)
                        .offset(y: 100)
                } else {
                    ForEach(tasks) { task in
                        TaskCardView(task: task)
                    }
                }
            } else {
                // MARK: Progress View
                ProgressView()
                    .offset(y: 100)
            }
        }
        //MARK: updaing Tasks
        .onChange(of: taskModel.currentDate) { newValue in
            taskModel.filterTodayTask()
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

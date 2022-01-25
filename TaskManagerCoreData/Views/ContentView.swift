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
//    @State var time = NSDate().timeIntervalSince1970
    
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
        .ignoresSafeArea(.container, edges: .top)
//        .onAppear {
//            print(time)
//        }
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
        .padding()
        .padding(.top)
        //MARK: updaing Tasks
        .onChange(of: taskModel.currentDate) { newValue in
            taskModel.filterTodayTask()
        }
    }
    
    // MARK: Task Card View
    func TaskCardView(task: Task) -> some View {
        HStack {
            VStack(spacing: 10) {
                Circle()
                    .fill(.black)
                    .frame(width: 15, height: 15)
                    .background(
                        Circle()
                            .stroke(.black,lineWidth: 1)
                            .padding(-3)
                    )
                
                Rectangle()
                    .fill(.black)
                    .frame(width: 3)
            }
            
            
            VStack {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(task.taskTitle)
                            .font(.title2.bold())
                        
                        Text(task.taskDescription)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .hLeading()
                    
                    Text(task.taskDate.formatted(date: .omitted, time: .shortened))
                }
                
//                HStack(spacing: 0) {
//                    HStack(spacing: -10) {
//                        ForEach
//                    }
//                }
                
                Button {
                    
                } label: {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.black)
                        .padding(10)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                }
                .hTrailing()

//                if taskModel.is
                
            }
            .foregroundColor(.white)
            .padding()
            .hLeading()
            .background(
                Color.black.opacity(0.9)
                    .cornerRadius(25)
            )
        }
        .hLeading()
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
        .padding(.top, getSafeArea().top)
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
    
    // MARK: Safe Area
    
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
    }
    
    //MARK: check if curren hour is taskHour
    func isCUrrentHour(date: Date) -> Bool {
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())
        
        return hour == currentHour
    }
    
}

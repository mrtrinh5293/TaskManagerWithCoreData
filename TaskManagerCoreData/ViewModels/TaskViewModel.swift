//
//  TaskViewModel.swift
//  TaskManagerCoreData
//
//  Created by duc on 2022-01-13.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    
    @Published var storedTasks: [Task] = [
        Task(taskTitle: "Meeting 1", taskDescription: "Discus team task for the day", taskDate: .init(timeIntervalSince1970: 1641645497)),
        Task(taskTitle: "Meeting 2", taskDescription: "Discus team task for the day", taskDate: .init(timeIntervalSince1970: 1415637900)),
        Task(taskTitle: "Meeting 3", taskDescription: "Discus team task for the day", taskDate: .init(timeIntervalSince1970: 1641646397)),
        Task(taskTitle: "Meeting 4", taskDescription: "Discus team task for the day", taskDate: .init(timeIntervalSince1970: 1641641897)),
        Task(taskTitle: "Meeting 5", taskDescription: "Discus team task for the day", taskDate: .init(timeIntervalSince1970: 1641647897)),
        Task(taskTitle: "Meeting 6", taskDescription: "Discus team task for the day", taskDate: .init(timeIntervalSince1970: 1641641293)),
        Task(taskTitle: "Meeting 7", taskDescription: "Discus team task for the day", taskDate: .init(timeIntervalSince1970: 1641649567)),        
    ]
    
    // Curren Week Days
    @Published var currentWeek: [Date] = []
    
    // Current Day
    @Published var currentDate: Date = Date()
    
    @Published var filteredTasK: [Task]?
    
    // Initializing
    init() {
        fetchCurrentWeek()
        filterTodayTask()
    }
    
    func fetchCurrentWeek() {
        let today = Date()
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else {
            return
        }
        
        (1...7).forEach { day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(weekday)
            }
        }
    }
    
    func filterTodayTask() {
        DispatchQueue.global(qos: .userInteractive).async {
            let calendar = Calendar.current
            
            let filtered = self.storedTasks.filter {
                return calendar.isDate($0.taskDate, inSameDayAs: self.currentDate)
            }
            
            DispatchQueue.main.async {
                withAnimation {
                    self.filteredTasK = filtered
                }
            }
        }
    }
    
    // Extracting Date
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    // MARK: Whenever the app open, check and display today' date
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(currentDate, inSameDayAs: date)
    }
}

struct Task: Identifiable {
    var id = UUID().uuidString
    var taskTitle: String
    var taskDescription: String
    var taskDate: Date
}

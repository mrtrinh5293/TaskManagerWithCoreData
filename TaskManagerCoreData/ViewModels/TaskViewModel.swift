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
        Task(taskTitle: "Meeting 2", taskDescription: "Discus team task for the day", taskDate: .init(timeIntervalSince1970: 1641649097)),
        Task(taskTitle: "Meeting 3", taskDescription: "Discus team task for the day", taskDate: .init(timeIntervalSince1970: 1641646397)),
        Task(taskTitle: "Meeting 4", taskDescription: "Discus team task for the day", taskDate: .init(timeIntervalSince1970: 1641641897)),
        Task(taskTitle: "Meeting 5", taskDescription: "Discus team task for the day", taskDate: .init(timeIntervalSince1970: 1641647897)),
        Task(taskTitle: "Meeting 6", taskDescription: "Discus team task for the day", taskDate: .init(timeIntervalSince1970: 1641641293)),
        Task(taskTitle: "Meeting 7", taskDescription: "Discus team task for the day", taskDate: .init(timeIntervalSince1970: 1641649567)),        
    ]
    
    // Curren Week Days
    @Published var currentWeek: [Date] = []
    
    // Initializing
    init() {
        fetchCurrentWeek()
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
    
    // Extracting Date
    func extractDate(date: Date) {
        
    }
}

struct Task: Identifiable {
    var id = UUID().uuidString
    var taskTitle: String
    var taskDescription: String
    var taskDate: Date
}

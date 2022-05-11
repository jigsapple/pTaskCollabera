//
//  DashboardViewModel.swift
//  pTaskCollabera
//
//  Created by Jignesh on 11/05/22.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import EventKit

class DashboardViewModel {
    var events = BehaviorSubject(value: [SectionModel(model: "", items: [EKEvent]())])
    
    func fetchEvents() {
        CalendarHelperManager.shared.getAllEvents(completion: { (error, result) in
            if let events = result {
                let sectionEvent = SectionModel(model: "My Events", items: events)
                self.events.on(.next([sectionEvent]))
            }
        })
    }
    
    func addEvent(event: EKEvent) {
        guard var sections = try? events.value() else { return }
        var currentSection = sections[0]
        currentSection.items.append(event)
        sections[0] = currentSection
        self.events.onNext(sections)
        CalendarHelperManager.shared.saveEvent(event: event, completion: { (error) in
            print("event save successfully")
        })
    }
    
    func clearAll() {
        guard var sections = try? events.value() else { return }
        var currentSection = sections[0]
        currentSection.items.removeAll()
        sections[0] = currentSection
        self.events.onNext(sections)
        CalendarHelperManager.shared.removeAllEvents(filter: nil, completion: { error in
            print("all events deleted")
        })
    }
    
    func deleteEvent(indexPath: IndexPath) {
        guard var sections = try? events.value() else { return }
        var currentSection = sections[indexPath.section]
        let selectedEvent = currentSection.items[indexPath.row]
        currentSection.items.remove(at: indexPath.row)
        sections[indexPath.section] = currentSection
        self.events.onNext(sections)
        CalendarHelperManager.shared.removeEvent(eventId: selectedEvent.eventIdentifier) { error in
            print("event deleted successfully")
        }
    }
    
    func editEvent(title:String,indexPath:IndexPath) {
        guard var sections = try? events.value() else { return }
        let currentSection = sections[indexPath.section]
        let selectedEvent = currentSection.items[indexPath.row]
        currentSection.items[indexPath.row].title = title
        selectedEvent.title = title
        sections[indexPath.section] = currentSection
        self.events.onNext(sections)
        CalendarHelperManager.shared.saveEvent(event: selectedEvent, completion: { (error) in
            print("event update successfully")
        })
    }
}

//
//  ComplicationController.swift
//  ComplicationApp Extension
//
//  Created by Vadim Drobinin on 18/12/16.
//  Copyright © 2016 Vadim Drobinin. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
  
    let timeLineText = ["Курс 1 в 12:00", "Курс 2 в 15:00", "Курс 3 во вторник", "Курс 4 закончится 25/12/16"]
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
      let currentDate = Date()
      handler(currentDate)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        let currentDate = Date()
        let endDate =
          currentDate.addingTimeInterval(TimeInterval(4 * 60 * 60))
        handler(endDate)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
      if complication.family == .modularLarge {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        
        let timeString = dateFormatter.string(from: Date())
        
        let entry = createTimeLineEntry(headerText: timeString, bodyText: timeLineText[0], date: Date())
        
        handler(entry)
      } else {
        handler(nil)
      }
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
      handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
      var timeLineEntryArray = [CLKComplicationTimelineEntry]()
      var nextDate = Date(timeIntervalSinceNow: 1 * 60 * 60)
      
      for index in 1...3 {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        
        let timeString = dateFormatter.string(from: nextDate)
        
        let entry = createTimeLineEntry(headerText: timeString, bodyText: timeLineText[index], date: nextDate)
        
        timeLineEntryArray.append(entry)
        
        nextDate = nextDate.addingTimeInterval(1 * 60 * 60)
      }
      handler(timeLineEntryArray)
    }
  
    func createTimeLineEntry(headerText: String, bodyText: String, date: Date) -> CLKComplicationTimelineEntry {
      
      let template = CLKComplicationTemplateModularLargeStandardBody()
      let clock = UIImage(named: "clock")
      
      template.headerImageProvider =
        CLKImageProvider(onePieceImage: clock!)
      template.headerTextProvider = CLKSimpleTextProvider(text: headerText)
      template.body1TextProvider = CLKSimpleTextProvider(text: bodyText)
      
      let entry = CLKComplicationTimelineEntry(date: date,
                                               complicationTemplate: template)
      
      return(entry)
    }
  
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        let template = CLKComplicationTemplateModularLargeStandardBody()
        let clock = UIImage(named: "clock")
        
        template.headerImageProvider =
          CLKImageProvider(onePieceImage: clock!)
      
        template.headerTextProvider =
          CLKSimpleTextProvider(text: "Курсы Stepic")
        template.body1TextProvider =
          CLKSimpleTextProvider(text: "Расписание дедлайнов")
        
        handler(template)
    }
    
}

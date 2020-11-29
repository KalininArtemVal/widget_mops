//
//  Mops.swift
//  Mops
//
//  Created by Калинин Артем Валериевич on 28.11.2020.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .month, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct MopsEntryView : View {
    
    @State var date = Date()
    
    var entry: Provider.Entry

    var body: some View {
        
        ZStack {
            GeometryReader { geometryProxy in
                Image("mops")
                    .resizable()
                    .frame(width: 100,
                           height: geometryProxy.size.height)
                    .clipped()
            }.padding(EdgeInsets(top: 0, leading: 80, bottom: 0, trailing: 0))
            
            HStack {
                VStack(alignment: .leading) {
                    header
                    middle
                    footer
                    Spacer()
                }
                .padding(EdgeInsets(top: 4, leading: 10, bottom: 16, trailing: 0))
                Spacer()
            }
        }
    }
    
    ///День недели
    var middle: some View {
        Group {
            Text("\("Monday")")
        }
        .font(.custom("Montserrat", size: 12, relativeTo: .body))
        .foregroundColor(.init(UIColor(red: 1, green: 1, blue: 1, alpha: 1)))
    }
    
    ///Время
    var header: some View {
        Group {
            Text(entry.date, style: .time)
        }
        .font(.custom("Ubuntu-Light", size: 40, relativeTo: .body))
        .foregroundColor(.init(UIColor(red: 1, green: 1, blue: 1, alpha: 1)))
        
    }
    ///Дата
    var footer: some View {
        Group {
            
            Text(self.entry.date, style: .date)
        }
        .font(.custom("Ubuntu-Light", size: 20, relativeTo: .body))
        .foregroundColor(.init(UIColor(red: 1, green: 1, blue: 1, alpha: 1)))
    }
}

@main
struct Mops: Widget {
    let kind: String = "Mops"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MopsEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct Mops_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            MopsEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .background(ContainerRelativeShape().fill(Color.init(.sRGB, red: 0.929, green: 0.71, blue: 0.024)))
        }
        
        .environment(\.colorScheme, .light)
//        .redacted(reason: .placeholder)
    }
}

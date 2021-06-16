//
//  ContentView.swift
//  SwiftUIScratchPad
//
//  Created by Parker Rushton on 6/15/21.
//

import SwiftUI

struct ActivitiesView: View {
    
    private let activityFetcher = ActivityFetcher()
    
    @State private var activities = [Activity]()
    @State private var isLoadingNewActivity = false
    @State private var searchText = ""
    
    private var searchResults: [Activity] {
        let searchedActivities = activities.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        return searchText.isEmpty ? activities : searchedActivities
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(searchResults) { activity in
                        VStack(alignment: .leading) {
                            Text(activity.name)
                                .layoutPriority(1)
                            HStack {
                                Image(systemName: "person.2.fill")
                                Text("\(activity.participants)")
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .searchable(text: $searchText)
                .navigationBarTitle("Bored?")
                .navigationBarItems(
                    trailing:
                        Button(action: addActivity) {
                    Group {
                        if isLoadingNewActivity {
                            ProgressView()
                        } else {
                            Image(systemName: "plus")
                        }
                    }
                })
                .disabled(isLoadingNewActivity)
                
                if !searchText.isEmpty && searchResults.isEmpty {
                    Text("Huh, I guess you really do have nothing to do")
                    Text("🤷").font(.title)
                }
            }
        }
        .task {
            await fetchActivityAsync()
        }
    }
    
}

private extension ActivitiesView {
    
    func addActivity() {
        async {
            await fetchActivityAsync()
        }
    }
    
    func fetchActivityAsync() async {
        do {
            isLoadingNewActivity = true
            let newActivity = try await activityFetcher.fetchNewActivity()
            withAnimation {
                activities.insert(newActivity, at: 0)
                isLoadingNewActivity = false
            }
        } catch {
            print(error.localizedDescription)
            isLoadingNewActivity = false
        }
    }
    
    func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.forEach { activities.remove(at: $0) }
        }
    }
    
}

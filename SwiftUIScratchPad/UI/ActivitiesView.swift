//
//  ContentView.swift
//  SwiftUIScratchPad
//
//  Created by Parker Rushton on 6/15/21.
//

import SwiftUI

struct ActivitiesView: View {
    
    // MARK: - State
    
    @State private var activities = [Activity]()
    @State private var isLoadingNewActivity = false
    @State private var searchText = ""
    @State private var isShowingActivityCreation = false
    
    
    // MARK: - Properties
    
    private let activityFetcher = ActivityFetcher()
    private var searchResults: [Activity] {
        let searchedActivities = activities.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        return searchText.isEmpty ? activities : searchedActivities
    }
    
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    Section {
                        Button(action: addActivity) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Generate Random")
                            }
                        }
                    }
                    
                    Section {
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
                }
                .navigationBarTitle("Bored?")
                .navigationBarItems(
                    trailing:
                        Button(action: presentActivityCreationView) {
                    Image(systemName: "plus")
                })
                
                if !searchText.isEmpty && searchResults.isEmpty {
                    Text("Huh, I guess you really do have nothing to do")
                    Text("🤷").font(.title)
                }
            }
        }
        .searchable(text: $searchText)
        .task {
            await fetchActivityAsync()
        }
        .sheet(isPresented: $isShowingActivityCreation, onDismiss: nil) {
            ActivityCreationView { activity in
                withAnimation {
                    activities.insert(activity, at: 0)
                    }
                }
            }
    }
    
}

private extension ActivitiesView {
    
    func presentActivityCreationView() {
        isShowingActivityCreation = true
    }
    
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

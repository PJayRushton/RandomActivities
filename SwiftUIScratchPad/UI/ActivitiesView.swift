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
    
    private let activityFetcher = ActivityFetcher.shared
    private var searchResults: [Activity] {
        let searchedActivities = activities.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        return searchText.isEmpty ? activities : searchedActivities
    }
    private let emptyImageURL = URL(string: "https://www.memesmonkey.com/images/memesmonkey/83/83ea231de826c7bf7113a76ae817a781.jpeg")!
    
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
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
                        ActivityCell(activity: activity)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    deleteActivity(activity)
                                } label: {
                                    Image(systemName: "trash")
                                }
                                .tint(.red)
                            }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationBarTitle("Bored?")
            .navigationBarItems(
                trailing:
                    Button(action: presentActivityCreationView) {
                Image(systemName: "plus")
            })
            .overlay {
                if !searchText.isEmpty && searchResults.isEmpty {
                    AsyncImage(url: emptyImageURL)
                        .padding(.top)
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

    func deleteActivity(_ activity: Activity) {
        withAnimation {
            guard let index = activities.firstIndex(of: activity) else { return }
            activities.remove(at: index)
        }
    }
    
}

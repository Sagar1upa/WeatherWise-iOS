//
//  CitySearchView.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import SwiftUI

struct CitySearchView: View {
    @State private var viewModel: CitySearchViewModel
        
        private let weatherRepository: any WeatherRepository
        private let recommendationsUseCase: any GetActivityRecommendationsUseCase
        
        init(viewModel: CitySearchViewModel, weatherRepository: any WeatherRepository, recommendationsUseCase: any GetActivityRecommendationsUseCase) {
            _viewModel = State(initialValue: viewModel)
            self.weatherRepository = weatherRepository
            self.recommendationsUseCase = recommendationsUseCase
        }
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle:
                    idleView
                    
                case .searching:
                    searchingView
                    
                case let .loaded(cities):
                    cityList(cities)
                    
                case .empty:
                    emptyView
                    
                case let .failed(error):
                    errorView(error)
                }
            }
            .navigationTitle("WeatherWise")
            .searchable(text: Binding(get: { viewModel.query }, set: { viewModel.updateQuery($0) }), prompt: "Search for a city")
        }
    }
    
    private var idleView: some View {
        ContentUnavailableView("Search for a City", systemImage: "location.magnifyingglass", description: Text("Enter a city name to see weather-based activity recommendations."))
    }
    
    private var searchingView: some View {
        ProgressView("Searching...")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func cityList(_ cities: [City]) -> some View {
        List(cities) { city in
            NavigationLink {
                ActivityRecommendationsView(city: city, weatherRepository: weatherRepository, recommendationsUseCase: recommendationsUseCase)
                
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text(city.name)
                        .font(.headline)
                    
                    Text(city.country)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
        .listStyle(.plain)
    }
    
    private var emptyView: some View {
        ContentUnavailableView("No Cities Found", systemImage: "mappin.slash", description: Text("Try searching with a different city name."))
    }
    
    private func errorView(_ error: AppError) -> some View {
        ContentUnavailableView {
            Label("Something Went Wrong", systemImage: "exclamationmark.triangle")
            
        } description: {
            Text(error.message)
            
        } actions: {
            Button("Try Again") {
                viewModel.retry()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

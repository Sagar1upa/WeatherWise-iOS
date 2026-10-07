//
//  ActivityRecommendationsView.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import SwiftUI

struct ActivityRecommendationsView: View {
    let city: City
    
    private let weatherRepository: any WeatherRepository
    private let recommendationsUseCase: any GetActivityRecommendationsUseCase
    
    @State private var viewModel: ActivityRecommendationsViewModel
    
    init(city: City, weatherRepository: any WeatherRepository, recommendationsUseCase: any GetActivityRecommendationsUseCase) {
        self.city = city
        self.weatherRepository = weatherRepository
        self.recommendationsUseCase = recommendationsUseCase
        
        _viewModel = State(initialValue: ActivityRecommendationsViewModel(weatherRepository: weatherRepository, recommendationsUseCase: recommendationsUseCase))
    }
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .idle:
                Color.clear
                
            case .loading:
                loadingView
                
            case let .loaded(recommendations):
                recommendationsList(recommendations)
                
            case let .failed(error):
                errorView(error)
            }
        }
        .navigationTitle(city.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if case .idle = viewModel.state {
                await viewModel.load(for: city)
            }
        }
    }
    
    private var loadingView: some View {
        ProgressView("Loading forecast...")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func recommendationsList(_ recommendations: [ActivityRecommendation]) -> some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text(city.displayName)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Best activities for the next 7 days")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            }
            
            Section("Ranked Activities") {
                ForEach(Array(recommendations.enumerated()), id: \.element.id) { index, recommendation in
                    ActivityRecommendationRow(rank: index + 1, recommendation: recommendation)
                }
            }
        }
        .listStyle(.insetGrouped)
        .refreshable {
            await viewModel.retry(for: city)
        }
    }
    
    private func errorView(_ error: AppError) -> some View {
        ContentUnavailableView {
            Label("Unable to Load Forecast", systemImage: "exclamationmark.triangle")
            
        } description: {
            Text(error.message)
            
        } actions: {
            Button("Try Again") {
                Task {
                    await viewModel.retry(for: city)
                }
            }
            .buttonStyle(.borderedProminent)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

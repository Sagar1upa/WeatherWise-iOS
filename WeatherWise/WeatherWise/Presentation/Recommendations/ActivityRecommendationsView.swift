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
    @State private var appeared = false
    
    init(city: City, weatherRepository: any WeatherRepository, recommendationsUseCase: any GetActivityRecommendationsUseCase) {
        self.city = city
        self.weatherRepository = weatherRepository
        self.recommendationsUseCase = recommendationsUseCase
        
        _viewModel = State(initialValue: ActivityRecommendationsViewModel(weatherRepository: weatherRepository, recommendationsUseCase: recommendationsUseCase))
    }
    
    var body: some View {
        ZStack {
            background

            content
        }
        .navigationTitle(city.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if case .idle = viewModel.state {
                await viewModel.load(for: city)
            }
        }
    }

    @ViewBuilder
    private var content: some View {
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

    private var background: some View {
        LinearGradient(colors: [Color.blue.opacity(0.08), Color.indigo.opacity(0.04), Color(.systemBackground)], startPoint: .topLeading, endPoint: .bottomTrailing)
        .ignoresSafeArea()
    }

    private var loadingView: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.15), lineWidth: 10)
                    .frame(width: 64, height: 64)

                ProgressView()
                    .controlSize(.large)
            }

            Text("Analyzing the forecast...")
                .font(.headline)

            Text("Finding the best activities for \(city.name)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func recommendationsList(_ recommendations: [ActivityRecommendation]) -> some View {
        ScrollView {
            LazyVStack(spacing: 18) {
                headerCard

                VStack(alignment: .leading, spacing: 12) {
                    Text("Top Activities")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal, 4)

                    ForEach(Array(recommendations.enumerated()), id: \.element.id) { index, recommendation in
                        ActivityRecommendationRow(rank: index + 1, recommendation: recommendation)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 20)
                        .animation(
                            .spring(response: 0.45, dampingFraction: 0.8)
                            .delay(Double(index) * 0.08),
                            value: appeared
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 20)
        }
        .scrollIndicators(.hidden)
        .refreshable {
            await viewModel.retry(for: city)
        }
        .onAppear {
            appeared = true
        }
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.18))
                        .frame(width: 52, height: 52)

                    Image(systemName: "cloud.sun.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                }

                Spacer()

                Image(systemName: "sparkles")
                    .font(.title2)
                    .foregroundStyle(.white.opacity(0.85))
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(city.displayName)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text("Weather-based recommendations")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
            }

            HStack(spacing: 8) {
                Image(systemName: "calendar")
                Text("Next 7 days")
            }
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(.white.opacity(0.9))
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(LinearGradient(colors: [.blue, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: .blue.opacity(0.22), radius: 18, y: 10)
        .padding(.horizontal, 20)
    }

    private func errorView(_ error: AppError) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "cloud.exclamationmark")
                .font(.system(size: 46))
                .foregroundStyle(.orange)

            VStack(spacing: 8) {
                Text("Unable to Load Forecast")
                    .font(.title3)
                    .fontWeight(.bold)

                Text(error.message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Button("Try Again") {
                Task {
                    await viewModel.retry(for: city)
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding(32)
        .frame(maxWidth: 360)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

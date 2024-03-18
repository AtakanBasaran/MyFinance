//
//  Finance.swift
//  MyFinance
//
//  Created by Atakan Başaran on 31.10.2023.
//

import Foundation

// MARK: - Currency
struct Currency: Codable {
    let result: String
    let documentation, termsOfUse: String
    let timeLastUpdateUnix: Int
    let timeLastUpdateUTC: String
    let timeNextUpdateUnix: Int
    let timeNextUpdateUTC, baseCode: String
    let conversionRates: [String: Double]

    enum CodingKeys: String, CodingKey {
        case result, documentation
        case termsOfUse = "terms_of_use"
        case timeLastUpdateUnix = "time_last_update_unix"
        case timeLastUpdateUTC = "time_last_update_utc"
        case timeNextUpdateUnix = "time_next_update_unix"
        case timeNextUpdateUTC = "time_next_update_utc"
        case baseCode = "base_code"
        case conversionRates = "conversion_rates"
    }
}

// MARK: - Crypto
struct Crypto: Codable {
    let data: [dataCrypto]
    let timestamp: Int
}

struct dataCrypto: Codable {
    let id: String?
    let rank: String?
    let symbol: String?
    let name: String?
    let supply: String?
    let maxSupply: String?
    let marketCapUsd: String?
    let volumeUsd24Hr: String?
    let priceUsd: String?
    let changePercent24Hr: String?
    let vwap24Hr: String?
    let explorer: URL?
}

// MARK: - StockMarket
struct StockMarket: Codable {
    let symbol, name: String?
    let price, changesPercentage, change, dayLow: Double?
    let dayHigh, yearHigh, yearLow: Double?
    let marketCap: Int?
    let priceAvg50, priceAvg200: Double?
    let exchange: Exchange
    let volume, avgVolume: Int?
    let welcomeOpen, previousClose, eps, pe: Double?
    let earningsAnnouncement: String?
    let sharesOutstanding: Double?
    let timestamp: Int?

    enum CodingKeys: String, CodingKey {
        case symbol, name, price, changesPercentage, change, dayLow, dayHigh, yearHigh, yearLow, marketCap, priceAvg50, priceAvg200, exchange, volume, avgVolume
        case welcomeOpen = "open"
        case previousClose, eps, pe, earningsAnnouncement, sharesOutstanding, timestamp
    }
}

enum Exchange: String, Codable {
    case nasdaq = "NASDAQ"
}

// MARK: - News
struct News: Codable {
    let status: String
    let totalResults: Int
    var articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}


//
//  StatePickerView.swift
//  HikBik
//
//  四板塊共用：全屏毛玻璃州選擇器，網格佈局 + Top States + 懸浮搜索，選中主題綠 + 觸覺反饋
//

import SwiftUI

// MARK: - 50 州數據（name + code）
private let allUSStates: [(name: String, code: String)] = [
    ("Alabama", "AL"), ("Alaska", "AK"), ("Arizona", "AZ"), ("Arkansas", "AR"), ("California", "CA"),
    ("Colorado", "CO"), ("Connecticut", "CT"), ("Delaware", "DE"), ("Florida", "FL"), ("Georgia", "GA"),
    ("Hawaii", "HI"), ("Idaho", "ID"), ("Illinois", "IL"), ("Indiana", "IN"), ("Iowa", "IA"),
    ("Kansas", "KS"), ("Kentucky", "KY"), ("Louisiana", "LA"), ("Maine", "ME"), ("Maryland", "MD"),
    ("Massachusetts", "MA"), ("Michigan", "MI"), ("Minnesota", "MN"), ("Mississippi", "MS"),
    ("Missouri", "MO"), ("Montana", "MT"), ("Nebraska", "NE"), ("Nevada", "NV"), ("New Hampshire", "NH"),
    ("New Jersey", "NJ"), ("New Mexico", "NM"), ("New York", "NY"), ("North Carolina", "NC"),
    ("North Dakota", "ND"), ("Ohio", "OH"), ("Oklahoma", "OK"), ("Oregon", "OR"), ("Pennsylvania", "PA"),
    ("Rhode Island", "RI"), ("South Carolina", "SC"), ("South Dakota", "SD"), ("Tennessee", "TN"),
    ("Texas", "TX"), ("Utah", "UT"), ("Vermont", "VT"), ("Virginia", "VA"), ("Washington", "WA"),
    ("West Virginia", "WV"), ("Wisconsin", "WI"), ("Wyoming", "WY")
]

private let recentStatesKey = "statePickerRecentStates"
private let recentStatesMaxCount = 5

/// 最近選擇的州（UserDefaults，最多 5 個，供 Top States 展示）
private func loadRecentStateNames() -> [String] {
    (UserDefaults.standard.array(forKey: recentStatesKey) as? [String]) ?? []
}

private func saveRecentStateNames(_ names: [String]) {
    UserDefaults.standard.set(Array(names.prefix(recentStatesMaxCount)), forKey: recentStatesKey)
}

private func recordRecentState(_ name: String) {
    var recent = loadRecentStateNames()
    recent.removeAll { $0 == name }
    recent.insert(name, at: 0)
    saveRecentStateNames(recent)
}

// MARK: - 分類枚舉（數據源綁定）
/// 州選擇器必須綁定此分類，僅顯示該類別數據集中有數據的州
enum StatePickerCategory: String, CaseIterable {
    case park
    case forest
    case grassland
    case recArea

    var locationLabel: String {
        switch self {
        case .park: return "Parks"
        case .forest: return "Forests"
        case .grassland: return "Grasslands"
        case .recArea: return "Recreation Areas"
        }
    }
}

// MARK: - 全屏州選擇器（Overlay / Full Screen Cover）
/// 依 category 從該類別數據集 Filter 出有數據的 StateCodes；禁止 50 州；標題為 Select a State (X States found)；單元格顯示地點數
struct StatePickerSheetView: View {
    @Binding var selectedStateName: String
    @Binding var isPresented: Bool
    /// 數據源綁定：Park / Forest / Grassland / RecArea
    var category: StatePickerCategory
    /// 當前類別下擁有至少一個地點的州名（內存中從數據集快速提取，進入頁面前完成）
    var availableStates: [String]
    /// 每個州在當前類別下的地點數量，key = 州名，用於顯示 "California - 9 Parks"
    var stateCounts: [String: Int]
    var themeColor: Color

    @State private var searchText: String = ""
    @State private var recentNames: [String] = loadRecentStateNames()

    /// 有數據的州 Set，O(1) 查詢，無白屏/卡頓
    private var availableSet: Set<String> {
        Set(availableStates)
    }

    /// 僅有數據的州，動態生成網格
    private var statesInCategory: [(name: String, code: String)] {
        allUSStates.filter { availableSet.contains($0.name) }
    }

    private var topStates: [String] {
        recentNames.filter { availableSet.contains($0) }
    }

    /// 先按類別過濾，再按搜索；該分類下沒有數據的州不准顯示
    private var filteredStates: [(name: String, code: String)] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if q.isEmpty { return statesInCategory }
        return statesInCategory.filter {
            $0.name.lowercased().contains(q) || $0.code.lowercased().contains(q)
        }
    }

    /// 標題同步：Select a State (X States found)
    private var pageTitle: String {
        "Select a State (\(availableStates.count) States found)"
    }

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 5)

    var body: some View {
        ZStack {
            Color.clear
                .background(.ultraThinMaterial)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                headerBar
                Text(pageTitle)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                floatingSearchBar
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                if !topStates.isEmpty {
                    topStatesSection
                        .padding(.top, 16)
                        .padding(.horizontal, 20)
                }
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(filteredStates, id: \.name) { state in
                            StateCellView(
                                name: state.name,
                                code: state.code,
                                count: stateCounts[state.name],
                                locationLabel: category.locationLabel,
                                isSelected: selectedStateName == state.name,
                                themeColor: themeColor
                            ) {
                                selectState(state.name)
                            }
                        }
                    }
                    .padding(20)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear { recentNames = loadRecentStateNames() }
    }

    private var headerBar: some View {
        HStack {
            Spacer()
            Button {
                withAnimation(.easeOut(duration: 0.25)) { isPresented = false }
            } label: {
                Text("Done")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(themeColor)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
            }
            .padding(.top, 56)
            .padding(.trailing, 20)
        }
        .frame(maxWidth: .infinity)
    }

    private var floatingSearchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.body)
                .foregroundStyle(.secondary)
            TextField("Search states...", text: $searchText)
                .textFieldStyle(.plain)
                .font(.body)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    private var topStatesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Top States")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(topStates, id: \.self) { name in
                        let code = allUSStates.first(where: { $0.name == name })?.code ?? ""
                        Button {
                            selectState(name)
                        } label: {
                            VStack(spacing: 2) {
                                Text(code)
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                Text(name)
                                    .font(.system(size: 10, weight: .medium))
                                    .lineLimit(1)
                            }
                            .foregroundStyle(selectedStateName == name ? .white : .primary)
                            .frame(width: 64, height: 52)
                            .background(
                                selectedStateName == name ? themeColor : Color.primary.opacity(0.08),
                                in: RoundedRectangle(cornerRadius: 10)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private func selectState(_ name: String) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        recordRecentState(name)
        recentNames = loadRecentStateNames()
        withAnimation(.easeOut(duration: 0.25)) {
            selectedStateName = name
            isPresented = false
        }
    }
}

// MARK: - 單元格：圓角矩形，大字縮寫 + 州名 + 該州在當前類別下的地點數量（如 "9 Parks"）
private struct StateCellView: View {
    let name: String
    let code: String
    let count: Int?
    let locationLabel: String
    let isSelected: Bool
    let themeColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(code)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                Text(name)
                    .font(.system(size: 9, weight: .medium))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                if let n = count, n > 0 {
                    Text("\(n) \(locationLabel)")
                        .font(.system(size: 8, weight: .medium))
                        .foregroundStyle(isSelected ? .white.opacity(0.9) : .secondary)
                }
            }
            .foregroundStyle(isSelected ? .white : .primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                isSelected ? themeColor : Color.primary.opacity(0.06),
                in: RoundedRectangle(cornerRadius: 12)
            )
        }
        .buttonStyle(StateCellButtonStyle())
    }
}

private struct StateCellButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

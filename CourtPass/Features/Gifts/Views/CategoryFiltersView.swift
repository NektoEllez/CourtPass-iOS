import SwiftUI
struct CategoryFiltersView: View {
    @Binding var selectedCategory: String?
    let filters: [CategoryFilterItem]
    let showsChevron: Bool
    let onSelect: (String) -> Void
    init(selectedCategory: Binding<String?> = .constant(nil), filters: [CategoryFilterItem] = CategoryFilterItem.defaultFilters, showsChevron: Bool = false, onSelect: @escaping (String) -> Void = { _ in }) {
        _selectedCategory = selectedCategory
        self.filters = filters
        self.showsChevron = showsChevron
        self.onSelect = onSelect
    }
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DesignTokens.Spacing.lg) {
                ForEach(filters) { filter in
                    CategoryDropdownButton(
                        category: filter.category,
                        options: filter.options,
                        isSelected: false,
                        showsChevron: showsChevron,
                        onSelect: { option in
                            onSelect(option)
                        }
                    )
                }
            }
            .padding(.horizontal, DesignTokens.Spacing.lg)  
        }
        .padding(.horizontal, -DesignTokens.Spacing.lg)
        .padding(.top, DesignTokens.Spacing.lg)
    }
}
struct CategoryDropdownButton: View {
    let category: String
    let options: [String]
    let isSelected: Bool
    let showsChevron: Bool
    let onSelect: (String) -> Void
    @State private var selectedOption: String
    @State private var hasCustomSelection = false
    init(category: String, options: [String], isSelected: Bool, showsChevron: Bool, onSelect: @escaping (String) -> Void) {
        self.category = category
        self.options = options
        self.isSelected = isSelected
        self.showsChevron = showsChevron
        self.onSelect = onSelect
        self._selectedOption = State(initialValue: options.first ?? category)
    }
    var body: some View {
        Group {
            if options.count > 1 {
                Menu {
                    ForEach(options, id: \.self) { option in
                        Button(option) {
                            HapticManager.shared.listSelection()
                            selectedOption = option
                            hasCustomSelection = true
                            onSelect(option)
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(selectedOption)
                            .font(DesignTokens.Typography.callout)
                            .foregroundColor(DesignTokens.Text.primary)
                        if showsChevron {
                            Image(systemName: "chevron.down")
                                .font(.system(size: DesignTokens.IconSize.chevron))
                                .foregroundColor(DesignTokens.Text.primary)
                        }
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, DesignTokens.Spacing.md)
                    .background(
                        Capsule()
                            .fill(
                                hasCustomSelection
                                ? Color(DesignTokens.Background.primary.opacity(0.5))
                                : Color(DesignTokens.Background.primary)
                            )
                    )
                    .scaleEffect(hasCustomSelection ? 1.05 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0), value: hasCustomSelection)
                }
                .menuStyle(.borderlessButton)
                .buttonStyle(.plain)
            } else {
                Button {
                    HapticManager.shared.buttonTap()
                    hasCustomSelection = true
                    onSelect(selectedOption)
                } label: {
                    HStack(spacing: 4) {
                        Text(selectedOption)
                            .font(DesignTokens.Typography.callout)
                            .foregroundColor(DesignTokens.Text.primary)
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, DesignTokens.Spacing.md)
                    .background(
                        Capsule()
                            .fill(
                                hasCustomSelection
                                ? Color(DesignTokens.Background.primary.opacity(0.5))
                                : Color(DesignTokens.Background.primary)
                            )
                    )
                    .scaleEffect(hasCustomSelection ? 1.05 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0), value: hasCustomSelection)
                }
            }
        }
    }
}
struct SmartCategoryFiltersView: View {
    let viewModel: GiftsViewModel
    let filters: [CategoryFilterItem]
    let showsChevron: Bool
    let onSelect: (String) -> Void
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DesignTokens.Spacing.lg) {
                ForEach(filters) { filter in
                    SmartCategoryDropdownButton(
                        viewModel: viewModel,
                        category: filter.category,
                        options: filter.options,
                        showsChevron: showsChevron,
                        onSelect: onSelect
                    )
                }
            }
            .padding(.horizontal, DesignTokens.Spacing.lg)  
        }
        .padding(.horizontal, -DesignTokens.Spacing.lg)
        .padding(.top, DesignTokens.Spacing.lg)
    }
}
struct SmartCategoryDropdownButton: View {
    let viewModel: GiftsViewModel
    let category: String
    let options: [String]
    let showsChevron: Bool
    let onSelect: (String) -> Void
    @State private var hasCustomSelection = false
    var isActive: Bool {
        viewModel.isFilterActive(for: category)
    }
    var displayText: String {
        viewModel.getFilterDisplayText(for: category)
    }
    var body: some View {
        Group {
            if options.count > 1 {
                Menu {
                    ForEach(options, id: \.self) { option in
                        Button(option) {
                            HapticManager.shared.listSelection()
                            hasCustomSelection = true
                            onSelect(option)
                        }
                    }
                } label: {
                    buttonLabel
                }
                .menuStyle(.borderlessButton)
                .buttonStyle(.plain)
            } else {
                Button {
                    HapticManager.shared.buttonTap()
                    hasCustomSelection = true
                    onSelect(category)
                } label: {
                    buttonLabel
                }
            }
        }
    }
    @ViewBuilder
    private var buttonLabel: some View {
        HStack(spacing: 4) {
            Text(displayText)
                .font(DesignTokens.Typography.callout)
                .foregroundColor(isActive ? .white : DesignTokens.Text.primary)
                .contentTransition(.opacity)
                .animation(.easeInOut(duration: 0.2), value: displayText)
            if showsChevron && options.count > 1 {
                Image(systemName: "chevron.down")
                    .font(.system(size: DesignTokens.IconSize.chevron))
                    .foregroundColor(isActive ? .white : DesignTokens.Text.primary)
            }
        }
        .padding(.vertical, 5)
        .padding(.horizontal, DesignTokens.Spacing.md)
        .background(
            Capsule()
                .fill(
                    isActive
                    ? Color.blue
                    : Color(DesignTokens.Background.primary)
                )
        )
        .scaleEffect(isActive ? 1.05 : 1.0)
        .animation(.spring(response: 0.25, dampingFraction: 0.9, blendDuration: 0), value: isActive)
        .animation(.easeInOut(duration: 0.15), value: displayText)
    }
}
#Preview("Category Filters View") {
    CategoryFiltersView(selectedCategory: .constant(nil))
        .padding()
}

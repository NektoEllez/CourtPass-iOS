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
            HStack(spacing: DesignTokens.Spacing.inner) {
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
            .padding(.horizontal, DesignTokens.Spacing.screenH)  
        }
        .padding(.horizontal, -DesignTokens.Spacing.screenH)
        .padding(.top, DesignTokens.Spacing.inner)
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
                    .padding(.horizontal, DesignTokens.Spacing.block)
                    .background(
                        hasCustomSelection
                        ? Color(DesignTokens.Background.primary.opacity(0.5))
                        : Color(DesignTokens.Background.primary)
                    )
                    .clipShape(Capsule())
                    .scaleEffect(hasCustomSelection ? 1.05 : 1.0)
                    .animation(DesignTokens.Animation.snappy, value: hasCustomSelection)
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
                    .padding(.horizontal, DesignTokens.Spacing.block)
                    .background(
                        hasCustomSelection
                        ? Color(DesignTokens.Background.primary.opacity(0.5))
                        : Color(DesignTokens.Background.primary)
                    )
                    .clipShape(Capsule())
                    .scaleEffect(hasCustomSelection ? 1.05 : 1.0)
                    .animation(DesignTokens.Animation.snappy, value: hasCustomSelection)
                }
            }
        }
    }
}


#Preview("Category Filters View") {
    CategoryFiltersView(selectedCategory: .constant(nil))
        .padding()
}

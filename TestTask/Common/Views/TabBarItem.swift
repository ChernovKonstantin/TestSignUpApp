import SwiftUI

struct TabBarItem: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top) {
                Image(systemName: icon)
                    .foregroundColor(isSelected ? .blue : .gray)
                Text(label)
                    .foregroundColor(isSelected ? .blue : .gray)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.clear)
            .cornerRadius(8)
        }
    }
}

#Preview {
    TabBarItem(icon: "", label: "11", isSelected: true, action: {})
}

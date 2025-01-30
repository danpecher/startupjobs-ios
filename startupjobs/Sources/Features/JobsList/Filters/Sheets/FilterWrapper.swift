import SwiftUI

struct FilterWrapper: View {
    let filter: (any Filter)?
    
    let onDoneTapped: () -> Void
    
    var body: some View {
        VStack {
            switch filter {
            case let filter as ListFilter:
                ListFilterView(filter: filter)
            default:
                EmptyView()
            }
            
            Button {
                onDoneTapped()
            } label: {
                Text("Done")
                    .font(Fonts.regular)
                    .foregroundStyle(Colors.primary)
            }
        }
    }
}

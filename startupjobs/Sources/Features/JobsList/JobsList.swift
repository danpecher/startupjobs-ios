import SwiftUI

struct JobsList: View {
    let viewModel: JobsListViewModel
    
    var body: some View {
        VStack {
            Text("Jobs list")
            Button {
                viewModel.openJobDetail(id: 1)
            } label: {
                Text("Job 1 detail")
            }

        }
    }
}


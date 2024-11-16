import SwiftUI
import Monocle

struct ContentView: View {
    @State private var assessmentStatus: String = "Assessment Status: Waiting"
    @State private var assessmentColor: Color = .black
    @State private var encryptedAssessment: String = ""
    @State private var isLoading: Bool = false
    @State private var showDetails: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            // Grouped Status and Button
            VStack(spacing: 15) {
                Text(assessmentStatus)
                    .foregroundColor(assessmentColor)
                
                if !isLoading {
                    Button(action: startAssessment) {
                        Text("Start Assessment")
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.bottom, showDetails ? 20 : 0) // Reduce spacing when details are shown
            
            // Encrypted Assessment Data Display
            if showDetails {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Encrypted Assessment:")
                            .bold()
                            .padding([.top, .bottom], 5)
                        Text(encryptedAssessment)
                            .padding()
                    }
                    .padding(.horizontal)
                }
                .transition(.opacity)
            }
            
            Spacer()
        }
        .padding()
        .animation(.easeInOut, value: showDetails)
    }
    
    func startAssessment() {
        isLoading = true
        encryptedAssessment = "" // Clear previous result
        assessmentStatus = "Assessment Status: In Progress"
        assessmentColor = .blue
        
        Task {
            let result = await Monocle.shared.assess()
            isLoading = false
            
            if result.status.lowercased().contains("error") {
                assessmentStatus = "Assessment Status: Failed"
                assessmentColor = .red
            } else {
                assessmentStatus = "Assessment Status: Success"
                assessmentColor = .green
                encryptedAssessment = result.data ?? "No data available"
            }
            
            withAnimation {
                showDetails = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


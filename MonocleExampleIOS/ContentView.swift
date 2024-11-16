import SwiftUI
import Monocle

struct ContentView: View {
    @State private var assessmentStatus: String = "Assessment Status: Waiting"
    @State private var assessmentColor: Color = .black
    @State private var encryptedAssessment: String = ""
    @State private var decryptedAssessment: DecryptedAssessment?
    @State private var decryptionError: String?
    @State private var isLoading: Bool = false
    @State private var showDetails: Bool = false
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            // Status and Button
            VStack(spacing: 15) {
                Text(assessmentStatus)
                    .foregroundColor(assessmentColor)
                    .font(.headline)
                
                if isLoading {
                    ProgressView()
                } else {
                    Button(action: startAssessment) {
                        Text("Start Assessment")
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, showDetails ? 20 : 0)
            
            // Encrypted and Decrypted Assessment Display
            if showDetails {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Encrypted Assessment
                        Group {
                            Text("Encrypted Assessment:")
                                .bold()
                            Text(encryptedAssessment)
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(8)
                        }
                        
                        // Decrypted Assessment or Decryption Error
                        if let decryptedAssessment = decryptedAssessment {
                            // Decrypted Data Display
                            Text("Decrypted Assessment:")
                                .bold()
                            VStack(alignment: .leading, spacing: 5) {
                                if let vpn = decryptedAssessment.vpn {
                                    Text("VPN: \(vpn ? "Yes" : "No")")
                                }
                                if let proxied = decryptedAssessment.proxied {
                                    Text("Proxied: \(proxied ? "Yes" : "No")")
                                }
                                if let anon = decryptedAssessment.anon {
                                    Text("Anonymous: \(anon ? "Yes" : "No")")
                                }
                                if let rdp = decryptedAssessment.rdp {
                                    Text("RDP: \(rdp ? "Yes" : "No")")
                                }
                                if let dch = decryptedAssessment.dch {
                                    Text("Datacenter Hosting: \(dch ? "Yes" : "No")")
                                }
                                if let cc = decryptedAssessment.cc {
                                    Text("Country Code: \(cc)")
                                }
                                if let ip = decryptedAssessment.ip {
                                    Text("IP Address: \(ip)")
                                }
                                if let ipv6 = decryptedAssessment.ipv6 {
                                    Text("IPv6 Address: \(ipv6)")
                                }
                                if let ts = decryptedAssessment.ts {
                                    Text("Timestamp: \(formattedDate(ts))")
                                }
                                if let complete = decryptedAssessment.complete {
                                    Text("Complete: \(complete ? "Yes" : "No")")
                                }
                                if let id = decryptedAssessment.id {
                                    Text("Assessment ID: \(id)")
                                }
                                if let sid = decryptedAssessment.sid {
                                    Text("Site ID: \(sid)")
                                }
                            }
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(8)
                        } else if let decryptionError = decryptionError {
                            // Decryption Error Display
                            Text("Decryption Error:")
                                .bold()
                            Text(decryptionError)
                                .foregroundColor(.red)
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(8)
                        } else {
                            // Decryption Not Available
                            Text("Decrypted data not available.")
                                .italic()
                        }
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
        encryptedAssessment = ""
        decryptedAssessment = nil
        decryptionError = nil
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
                
                if let encryptedData = result.data, !encryptedData.isEmpty {
                    // Attempt to decrypt the assessment
                    let decryptionResult = await Monocle.shared.decryptAssessment(encryptedData: encryptedData)
                    switch decryptionResult {
                    case .success(let decryptedData):
                        decryptedAssessment = decryptedData
                    case .failure(let error):
                        // Handle decryption error
                        if let nsError = error as NSError?, nsError.domain == "MonocleErrorDomain", nsError.code == -1 {
                            // Decryption token not set
                            decryptionError = "Decryption token is not set. Decrypted data is not available."
                        } else {
                            decryptionError = "Decryption failed: \(error.localizedDescription)"
                        }
                    }
                }
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

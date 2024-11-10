//
//  SettingView.swift
//  LOLBook
//
//  Created by Jesse Liang on 2024/11/10.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "en"
    
    @State private var toggleAnimation = false // State for animation control
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    // Dark mode toggle with animation
                    Toggle(isOn: $isDarkMode) {
                        ZStack {
                            Rectangle()
                                .frame(width: 36, height: 36)
                                .cornerRadius(10)
                                .foregroundColor(isDarkMode ? .purple : .blue)
                                .animation(.easeInOut(duration: 0.3), value: isDarkMode) // Add animation
                            SwiftUI.Image(systemName: "sun.max")
                        }
                        Text("Dark Mode")
                            .fontWeight(.semibold)
                    }
                    .animation(.spring(), value: toggleAnimation) // Smooth animation for toggle change
                    
                    // Language selection
                    HStack {
                        ZStack {
                            Rectangle()
                                .frame(width: 36, height: 36)
                                .cornerRadius(10)
                                .foregroundColor(.red)
                            SwiftUI.Image(systemName: "flag")
                        }
                        Text("Language")
                            .fontWeight(.semibold)
                        Spacer()
                        Picker("", selection: $selectedLanguage) {
                            Text("English").tag("en")
                            Text("中文").tag("zh")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .transition(.scale) // Add transition animation to language picker
                    }
                    .padding(.vertical)
                }
                .listStyle(.plain)
                Spacer()
            }
            .navigationTitle("Settings")
            .padding()
            .onChange(of: selectedLanguage) { _ in
                withAnimation { // Trigger animation when language changes
                    toggleAnimation.toggle()
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

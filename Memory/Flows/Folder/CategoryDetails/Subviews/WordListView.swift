//
//  WordListView.swift
//  Memory
//


import SwiftUI

struct WordListView: View {
    @State private var showingOptions: Bool = false
    @State private var showingDeleteConfirmation: Bool = false

    let level: RepeatLevel
    let word: String
    let translation: String
    let editAction: () -> Void
    let deleteAction: () -> Void

    var body: some View {
        Button(action: { showingOptions = true }) {
            HStack {
                Rectangle()
                    .frame(width: 6)
                    .foregroundColor(level.color)
                    .cornerRadius(3)
                    .padding(.vertical, 3)
                
                VStack(alignment: .leading, spacing: 4) {
                    SecondText(level.title)
                    MainText(word, fontWeight: .black)
                    MainText(translation)
                }
                
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PressButtonStyle())
        .confirmationDialog("Select option", isPresented: $showingOptions, titleVisibility: .visible) {
            Button("Edit") {
                editAction()
            }

            Button("Delete", role: .destructive) {
                showingDeleteConfirmation = true
            }
        }
        .confirmationDialog("Are you sure you want to delete?", isPresented: $showingDeleteConfirmation, titleVisibility: .visible) {
            Button("Yes", role: .destructive) {
                deleteAction()
            }

            Button("No") {
                showingDeleteConfirmation = false
            }
        }
    }
}

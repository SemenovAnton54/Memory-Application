//
//  CategoryDetailsWordListView.swift
//  Memory
//


import SwiftUI

struct CategoryDetailsWordListView: View {
    typealias AccessibilityIdentifier = CategoryDetailsAccessibilityIdentifier

    @State private var showingOptions: Bool = false
    @State private var showingDeleteConfirmation: Bool = false

    let id: Int
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
                        .accessibilityIdentifier(AccessibilityIdentifier.wordValueCellTitle(id: id))
                    MainText(translation)
                        .accessibilityIdentifier(AccessibilityIdentifier.wordTranslationCellTitle(id: id))
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
            .accessibilityIdentifier(AccessibilityIdentifier.editButton)

            Button("Delete", role: .destructive) {
                showingDeleteConfirmation = true
            }
            .accessibilityIdentifier(AccessibilityIdentifier.deleteButton)
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

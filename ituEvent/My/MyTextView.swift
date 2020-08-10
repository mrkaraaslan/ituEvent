//
//  MyTextView.swift
//  ituEvent
//
//  Created by Mehmet Karaaslan on 23.07.2020.
//  Copyright © 2020 Mehmet Karaaslan. All rights reserved.
//

import SwiftUI

struct MyTextView: View {
    @Binding var text: String
    var placeholder: String = ""
    var height: Int
    
    var body: some View {
        TextView(text: $text, placeholder: placeholder)
            .padding(.leading, 10)
            .frame(height: CGFloat(height))
            .overlay(
                RoundedRectangle(cornerRadius: 15).stroke(Color.mainColor)
            )
    }
}

struct TextView: UIViewRepresentable {
    
    @Binding var text: String
    var placeholder: String
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.isScrollEnabled = true
        view.text = placeholder
        view.textColor = .placeholderText
        view.font = .systemFont(ofSize: 17)
        view.delegate = context.coordinator
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        let doneButton = UIBarButtonItem(title: "Tamam", style: .done, target: self, action: #selector(view.doneButtonTapped(button:)))
        toolBar.items = [doneButton]
        toolBar.setItems([doneButton], animated: true)
        view.inputAccessoryView = toolBar
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        
        return TextView.Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        
        var parent: TextView
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == parent.placeholder {
                textView.text = ""
            }
            textView.textColor = .label
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text == "" {
                textView.text = parent.placeholder
                textView.textColor = .placeholderText
            }
        }
        
        init(parent: TextView) {
            self.parent = parent
        }
    }
}

extension  UITextView {
    @objc func doneButtonTapped(button: UIBarButtonItem) {
       self.resignFirstResponder()
    }
}

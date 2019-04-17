//
//  ViewController.swift
//  ageCalculator
//
//  Created by user151705 on 4/11/19.
//  Copyright © 2019 hugoiuri. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var birthdateTextField: UITextField!
    @IBOutlet weak var ageLabel: UILabel!
    
    enum AgeError: Error {
        case emptyText
        case invalidFormat
        case invalidDate
        case futureBirthday
        case unknown
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func actionButtonDidTap(_ sender: Any) {
        guard let text = birthdateTextField.text else {
            ageLabel.text = ""
            return
        }
        
        do {
            let age = try calculateAge(from: text, dateFormat: "dd/MM/yyyy")
            ageLabel.text = "\(age) anos"
        } catch let error as AgeError {
            ageLabel.text = errorMessage(from: error)
        } catch {
            ageLabel.text = "Tente novamente."
        }
    }
    
    
    private func calculateAge(from text: String, dateFormat: String) throws -> Int {
        guard !text.isEmpty else { throw AgeError.emptyText }
        guard text.count == dateFormat.count else { throw AgeError.invalidFormat }
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        guard let birthday = dateFormatter.date(from: text) else { throw AgeError.invalidDate }
        guard now.compare(birthday) == .orderedDescending else { throw AgeError.futureBirthday }
        
        if let age = Calendar.current.dateComponents([.year], from: birthday, to: now).year {
            return age
        } else {
            throw AgeError.unknown
        }
    }

    private func errorMessage(from error: AgeError) -> String {
        switch error {
        case AgeError.emptyText: return "Data vazia."
        case AgeError.invalidDate: return "Data inválida."
        case AgeError.invalidFormat: return "Formato inválido."
        case AgeError.futureBirthday: return "Prevendo futuro? 😱"
        case AgeError.unknown: return "Erro desconhecido."
        }
    }
}


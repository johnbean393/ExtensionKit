//
//  File.swift
//  
//
//  Created by Bean John on 27/12/2023.
//

import Foundation

enum LanguageError: Error {
	case noLanguageIdentified
}

extension String {
	
	func wildcard(pattern: String) -> Bool {
		let pred = NSPredicate(format: "self LIKE %@", pattern)
		return !NSArray(object: self).filtered(using: pred).isEmpty
	}
	
	func strDominantLanguage() throws -> String {
		if let language = NSLinguisticTagger.dominantLanguage(for: self) {
			return language
		}
		throw LanguageError.noLanguageIdentified
	}
	
	
	
}

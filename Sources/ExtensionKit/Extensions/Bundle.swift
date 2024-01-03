//
//  Bundle.swift
//
//
//  Created by Bean John on 3/1/2024.
//

import Foundation

extension Bundle {
	
	// Application name shown under the application icon.
	public var applicationName: String? {
		object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
		object(forInfoDictionaryKey: "CFBundleName") as? String
	}
	
}

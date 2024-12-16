//
//  Protocols.swift
//  BookMeNow
//
//  Created by Neshwa on 15/02/24.
//

import Foundation
import UIKit


protocol ToggleCellDelegate: AnyObject {
    func toggleValueChanged(isOn: Bool)
}

protocol GeneralSettingsDelegate : AnyObject {
    func fromGeneralSettings(value: Bool)
}

//
//  CGKeyCode.swift
//
//
//  Created by Bean John on 27/12/2023.
//

import Foundation
import CoreGraphics

#if os(macOS)
@available(macOS 12.0, *)
extension CGKeyCode
{
	/*
	 * From Events.h in Carbon.framework
	 *  Summary:
	 *    Virtual keycodes
	 *
	 *  Discussion:
	 *    These constants are the virtual keycodes defined originally in
	 *    Inside Mac Volume V, pg. V-191. They identify physical keys on a
	 *    keyboard. Those constants with "ANSI" in the name are labeled
	 *    according to the key position on an ANSI-standard US keyboard.
	 *    For example, kVK_ANSI_A indicates the virtual keycode for the key
	 *    with the letter 'A' in the US keyboard layout. Other keyboard
	 *    layouts may have the 'A' key label on a different physical key;
	 *    in this case, pressing 'A' will generate a different virtual
	 *    keycode.
	 */
	
	static public let kVK_ANSI_A                    : CGKeyCode = 0x00
	static public let kVK_ANSI_S                    : CGKeyCode = 0x01
	static public let kVK_ANSI_D                    : CGKeyCode = 0x02
	static public let kVK_ANSI_F                    : CGKeyCode = 0x03
	static public let kVK_ANSI_H                    : CGKeyCode = 0x04
	static public let kVK_ANSI_G                    : CGKeyCode = 0x05
	static public let kVK_ANSI_Z                    : CGKeyCode = 0x06
	static public let kVK_ANSI_X                    : CGKeyCode = 0x07
	static public let kVK_ANSI_C                    : CGKeyCode = 0x08
	static public let kVK_ANSI_V                    : CGKeyCode = 0x09
	static public let kVK_ANSI_B                    : CGKeyCode = 0x0B
	static public let kVK_ANSI_Q                    : CGKeyCode = 0x0C
	static public let kVK_ANSI_W                    : CGKeyCode = 0x0D
	static public let kVK_ANSI_E                    : CGKeyCode = 0x0E
	static public let kVK_ANSI_R                    : CGKeyCode = 0x0F
	static public let kVK_ANSI_Y                    : CGKeyCode = 0x10
	static public let kVK_ANSI_T                    : CGKeyCode = 0x11
	static public let kVK_ANSI_1                    : CGKeyCode = 0x12
	static public let kVK_ANSI_2                    : CGKeyCode = 0x13
	static public let kVK_ANSI_3                    : CGKeyCode = 0x14
	static public let kVK_ANSI_4                    : CGKeyCode = 0x15
	static public let kVK_ANSI_6                    : CGKeyCode = 0x16
	static public let kVK_ANSI_5                    : CGKeyCode = 0x17
	static public let kVK_ANSI_Equal                : CGKeyCode = 0x18
	static public let kVK_ANSI_9                    : CGKeyCode = 0x19
	static public let kVK_ANSI_7                    : CGKeyCode = 0x1A
	static public let kVK_ANSI_Minus                : CGKeyCode = 0x1B
	static public let kVK_ANSI_8                    : CGKeyCode = 0x1C
	static public let kVK_ANSI_0                    : CGKeyCode = 0x1D
	static public let kVK_ANSI_RightBracket         : CGKeyCode = 0x1E
	static public let kVK_ANSI_O                    : CGKeyCode = 0x1F
	static public let kVK_ANSI_U                    : CGKeyCode = 0x20
	static public let kVK_ANSI_LeftBracket          : CGKeyCode = 0x21
	static public let kVK_ANSI_I                    : CGKeyCode = 0x22
	static public let kVK_ANSI_P                    : CGKeyCode = 0x23
	static public let kVK_ANSI_L                    : CGKeyCode = 0x25
	static public let kVK_ANSI_J                    : CGKeyCode = 0x26
	static public let kVK_ANSI_Quote                : CGKeyCode = 0x27
	static public let kVK_ANSI_K                    : CGKeyCode = 0x28
	static public let kVK_ANSI_Semicolon            : CGKeyCode = 0x29
	static public let kVK_ANSI_Backslash            : CGKeyCode = 0x2A
	static public let kVK_ANSI_Comma                : CGKeyCode = 0x2B
	static public let kVK_ANSI_Slash                : CGKeyCode = 0x2C
	static public let kVK_ANSI_N                    : CGKeyCode = 0x2D
	static public let kVK_ANSI_M                    : CGKeyCode = 0x2E
	static public let kVK_ANSI_Period               : CGKeyCode = 0x2F
	static public let kVK_ANSI_Grave                : CGKeyCode = 0x32
	static public let kVK_ANSI_KeypadDecimal        : CGKeyCode = 0x41
	static public let kVK_ANSI_KeypadMultiply       : CGKeyCode = 0x43
	static public let kVK_ANSI_KeypadPlus           : CGKeyCode = 0x45
	static public let kVK_ANSI_KeypadClear          : CGKeyCode = 0x47
	static public let kVK_ANSI_KeypadDivide         : CGKeyCode = 0x4B
	static public let kVK_ANSI_KeypadEnter          : CGKeyCode = 0x4C
	static public let kVK_ANSI_KeypadMinus          : CGKeyCode = 0x4E
	static public let kVK_ANSI_KeypadEquals         : CGKeyCode = 0x51
	static public let kVK_ANSI_Keypad0              : CGKeyCode = 0x52
	static public let kVK_ANSI_Keypad1              : CGKeyCode = 0x53
	static public let kVK_ANSI_Keypad2              : CGKeyCode = 0x54
	static public let kVK_ANSI_Keypad3              : CGKeyCode = 0x55
	static public let kVK_ANSI_Keypad4              : CGKeyCode = 0x56
	static public let kVK_ANSI_Keypad5              : CGKeyCode = 0x57
	static public let kVK_ANSI_Keypad6              : CGKeyCode = 0x58
	static public let kVK_ANSI_Keypad7              : CGKeyCode = 0x59
	static public let kVK_ANSI_Keypad8              : CGKeyCode = 0x5B
	static public let kVK_ANSI_Keypad9              : CGKeyCode = 0x5C
	
	// keycodes for keys that are independent of keyboard layout
	static public let kVK_Return                    : CGKeyCode = 0x24
	static public let kVK_Tab                       : CGKeyCode = 0x30
	static public let kVK_Space                     : CGKeyCode = 0x31
	static public let kVK_Delete                    : CGKeyCode = 0x33
	static public let kVK_Escape                    : CGKeyCode = 0x35
	static public let kVK_Command                   : CGKeyCode = 0x37
	static public let kVK_Shift                     : CGKeyCode = 0x38
	static public let kVK_CapsLock                  : CGKeyCode = 0x39
	static public let kVK_Option                    : CGKeyCode = 0x3A
	static public let kVK_Control                   : CGKeyCode = 0x3B
	static public let kVK_RightCommand              : CGKeyCode = 0x36 // Out of order
	static public let kVK_RightShift                : CGKeyCode = 0x3C
	static public let kVK_RightOption               : CGKeyCode = 0x3D
	static public let kVK_RightControl              : CGKeyCode = 0x3E
	static public let kVK_Function                  : CGKeyCode = 0x3F
	static public let kVK_F17                       : CGKeyCode = 0x40
	static public let kVK_VolumeUp                  : CGKeyCode = 0x48
	static public let kVK_VolumeDown                : CGKeyCode = 0x49
	static public let kVK_Mute                      : CGKeyCode = 0x4A
	static public let kVK_F18                       : CGKeyCode = 0x4F
	static public let kVK_F19                       : CGKeyCode = 0x50
	static public let kVK_F20                       : CGKeyCode = 0x5A
	static public let kVK_F5                        : CGKeyCode = 0x60
	static public let kVK_F6                        : CGKeyCode = 0x61
	static public let kVK_F7                        : CGKeyCode = 0x62
	static public let kVK_F3                        : CGKeyCode = 0x63
	static public let kVK_F8                        : CGKeyCode = 0x64
	static public let kVK_F9                        : CGKeyCode = 0x65
	static public let kVK_F11                       : CGKeyCode = 0x67
	static public let kVK_F13                       : CGKeyCode = 0x69
	static public let kVK_F16                       : CGKeyCode = 0x6A
	static public let kVK_F14                       : CGKeyCode = 0x6B
	static public let kVK_F10                       : CGKeyCode = 0x6D
	static public let kVK_F12                       : CGKeyCode = 0x6F
	static public let kVK_F15                       : CGKeyCode = 0x71
	static public let kVK_Help                      : CGKeyCode = 0x72
	static public let kVK_Home                      : CGKeyCode = 0x73
	static public let kVK_PageUp                    : CGKeyCode = 0x74
	static public let kVK_ForwardDelete             : CGKeyCode = 0x75
	static public let kVK_F4                        : CGKeyCode = 0x76
	static public let kVK_End                       : CGKeyCode = 0x77
	static public let kVK_F2                        : CGKeyCode = 0x78
	static public let kVK_PageDown                  : CGKeyCode = 0x79
	static public let kVK_F1                        : CGKeyCode = 0x7A
	static public let kVK_LeftArrow                 : CGKeyCode = 0x7B
	static public let kVK_RightArrow                : CGKeyCode = 0x7C
	static public let kVK_DownArrow                 : CGKeyCode = 0x7D
	static public let kVK_UpArrow                   : CGKeyCode = 0x7E
	
	// ISO keyboards only
	static public let kVK_ISO_Section               : CGKeyCode = 0x0A
	
	// JIS keyboards only
	static public let kVK_JIS_Yen                   : CGKeyCode = 0x5D
	static public let kVK_JIS_Underscore            : CGKeyCode = 0x5E
	static public let kVK_JIS_KeypadComma           : CGKeyCode = 0x5F
	static public let kVK_JIS_Eisu                  : CGKeyCode = 0x66
	static public let kVK_JIS_Kana                  : CGKeyCode = 0x68
	
	public var isModifier: Bool {
		return (.kVK_RightCommand...(.kVK_Function)).contains(self)
	}
	
	public var baseModifier: CGKeyCode?
	{
		if (.kVK_Command...(.kVK_Control)).contains(self)
			|| self == .kVK_Function
		{
			return self
		}
		
		switch self
		{
			case .kVK_RightShift: return .kVK_Shift
			case .kVK_RightCommand: return .kVK_Command
			case .kVK_RightOption: return .kVK_Option
			case .kVK_RightControl: return .kVK_Control
				
			default: return nil
		}
	}
	
	public var isPressed: Bool {
		CGEventSource.keyState(.combinedSessionState, key: self)
	}
}

// Example usage
//private let keyMessages: [CGKeyCode: String] = [
//	.kVK_Space: "Space",
//]
//@State var eventMonitor: Any? = nil
//eventMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
//	if keyMessages[CGKeyCode(Int(event.keyCode))] != nil {
//		print("Space key pressed")
//	}
//	return event
//}

#endif

//
//  Validation_Model.swift
//  Mockup_Band_Design_Preet

import UIKit

// 2 decimal place  in double value code
extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}

// phone number validation
extension String {
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}

class Validation_Model: NSObject
{
    //MARK: this just validates that you have all digits not that it is a valid phone number
    class func isvalidatePhoneHavingDigitsOnly(phoneNumber: String) -> Bool
    {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = phoneNumber.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  phoneNumber == filtered
    }
    
    //MARK: validate email
   class func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    //MARK: password length
    class func isPwdLenth(password: String ) -> Bool
    {  //, confirmPassword : String
        if password.count >= 6 //&& confirmPassword.characters.count <= 7
        {
            return true
        }else
        {
            return false
        }
    }
    // MARK: conform password check
   class func isPwdMatchConfirmPwd(password: String, confirmPassword : String ) -> Bool {
        if password == confirmPassword
        {
            return true
        }else{
            return false
        }
    }
    
    class func getSafeInt(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        // Create an `NSCharacterSet` set which includes everything *but* the digits
        let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
        
        // At every character in this "inverseSet" contained in the string,
        // split the string up into components which exclude the characters
        // in this inverse set
        let components = string.components(separatedBy: inverseSet)
        
        // Rejoin these components
        let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift 1.2
        
        // If the original string is equal to the filtered string, i.e. if no
        // inverse characters were present to be eliminated, the input is valid
        // and the statement returns true; else it returns false
        return string == filtered  
    }
    
    class func verifyUrl (urlString: String?) -> Bool
    {
        if let urlString = urlString {
            if let url  = NSURL(string: urlString)
            {
                return UIApplication.shared.canOpenURL(url as URL)
                //return UIApplication.sharedApplication().canOpenURL(url)
            }
        }
        return false
    }
    
    class func validateWhiteSpace(_ str: String?) -> Bool
    {
        if (str == nil)
        {
            return false
        }
        
        if  (str?.isKind(of: NSString.self))!
        {
            let trimmed: String = str!.trimmingCharacters(in: CharacterSet.whitespaces)
            
            if trimmed.count > 0
            {
                return true
            }
        }
        
        return false
    }
    
    class func isNullOrNilObject(_ object: Any) -> Bool
    {
        if (object is NSNull)
        {
            return true
        }
        if object == nil
        {
            return true
        }
        if (object as! String == "nil")
        {
            return true
        }
        
        return false
    }
    
    class func validatePhoneNumber(value: String) -> Bool {
        
        let PHONE_REGEX = "(^0[78][2347][0-9]{7})"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        print(phoneTest.evaluate(with: value))
        return result
    }
    
//    class func md5(_ string: String) -> String
//    {
//        
//        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
//        var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
//        CC_MD5_Init(context)
//        CC_MD5_Update(context, string, CC_LONG(string.lengthOfBytes(using: String.Encoding.utf8)))
//        CC_MD5_Final(&digest, context)
//        context.deallocate(capacity: 1)
//        var hexString = ""
//        for byte in digest {
//            hexString += String(format:"%02x", byte)
//        }
//        
//        return hexString
//    }

//    class func isValidObject(_ object: Any) -> Bool
//    {
//        return !Validator.isNullOrNilObject(object)
//    }

    class func isValidPassword(passwordString: String) -> Bool
    {
        return passwordString.count >= 6
//        let passRegEx = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=\\S+$).{8,}$"
//        //"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{6,}" iOS
//        let passTest = NSPredicate(format:"SELF MATCHES %@", passRegEx)
//        return passTest.evaluate(with: passwordString)
    }
}

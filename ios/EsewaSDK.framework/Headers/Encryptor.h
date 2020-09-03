//
//  Encryptor.h
//  FoneBankX
//
//  Created by F1soft International on 1/24/13.
//  Copyright (c) 2013 F1Soft International. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Encryptor : NSObject

+  (NSString *) base64Encode:(NSString *)plainText;
+  (NSString *) base64Decode:(NSString *)base64String;
+  (NSString *) encryptString:(NSString *) plainText;
+  (NSString *) decryptString:(NSString *)encryptedText;

@end

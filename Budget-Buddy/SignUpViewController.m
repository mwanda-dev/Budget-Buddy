//
//  SignUpViewController.m
//  Budget-Buddy
//
//  Created by Mwanda Chipongo on 31/05/2024.
//

#import <Foundation/Foundation.h>
#import "SignUpViewController.h"
#import "CoreDataManager.h"
#import <CommonCrypto/CommonCrypto.h>

@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UISwitch *biometricSwitch;
@property (weak, nonatomic) IBOutlet UILabel *feedbackLabel;
@property(nonatomic, strong) UIColor *greenColor;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.passwordTextField.secureTextEntry = YES;
}

- (IBAction)signUpButtonTapped:(id)sender {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if (![self isValidUsername:username]) {
        return;
    }
    
    if (![self isValidPassword:password]) {
        return;
    }
    
    NSString *passwordHash = [self hashPassword:password];
    
    BOOL useBiometrics = self.biometricSwitch.isOn;
    
    [[CoreDataManager sharedManager] saveUserWithUsername:username passwordHash:passwordHash useBiometrics:useBiometrics];
    
    // Show success message or navigate to login screen
    [self.feedbackLabel setTextColor:_greenColor];
    [self.feedbackLabel setText:@"Sign up successful"];
    [NSThread sleepForTimeInterval:4]; // wait for 2.2 seconds
    [self performSegueWithIdentifier:@"successfulSignUpSegue" sender:self];
}

- (BOOL)isValidUsername:(NSString *)username {
    // Add your validation logic here
    return username.length > 3;
}

- (BOOL)isValidPassword:(NSString *)password {
    // Add your validation logic here
    return password.length > 6;
}

- (NSString *)hashPassword:(NSString *)password {
    const char *cstr = [password cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:password.length];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

@end

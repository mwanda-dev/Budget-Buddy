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
// These properties each connect to a specified component in the Sign Up View

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.passwordTextField.secureTextEntry = YES; // Ensures that the password isn't visible to the user when it is being typed
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
    [NSThread sleepForTimeInterval:4]; // wait for 4 seconds
    [self performSegueWithIdentifier:@"successfulSignUpSegue" sender:self];
    // This function receives a username and password from the user input in the text fields in the Sign Up View Controller
    // The successful signup segue then takes them to the login screen
}

- (BOOL)isValidUsername:(NSString *)username {
    return username.length > 3;
    // Ensures usernames are 4 or more characters long
}

- (BOOL)isValidPassword:(NSString *)password {
    return password.length > 7;
    // Ensure passwords are 8 or more characters long
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
    // This function generates a hash of the password entered
    // This hash is stored as part of the user entity
}

@end

//
//  LoginViewController.m
//  Budget-Buddy
//
//  Created by Mwanda Chipongo on 31/05/2024.
//

#import "LoginViewController.h"
#import "CoreDataManager.h"
#import <CommonCrypto/CommonCrypto.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *biometricLoginButton;
@property (weak, nonatomic) IBOutlet UILabel *feedbackLabel;
@property(nonatomic, strong) UIColor *greenColor;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBiometricButton];
    self.passwordTextField.secureTextEntry = YES;
}

- (void)setupBiometricButton {
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;

    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        self.biometricLoginButton.hidden = NO;
    } else {
        self.biometricLoginButton.hidden = YES;
    }
}

- (IBAction)loginButtonTapped:(id)sender {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    NSString *passwordHash = [self hashPassword:password];
    
    BOOL success = [[CoreDataManager sharedManager] validateUserWithUsername:username passwordHash:passwordHash];
    
    if (success) {
        // Navigate to the main screen
        [self.feedbackLabel setTextColor:_greenColor];
        [self.feedbackLabel setText:@"Login successful"];
        [NSThread sleepForTimeInterval:4]; // wait for 4 seconds
        [self performSegueWithIdentifier:@"successfulLoginSegue" sender:self];
        
    } else {
        self.feedbackLabel.text = @"Invalid username or password";
    }
}

- (IBAction)biometricLoginButtonTapped:(id)sender {
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:@"Log in with Face ID / Touch ID."
                          reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Navigate to the main screen
                    self.feedbackLabel.text = @"Login successful";
                    NSLog(@"Biometric Login Succesful");
                    [self performSegueWithIdentifier:@"successfulLoginSegue" sender:self];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.feedbackLabel.text = @"Biometric login failed";
                    NSLog(@"Biometric login failed");
                });
            }
        }];
    } else {
        self.feedbackLabel.text = @"Biometric login not available";
    }
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


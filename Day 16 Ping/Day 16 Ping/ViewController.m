//
//  ViewController.m
//  Day 16 Ping
//
//  Created by Grant Timmerman on 8/24/14.
//  Copyright (c) 2014 Grant Timmerman. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];

    // Setup UI
    _websiteTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 100)];
    _pingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 70, self.view.frame.size.width, 50)];
    _pingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    // Font
    _websiteTextField.font = [UIFont systemFontOfSize:30];
    _pingButton.titleLabel.font = [UIFont systemFontOfSize:30];
    _pingLabel.font = [UIFont systemFontOfSize:80];
    _websiteTextField.textColor = [UIColor whiteColor];
    _pingButton.titleLabel.textColor = [UIColor whiteColor];
    _pingLabel.textColor = [UIColor whiteColor];
    _websiteTextField.textAlignment = NSTextAlignmentCenter;
    _pingButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _pingLabel.textAlignment = NSTextAlignmentCenter;
    // Set default UI Labels
    _websiteTextField.text = @"google.com";
    [_pingButton setTitle:@"Ping" forState:UIControlStateNormal];
    // Website TextField Keyboard
    _websiteTextField.keyboardType = UIKeyboardTypeURL;
    _websiteTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _websiteTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _websiteTextField.returnKeyType = UIReturnKeyDone;
    _websiteTextField.delegate = self;
    // Action listeners
    [_pingButton addTarget:self action:@selector(pingClick:) forControlEvents:UIControlEventTouchUpInside];
    // Add to view
    [self.view addSubview:_websiteTextField];
    [self.view addSubview:_pingButton];
    [self.view addSubview:_pingLabel];
    
    // Setup background
    float r = 255;
    float g = 188;
    float b = 52;
    UIColor *backgroundColor = [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:255];
    [self.view setBackgroundColor:backgroundColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Starts the ping
- (void)startPing {
    // Setup request
    NSString *reqString = _websiteTextField.text;
    NSURL *reqURL = [self getProperURL:reqString];
    
    // Make the request
    long long startDate = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    NSString *data = [self getDataFrom:reqURL];
    long long endDate = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    
    // Calculate the difference
    long long difference = endDate - startDate;
    NSString *pingString = [NSString stringWithFormat:@"%lldms", difference];
    
    // Update UI
    _pingLabel.text = pingString;
    if (difference < 100) {
        _pingLabel.textColor = [UIColor greenColor];
    } else if (difference < 200) {
        _pingLabel.textColor = [UIColor colorWithRed:0.5 green:1 blue:0 alpha:255];
    } else if (difference < 400) {
        _pingLabel.textColor = [UIColor yellowColor];
    } else if (difference < 1000) {
        _pingLabel.textColor = [UIColor colorWithRed:1 green:1 blue:0 alpha:255];
    } else {
        _pingLabel.textColor = [UIColor redColor];
    }
}

// Converts a free-form URL string to a properly formatted URL
- (NSURL*)getProperURL:site {
    NSString *urlString = [NSString stringWithFormat:@"http://www.%@", site];
    return [NSURL URLWithString:urlString];
}

// Action handler for the ping button click
- (void)pingClick:(id)sender {
    [self startPing];
}

// Touch handler
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
    [self startPing];
}

// Button Done handler
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self startPing];
    return YES;
}

// Get Ping time
- (NSString *) getDataFrom:(NSURL*)url{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:url];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if ([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
        return nil;
    }
    
    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
}

@end

//
//  KVNViewController.m
//  KVNProgress
//
//  Created by Kevin Hirsch on 24/05/14.
//  Copyright (c) 2014 Pinch. All rights reserved.
//

#import "KVNViewController.h"

#import "KVNProgress.h"

@interface KVNViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *circularSwitch;

@property (nonatomic) KVNProgressConfiguration *basicConfiguration;
@property (nonatomic) KVNProgressConfiguration *customConfiguration;

@end

@implementation KVNViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
	
	self.basicConfiguration = [KVNProgressConfiguration defaultConfiguration];
	self.customConfiguration = [self customKVNProgressUIConfiguration];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[KVNProgress setConfiguration:self.basicConfiguration];
}

#pragma mark - UI

- (KVNProgressConfiguration *)customKVNProgressUIConfiguration
{
	KVNProgressConfiguration *configuration = [[KVNProgressConfiguration alloc] init];
	
	// See the documentation of KVNProgressConfiguration
	configuration.statusColor = [UIColor whiteColor];
	configuration.statusFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0f];
	configuration.circleStrokeForegroundColor = [UIColor whiteColor];
	configuration.circleStrokeBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
	configuration.circleFillBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.1f];
	configuration.backgroundFillColor = [UIColor colorWithRed:0.173f green:0.263f blue:0.856f alpha:0.9f];
	configuration.backgroundTintColor = [UIColor colorWithRed:0.173f green:0.263f blue:0.856f alpha:0.4f];
	configuration.successColor = [UIColor whiteColor];
	configuration.errorColor = [UIColor whiteColor];
	configuration.circleSize = 110.0f;
	configuration.lineWidth = 1.0f;
	
	return configuration;
}

#pragma mark - Predefined HUD's

- (IBAction)show
{
	__weak KVNViewController *blockSelf = self;
	self.basicConfiguration.tapBlock = ^(KVNProgress *progressView) {
		blockSelf.basicConfiguration.tapBlock = nil;
		[KVNProgress dismiss];
	};
	
	[KVNProgress show];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		self.basicConfiguration.tapBlock = nil;
		[KVNProgress dismiss];
	});
}

- (IBAction)showWithSolidBackground
{
	[KVNProgress showWithStatus:@"Loading..."];
	
	dispatch_main_after(3.0f, ^{
		[KVNProgress dismiss];
	});
}

- (IBAction)showWithStatus
{
	[KVNProgress showWithStatus:@"Loading..."];
	
	dispatch_main_after(3.0f, ^{
		[KVNProgress dismiss];
	});
}

- (IBAction)showProgress
{
	[KVNProgress showProgress:0.0f];
	
	[self updateProgress];
	
	dispatch_main_after(2.7f, ^{
		[KVNProgress updateStatus:@"You can change to a multiline status text dynamically!"];
	});
	dispatch_main_after(5.5f, ^{
		[self showSuccess];
	});
}

- (IBAction)showSuccess
{
	[KVNProgress showSuccessWithStatus:@"Success"];
}

- (IBAction)showError
{
	[KVNProgress showErrorWithStatus:@"Error"];
}

- (IBAction)showCustom
{
	[KVNProgress setConfiguration:self.customConfiguration];
	
	[KVNProgress showProgress:0.0f
					   status:@"You can custom several things like colors, fonts, circle size, and more!"];
	
	[self updateProgress];
	
	dispatch_main_after(5.5f, ^{
		[self showSuccess];
		[KVNProgress setConfiguration:self.basicConfiguration];
	});
}

#pragma mark - Actions

- (IBAction)circularSwitchDidChange
{
    self.basicConfiguration.circular = [self.circularSwitch isOn];
    self.customConfiguration.circular = [self.circularSwitch isOn];
}

#pragma mark - Helpers

- (void)updateProgress
{
	dispatch_main_after(2.0f, ^{
		[KVNProgress updateProgress:0.3f
						   animated:YES];
	});
	dispatch_main_after(2.5f, ^{
		[KVNProgress updateProgress:0.5f
						   animated:YES];
	});
	dispatch_main_after(2.8f, ^{
		[KVNProgress updateProgress:0.6f
						   animated:YES];
	});
	dispatch_main_after(3.7f, ^{
		[KVNProgress updateProgress:0.93f
						   animated:YES];
	});
	dispatch_main_after(5.0f, ^{
		[KVNProgress updateProgress:1.0f
						   animated:YES];
	});
}

static void dispatch_main_after(NSTimeInterval delay, void (^block)(void))
{
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		block();
	});
}

@end

//
//  SHKFacebookForm.m
//  ShareKit
//

#import "SHKFormControllerLargeTextField.h"
#import "SHK.h"
#import <QuartzCore/QuartzCore.h>

@interface SHKFormControllerLargeTextField ()

@property (nonatomic, retain) UILabel *counter;
@property BOOL shareIsCancelled;

- (void)layoutCounter;
- (void)updateCounter;
- (void)save;
- (void)keyboardWillShow:(NSNotification *)notification;
- (BOOL)shouldShowCounter;
- (void)ifNoTextDisableSendButton;
- (void)setupBarButtonItems;

@end

@implementation SHKFormControllerLargeTextField

@synthesize delegate, textView, maxTextLength;
@synthesize counter, hasLink, image, imageTextLength;
@synthesize shareText;
@synthesize shareIsCancelled;
@synthesize allowSendingEmptyMessage;
@synthesize imageView;

- (void)dealloc 
{
	[textView release];
	[counter release];
	[shareText release];
	[image release];
	self.imageView = nil;
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id <SHKFormControllerLargeTextFieldDelegate>)aDelegate
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{		
		delegate = aDelegate;
		imageTextLength = 0;
		hasLink = NO;
		maxTextLength = 0;
        allowSendingEmptyMessage = NO;
	}
	return self;
}

- (void)loadView 
{
	[super loadView];
	
	self.view.backgroundColor = [UIColor whiteColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    CGRect textViewFrame = CGRectZero;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        textViewFrame.origin.x = 20;
        textViewFrame.origin.y = 30;
        textViewFrame.size.width = self.view.bounds.size.width - 40;
        textViewFrame.size.height = 200;
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        textViewFrame.origin.x = 10;
        textViewFrame.origin.y = 15;
        textViewFrame.size.width = self.view.bounds.size.width - 20;
        textViewFrame.size.height = 100;
    }
	self.textView = [[[UITextView alloc] initWithFrame:textViewFrame] autorelease];
    //self.textView = [[[UITextView alloc] initWithFrame:self.view.bounds] autorelease];
	textView.delegate = self;
    textView.layer.borderColor = [UIColor blackColor].CGColor;
    textView.layer.borderWidth = 1.0f;
	textView.font = [UIFont systemFontOfSize:15];
	textView.contentInset = UIEdgeInsetsMake(5,5,5,0);
	textView.backgroundColor = [UIColor whiteColor];
	//textView.autoresizesSubviews = YES;
	textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	
	[self.view addSubview:textView];
    
    CGRect imageViewFrame = CGRectZero;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        imageViewFrame.origin.x = 20;
        imageViewFrame.origin.y = 250;
        imageViewFrame.size.width = self.view.bounds.size.width - 40;
        imageViewFrame.size.height = 728;
    }
    else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        imageViewFrame.origin.x = 10;
        imageViewFrame.origin.y = 120;
        imageViewFrame.size.width = self.view.bounds.size.width - 20;
        imageViewFrame.size.height = 300;
    }
    self.imageView = [[[UIImageView alloc] initWithFrame:imageViewFrame] autorelease];
    self.imageView.layer.borderColor = [UIColor grayColor].CGColor;
    self.imageView.layer.borderWidth = 1.0f;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	// save to set the text now
	textView.text = shareText;
	self.imageView.image = image;
	[self setupBarButtonItems];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];	
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
	
	[self.textView becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];	
	
	// Remove observers
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self name: UIKeyboardWillShowNotification object:nil];
	
	//If user really cancelled share. Sometimes sharers have more stages (e.g Foursquare) and user only returned to previous stage - back on navigation stack.
	if (self.shareIsCancelled) {
        
        if (![UIViewController instancesRespondToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
            // Remove the SHK view wrapper from the window
            [[SHK currentHelper] viewWasDismissed];
        }
    }
}

- (void)setupBarButtonItems {
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																														target:self
																														action:@selector(cancel)] autorelease];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:SHKLocalizedString(@"Send to %@", [[self.delegate class] sharerTitle]) 
																										style:UIBarButtonItemStyleDone
																									  target:self
																									  action:@selector(save)] autorelease];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	return YES;
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
- (void)keyboardWillShow:(NSNotification *)notification
{	
	CGRect keyboardFrame;
	CGFloat keyboardHeight;
	
	// 3.2 and above
	if (&UIKeyboardFrameEndUserInfoKey)
	{		
		[[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];		
		if ([self interfaceOrientation] == UIDeviceOrientationPortrait || [self interfaceOrientation] == UIDeviceOrientationPortraitUpsideDown) 
			keyboardHeight = keyboardFrame.size.height;
		else
			keyboardHeight = keyboardFrame.size.width;
	}
	
	// < 3.2
	else 
	{
		[[notification.userInfo valueForKey:UIKeyboardBoundsUserInfoKey] getValue:&keyboardFrame];
		keyboardHeight = keyboardFrame.size.height;
	}
	
	// Find the bottom of the screen (accounting for keyboard overlay)
	// This is pretty much only for pagesheet's on the iPad
	UIInterfaceOrientation orient = [[UIApplication sharedApplication] statusBarOrientation];
	BOOL inLandscape = orient == UIInterfaceOrientationLandscapeLeft || orient == UIInterfaceOrientationLandscapeRight;
	BOOL upsideDown = orient == UIInterfaceOrientationPortraitUpsideDown || orient == UIInterfaceOrientationLandscapeRight;
	
	CGPoint topOfViewPoint = [self.view convertPoint:CGPointZero toView:nil];
	CGFloat topOfView = inLandscape ? topOfViewPoint.x : topOfViewPoint.y;
	
	CGFloat screenHeight = inLandscape ? [[UIScreen mainScreen] applicationFrame].size.width : [[UIScreen mainScreen] applicationFrame].size.height;
	
	CGFloat distFromBottom = screenHeight - ((upsideDown ? screenHeight - topOfView : topOfView ) + self.view.bounds.size.height) + ([UIApplication sharedApplication].statusBarHidden || upsideDown ? 0 : 20);							
	CGFloat maxViewHeight = self.view.bounds.size.height - keyboardHeight + distFromBottom;
	
	//textView.frame = CGRectMake(0,0,self.view.bounds.size.width,maxViewHeight);
	
	[self layoutCounter];
}
#pragma GCC diagnostic pop

#pragma mark counter updates

- (void)updateCounter
{
	[self ifNoTextDisableSendButton];
	
	if (![self shouldShowCounter]) return;
	
	if (self.counter == nil)
	{
		UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		aLabel.backgroundColor = [UIColor clearColor];
		aLabel.opaque = NO;
		aLabel.font = [UIFont boldSystemFontOfSize:14];
		aLabel.textAlignment = UITextAlignmentRight;		
		aLabel.autoresizesSubviews = YES;
		aLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
		self.counter = aLabel;
		[aLabel release];
		
		[self.view addSubview:counter];
		[self layoutCounter];
	}
	
	NSString *count;
    NSInteger countNumber = 0;
    
    if (self.maxTextLength) {
        countNumber = (self.image?(self.maxTextLength - self.imageTextLength):self.maxTextLength) - self.textView.text.length;
        count = [NSString stringWithFormat:@"%i", countNumber];
    } else {
        count = @"";
    }
    
    if (self.image)
    {
        //counter.text = [NSString stringWithFormat:@"%@%@", [NSString stringWithFormat:@"Image %@ ",countNumber>0?@"+":@""], count];
    } else if (self.hasLink) {
        counter.text = [NSString stringWithFormat:@"%@%@", [NSString stringWithFormat:@"Link %@ ",countNumber>0?@"+":@""], count];
    } else {
        counter.text = count;
    }
 	
	if (countNumber >= 0) {
		
		self.counter.textColor = [UIColor blackColor];        
		if (self.textView.text.length) self.navigationItem.rightBarButtonItem.enabled = YES; 
		
	} else {
		
		self.counter.textColor = [UIColor redColor];
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}  
}

- (void)ifNoTextDisableSendButton {
	
	if (self.textView.text.length || self.allowSendingEmptyMessage) {
		self.navigationItem.rightBarButtonItem.enabled = YES; 
	} else {
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}
}

- (void)layoutCounter
{
	if (![self shouldShowCounter]) return;
	
	counter.frame = CGRectMake(self.view.bounds.size.width-150-15,
										self.view.bounds.size.height-15-9,
										150,
										15);
	//self.textView.contentInset = UIEdgeInsetsMake(5,5,32,0);
}

- (BOOL)shouldShowCounter {
	
	if (self.maxTextLength || self.image || self.hasLink) return YES;
	
	return NO;
}

#pragma mark UITextView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	[self updateCounter];
}

- (void)textViewDidChange:(UITextView *)textView
{
	[self updateCounter];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [self.textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	[self updateCounter];
}

#pragma mark delegate callbacks 

- (void)cancel
{	
	self.shareIsCancelled = YES;
    [[SHK currentHelper] hideCurrentViewControllerAnimated:YES];
	[self.delegate sendDidCancel];
}

- (void)save
{	    	
	[[SHK currentHelper] hideCurrentViewControllerAnimated:YES]; 
	[self.delegate sendForm:self];
}

@end

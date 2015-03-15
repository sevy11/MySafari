//
//  InternetViewController.m
//  MySafari
//
//  Created by Michael Sevy on 3/11/15.
//  Copyright (c) 2015 Michael Sevy. All rights reserved.
//

#import "InternetViewController.h"

@interface InternetViewController ()<UIWebViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;

@end

@implementation InternetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self goToURLString:@"http://www.reddit.com"];

    self.webView.delegate = self; //always set delegate to self

    self.webView.scrollView.delegate = self;
    self.webView.scrollView.scrollEnabled = TRUE;
    [[self.webView scrollView] setContentInset:UIEdgeInsetsMake(52, 0, 0, 0)];

    //self.webView.scrollView.scrollEnabled = YES;
    self.webView.scrollView.userInteractionEnabled = YES;


}

#pragma Loading Spinner
-(void)webViewDidStartLoad:(UIWebView *)webView {
    [self.spinner startAnimating];
}

#pragma mark Did Finish Loading Web Title, Spinner
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.spinner stopAnimating];

    NSString *websiteString = self.webView.request.URL.absoluteString;
    self.textField.text = websiteString;

    NSString *websiteTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = websiteTitle;

    //self.webView.scrollView.scrollEnabled = YES;
    //self.webView.scrollView.userInteractionEnabled = YES;
}

- (IBAction)onBackButtonPressed:(id)sender {
    if ([self.webView canGoBack] == YES) {
        [self.webView goBack];
    }else if ([self.webView canGoBack] == NO){
        self.backButton.enabled = NO;
    }
}

- (IBAction)onForwardButtonPressed:(id)sender {
    if([self.webView canGoForward] == YES){
        [self.webView goForward];
    }else if ([self.webView canGoForward] == NO) {
        self.forwardButton.enabled = NO;
    }
}




#pragma Helper Load URL String -- TextField http formatter
-(void)goToURLString:(NSString *)string {

        NSString *urlString = string;

    if ([urlString hasPrefix:@"http://"]) {
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];

    } else {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", urlString]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
}
#pragma URL Bar
-(BOOL)textFieldShouldReturn:(UITextField *)textField   {

    [self goToURLString:textField.text];

    [self.textField resignFirstResponder];

    return true;
}

- (IBAction)onStopLoadingPage:(id)sender {
    [self.webView stopLoading];
    }
- (IBAction)onReloadingPage:(id)sender {
    [self.webView reload];
}
#pragma Alert Action
- (IBAction)onNewFeatureButtonPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"New Features Coming Soon!"
                          message:@"Wait and See"
                          delegate:nil
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"OK", nil];
    [alert show];
}
#pragma Scroll methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect textFieldFrame = self.textField.frame;

    if (scrollView.contentOffset.y <= 100) {
        textFieldFrame.origin.y += 100;
        [UIView animateWithDuration:0.2 animations:^{
            self.textField.frame = textFieldFrame;
            [self.textField setAlpha:1.0];
            [self.textField layoutIfNeeded];
        }];
    } else if (scrollView.contentOffset.y >= 100) {
        textFieldFrame.origin.y -= 100;
        [UIView animateWithDuration:0.5 animations:^{
            self.textField.frame = textFieldFrame;
            [self.textField setAlpha:1.0];
        }];

    }

}

-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    [self.textField setHidden:NO];
}
@end

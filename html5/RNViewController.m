//
//  RNViewController.m
//  html5
//
//  Created by 玉平 孙 on 12-2-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RNViewController.h"
#import "RNUIDevice.h"

#define REFRESH_HEADER_HEIGHT 52.0f

@implementation RNViewController
-(void)dealloc{
    [super dealloc];
    [_mainwebview release];
    [_refrashHeaderView release];
    [refreshLabel release];
    [refreshArrow release];
    [refreshSpinner release];
    [backScrollView release];
}
-(void)creatrefreshview{
    _refrashHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    _refrashHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];//
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = UITextAlignmentCenter;
    refreshLabel.text = @"下拉刷新";
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 27) / 2,
                                    (REFRESH_HEADER_HEIGHT - 44) / 2,
                                    27, 44);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 20) / 2, (REFRESH_HEADER_HEIGHT - 20) / 2, 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [_refrashHeaderView addSubview:refreshLabel];
    [_refrashHeaderView addSubview:refreshArrow];
    [_refrashHeaderView addSubview:refreshSpinner];

    

}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    int view_w = self.view.bounds.size.width;
    int view_h = self.view.bounds.size.height -80;
    backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, view_w, view_h)];
    backScrollView.scrollEnabled = YES;
  //  backScrollView 
    [backScrollView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:backScrollView];
    
  //  [backScrollView setContentSize:CGSizeMake(view_w, 600)];
    
    _mainwebview = [[UIWebView alloc] initWithFrame:CGRectMake(5, 0, view_w-10, view_h)];
   // [backScrollView addSubview:_mainwebview];
    [backScrollView addSubview:_mainwebview];
    //缩放
   // _mainwebview.scalesPageToFit = YES;
    //自动调整大小
    _mainwebview.autoresizesSubviews = YES;
   // _mainwebview.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    
    _mainwebview.scrollView.delegate = self;
    
   // _mainwebview.scrollView.scrollEnabled = NO;
    _mainwebview.clipsToBounds = YES;
    
    _mainwebview.scrollView.decelerationRate = 0.13;
   
    [_mainwebview setOpaque:YES];
    
    [_mainwebview setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *idoubleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];   
    idoubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:idoubleTap];
    
  //  [_mainwebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mt.renren.com"]]]; //3g.sina.com.cn/3g/mil/?vt=3&pos=24
    NSString *path = [[NSBundle mainBundle] resourcePath];
    NSString *pathFile = [path stringByAppendingString:@"/listdemo.html"];//test1，

    NSString *htmlstr = [NSString stringWithContentsOfFile:pathFile encoding:NSUTF8StringEncoding error:nil];
    
    NSURL *baseurl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [_mainwebview loadHTMLString:htmlstr baseURL:baseurl];
  

    _javascriptBridge = [[RNWebViewJavascriptBridge javascriptBridgeWithDelegate:self] retain];
    _mainwebview.delegate = _javascriptBridge;
    
  //  NSLog(@"syp===pathFile=%@,pathFilejs=%@",pathFile,pathFilejs);
    UIButton *goback = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    goback.frame = CGRectMake(5, view_h+38, 100, 40);
    [goback setTitle:@"返回" forState:UIControlStateNormal];
    [goback addTarget:self action:@selector(webviewgoback) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:goback];
     
    UIButton *refrsh = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    refrsh.frame = CGRectMake(108, view_h+38, 100, 40);
    [refrsh setTitle:@"刷新" forState:UIControlStateNormal];
    [refrsh addTarget:self action:@selector(webviewrefrsh) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:refrsh];
 
    UIButton *scroll = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    scroll.frame = CGRectMake(210, view_h+38, 100, 40);
    [scroll setTitle:@"滚动开关" forState:UIControlStateNormal];
    [scroll addTarget:self action:@selector(webviewscroll) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:scroll];
    
    [self creatrefreshview];
    [_mainwebview addSubview:_refrashHeaderView];
      
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"syp==documentsDirectory=%@",documentsDirectory);
    
    
    // Example usage.
    NSArray * processes = [[UIDevice currentDevice] runningProcesses];
    for (NSDictionary * dict in processes){
        NSLog(@"%@ - %@", [dict objectForKey:@"ProcessID"], [dict objectForKey:@"ProcessName"]);
    }
    
     NSLog(@"syp===w=%f,h=%f",self.view.bounds.size.width,self.view.bounds.size.height);
    
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(captureAndMove:)];
    [_mainwebview addGestureRecognizer:_panGesture];
    
    
    
}
-(void ) doubleTap:(UITapGestureRecognizer*) sender {
    NSLog(@"syp===zhegshi shuangji   ");
}

-(void)webviewscroll{
    _mainwebview.scrollView.scrollEnabled = !_mainwebview.scrollView.scrollEnabled;
    NSString *currentHtml = [_mainwebview stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
    NSLog(@"currentHtml==%@",currentHtml);
    
    
   // [_mainwebview.scrollView setScrollEnabled:NO];
}
//scrollEnabled
-(void)webviewrefrsh{
  //  [_mainwebview reload];
   // NSString *currentresult = [_mainwebview stringByEvaluatingJavaScriptFromString:@"list.setScrollable(list.scroll)"];
   // NSLog(@"currentresult===%@",currentresult);310.535
    [_mainwebview stringByEvaluatingJavaScriptFromString:@"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function MyWebViewSize() { "
     "var size = '';"
     "var theHeight = document.body.scrollHeight;"
     "var thewidth = document.body.scrollWidth;"
     "size = thewidth+','+theHeight;"
     "alert(size);"
     "return size;"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"]; 
    
    NSString *size =  [_mainwebview stringByEvaluatingJavaScriptFromString:@"MyWebViewSize();"];
    NSLog(@"syp===size=%@",size);

}
-(void)webviewgoback{
 
    if ([_mainwebview canGoBack]) {
        [_mainwebview goBack];
    }

    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
// Notifies when rotation begins, reaches halfway point and ends.
//将开始旋转执行
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    NSLog(@"syp===w=%f,h=%f",self.view.bounds.size.width,self.view.bounds.size.height);
    
    
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {  
        
        _mainwebview.frame = CGRectMake(5, 0, 320-10,380);
        backScrollView.frame = CGRectMake(5, 0, 320-10, 380);
    }else {  
        _mainwebview.frame = CGRectMake(5, 0, 460-10,320); 
         backScrollView.frame = CGRectMake(5, 0, 460-10, 320);
        
    }  
    
     
    [_mainwebview reload];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLock* lock = [[NSLock alloc] init];
    [lock lock];
    NSString *requestString = [[request URL] absoluteString];
 //   NSLog(@"requestString==%@",requestString);
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"lg"]) {
       // NSLog(@"rnlog==%@",requestString);
        return NO;
    }
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"myweb"]) {
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"touch"]) 
        {
           // NSLog(@"%@",[components objectAtIndex:2]);
        }
        [lock unlock];
        [lock release];
        return NO;
    }
    [lock unlock];
    [lock release];
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"webViewDidStartLoad ");
    /*
    [_mainwebview stringByEvaluatingJavaScriptFromString:@"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function Op(o)"
    "{"
       " var x=y=0;"
       " do{"
           " x+=o.offsetLeft;"
           "y+=o.offsetTop;"
        "}"
        "while (o=o.offsetParent);"
        "return {\"x\":x,\"y\":y};"
    "}"
     
     "function addmyevent() {"
         "var childs = document.getElementsByTagName(\"DIV\");"
         "for(child in childs){"
             "child.style.onMouseDown = \"touchdiv(event)\""
         "}"
     "}"
     
    "function touchdiv(event){"
        "var divid;"
        "var int_x = window.pageXOffset;"
        "var int_y = window.pageYOffset;"
        "var int_displaywidth = window.outerWidth;"
        "var div_top = event.clientX;"
        "var div_left = event.clientY;"
        "var tagid = document.elementFromPoint(div_top,div_left);"
        "var tagname = tagid.tagName;"
        "while(1){"
            "if(tagid.tagName == \"DIV\"){"
                "divid = tagid;"
                "var div_x= Op(divid).x;"
                "var div_y= Op(divid).y;"
                "var div_w = divid.clientWidth;"
                "var div_h = divid.clientHeight;"
                "var child = document.createElement(\"div\");"
                
                "child.style.position=\"absolute\";"
                "child.style.top=div_y+\"px\";"
                "child.style.left=div_x+\"px\";"
                "child.style.width = div_w+\"px\";"
                "child.style.height = div_h+\"px\";"
                "child.style.backgroundColor = \"#ff0000\";"
                "document.body.appendChild(child);"
                "break;"
            "}"
            "tagid = tagid.parentElement;"
            "if(tagid == null){"
                "break;"
            "}"
        "}"
     "};"];

    */
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"webViewDidFinishLoad ");
    
    [_mainwebview stringByEvaluatingJavaScriptFromString:@"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function MyWebViewSize() { "
     "var size = '';"
     "var theHeight = document.body.scrollHeight;"
     "var thewidth = document.body.scrollWidth;"
     "size = theHeight;"
     "alert(size);"
     "return size;"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"]; 
    
    NSString *size =  [_mainwebview stringByEvaluatingJavaScriptFromString:@"addmyevent();"];
    NSLog(@"syp===size=%@",size);
  //   _mainwebview.frame = CGRectMake(5, 0, self.view.bounds.size.width-10, [size intValue]);
    
    CGSize actualSize = [_mainwebview sizeThatFits:CGSizeZero];
    
    CGRect newFrame = _mainwebview.frame;
    newFrame.size.height = actualSize.height;
    _mainwebview.frame = newFrame;
    [backScrollView setContentSize:CGSizeMake(self.view.bounds.size.width, actualSize.height)];
   // [_mainwebview stringByEvaluatingJavaScriptFromString:@"addmyevent();"];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"didFailLoadWithError ===error =%@",error);
}
//拖动效果
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
  //  NSLog(@"scrollViewWillBeginDragging===x=%@,y=%@",scrollView.contentOffset.x,scrollView.contentOffset.y);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  //   NSLog(@"scrollViewDidScroll===x=%f,y=%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    if(scrollView.contentOffset.y >0){
        
    }
    if (scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        CGRect frame;
        frame.origin.y = -REFRESH_HEADER_HEIGHT - scrollView.contentOffset.y;
        frame.origin.x = 0;
        frame.size.width = 320;
        frame.size.width = REFRESH_HEADER_HEIGHT;
        _refrashHeaderView.frame = frame;
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
            // User is scrolling above the header
            refreshLabel.text = @"松开刷新";
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else { // User is scrolling somewhere within the header
            refreshLabel.text = @"下拉刷新";
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
    if (scrollView.contentOffset.y > scrollView.contentSize.height) {
         ;
    }

}
- (void)startLoading {

    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    _mainwebview.scrollView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshLabel.text = @"正在加载。。。";
    refreshArrow.hidden = YES;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];
    
    // Refresh action!
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
   // [self refresh];
}
- (void)stopLoading {
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    _mainwebview.scrollView.contentInset = UIEdgeInsetsZero;
    [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    CGRect frame;
    frame.origin.y = -REFRESH_HEADER_HEIGHT;
    frame.origin.x = 0;
    frame.size.width = 320;
    frame.size.width = REFRESH_HEADER_HEIGHT;
    _refrashHeaderView.frame = frame;
    
    [UIView commitAnimations];
}
- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    refreshLabel.text = @"下拉刷新";
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
    
}
-(void)scroolspeed:(UIScrollView *)scrollView{
    while (1) {
        
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollViewWillBeginDecelerating");
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
     NSLog(@"scrollViewDidEndDragging===");
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}    
-(void)testTouchPoint{
    
    int  scrollPositionY  = [[_mainwebview  stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] intValue];   
    int  scrollPositionX  = [[_mainwebview stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"]intValue];    
    
    int  displayWidth  = [[_mainwebview stringByEvaluatingJavaScriptFromString:@"window.outerWidth"] intValue];   
    CGFloat  scale  =  _mainwebview.frame.size.width/displayWidth;   
    
    CGPoint  pt  = CGPointMake(0, 0);//[sender locationInView:_mainwebview];    
    pt.x *= scale;    
    pt.y *= scale;    
    pt.x += scrollPositionX;    
    
    pt.y += scrollPositionY;      
    NSString  * js  = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName",pt.x, pt.y];    
    NSString  *  tagName  = [_mainwebview stringByEvaluatingJavaScriptFromString:js];    
    if ([tagName isEqualToString:@"img"]) {    
        NSString * imgURL  = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];    
        NSString * urlToSave  = [_mainwebview stringByEvaluatingJavaScriptFromString:imgURL];    
        NSLog (@"image  url =%@",urlToSave);    
    }
}
-(NSArray*)getPoint:(CGPoint)pt{
    
    NSString * jspoint  = [NSString stringWithFormat:@"getDivPosition(%f,%f,%f)", pt.x, pt.y,_mainwebview.frame.size.width];
    NSString * result_str  = [_mainwebview stringByEvaluatingJavaScriptFromString:jspoint];
    NSArray *pointarr = [result_str componentsSeparatedByString:@","];
    return pointarr;
}

- (void)captureAndMove:(UIPanGestureRecognizer *) gestureRescongnizer{
    CGSize imageSize = _mainwebview.frame.size;
    if ([gestureRescongnizer state] == UIGestureRecognizerStateBegan) {
        _touchBegainPoint = [gestureRescongnizer locationInView:_mainwebview];
        NSArray *point = [self getPoint:_touchBegainPoint];
        
        if(UIGraphicsBeginImageContextWithOptions != NULL)
        {
            UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
        } else {
            UIGraphicsBeginImageContext(imageSize);
        }
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [_mainwebview.layer renderInContext:context];
        UIImage *webViewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        CGRect rect = CGRectMake(0,[[point objectAtIndex:1] floatValue], imageSize.width, 60);
        if (_screenShotOfWebView) {
            [_screenShotOfWebView removeFromSuperview];
            [_screenShotOfWebView release];
            _screenShotOfWebView = nil;
        }
        
        _screenShotBackImageView = [[UIImageView alloc] initWithFrame:rect];
        _screenShotBackImageView.backgroundColor = [UIColor colorWithRed:69.0 / 255.0 green:69.0 / 255.0 blue:69.0 / 255.0 alpha:1.0];
        [_mainwebview addSubview:_screenShotBackImageView];
        
        _screenShotOfWebView = [[UIImageView alloc] initWithFrame:rect];
        CGRect twoSizeRect = CGRectMake(0, rect.origin.y * 2, rect.size.width * 2, rect.size.height * 2);
        _screenShotOfWebView.image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([webViewImage CGImage], twoSizeRect)];
        [_mainwebview addSubview:_screenShotOfWebView];
    } else if ([gestureRescongnizer state] == UIGestureRecognizerStateChanged) {
        CGPoint touchPoint = [gestureRescongnizer locationInView:_mainwebview];
        if (_screenShotOfWebView) {
            _screenShotOfWebView.frame = CGRectMake(touchPoint.x - _touchBegainPoint.x, 
                                                    _screenShotOfWebView.frame.origin.y, 
                                                    _screenShotOfWebView.frame.size.width,
                                                    _screenShotOfWebView.frame.size.height);
        }
    } else if ([gestureRescongnizer state] == UIGestureRecognizerStateEnded) {
        if (_screenShotOfWebView) {
            [_screenShotBackImageView removeFromSuperview];
            [_screenShotBackImageView release];
            _screenShotBackImageView = nil;
            
            [_screenShotOfWebView removeFromSuperview];
            [_screenShotOfWebView release];
            _screenShotOfWebView = nil;
            
        }
    }
}


@end

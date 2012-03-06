//
//  RNViewController.h
//  html5
//
//  Created by 玉平 孙 on 12-2-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNWebViewJavascriptBridge.h"
@interface RNViewController : UIViewController<UIWebViewDelegate,WebViewJavascriptBridgeDelegate,UIScrollViewDelegate>{
    UIWebView *_mainwebview;
    UIScrollView *backScrollView;
    RNWebViewJavascriptBridge *_javascriptBridge;
    UIView *_refrashHeaderView;
    UILabel *refreshLabel ;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
}
//@property (strong, nonatomic)
@end

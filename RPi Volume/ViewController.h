//
//  ViewController.h
//  RPi Volume
//
//  Created by Shankar Rao on 6/20/16.
//  Copyright © 2016 Shankar Rao. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ViewController : NSViewController{
    int val;
}

@property (weak) IBOutlet NSSlider *slider;
@property (weak) IBOutlet NSTextField *iplabel;
@property NSString *remote_ip_address;
@property (weak) IBOutlet NSTextField *connected;
@property (weak) IBOutlet NSTextField *disconnected;



@end


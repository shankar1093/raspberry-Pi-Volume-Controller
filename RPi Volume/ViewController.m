//
//  ViewController.m
//  RPi Volume
//
//  Created by Shankar Rao on 6/20/16.
//  Copyright © 2016 Shankar Rao. All rights reserved.
//

#import "ViewController.h"
#import <NMSSH/NMSSH.h>


@implementation ViewController
- (IBAction)ipAddress:(NSTextField *)sender {
}

NMSSHSession *session;

- (IBAction)Connect:(NSButton *)sender {
    NSString *ipaddress = [NSString stringWithString:self.iplabel.stringValue];
    NMSSHSession *session = [NMSSHSession connectToHost:ipaddress
                                           withUsername:@"pi"];
    
    if (session.isConnected){
        [session authenticateByPassword:@"raspberry"];
        
        if (session.isAuthorized){
            NSLog(@"Authentication succeeded");
        }
    }
    [session disconnect];

}


- (void) volumeController:(int)val{
    
    NSString *ipaddress = [NSString stringWithString:self.remote_ip_address];
    NMSSHSession *session = [NMSSHSession connectToHost:ipaddress
                                           withUsername:@"pi"];
    
    if (session.isConnected){
        [session authenticateByPassword:@"raspberry"];
        
        if (session.isAuthorized){
            NSLog(@"Authentication succeeded");
        }
    }
    NSLog(@"Stuff:@",_remote_ip_address);
    NSError *error = nil;
    NSString *temp = @"pactl set-sink-volume 0 ";
    NSString *val_s = [NSString stringWithFormat:@"%d", val];
    NSString *val_sp = [val_s stringByAppendingString:@"%"];
    NSLog(@"pactl stuff: %@",val_sp);
    NSString *stmt = [temp stringByAppendingString:val_sp];
    NSString *response = [session.channel execute:stmt error:&error];
    
    
    [session disconnect];
}

- (IBAction)volume:(id)sender {
    int sliderValue = self.slider.intValue;
    val = sliderValue;
    [self volumeController:val];
    NSLog(@"slide val %d", val);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    int pid = [[NSProcessInfo processInfo] processIdentifier];
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *file = pipe.fileHandleForReading;
    
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/usr/sbin/arp";
    task.arguments = @[@"-a"];
    task.standardOutput = pipe;
    
    [task launch];
    
    NSData *data = [file readDataToEndOfFile];
    [file closeFile];
    
    NSString *grepOutput = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    NSArray *wordsAndEmptyStrings = [grepOutput componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSArray *words = [wordsAndEmptyStrings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length>0"]];
    
    NSUInteger indexOfTheObject = [words indexOfObject:@"[ethernet]\nraspberrypi.home"];
    NSString *ip_address_pre_edit = [words[indexOfTheObject+1] stringByReplacingOccurrencesOfString:@"(" withString:@""];
    NSString *raspberry_pi_ip_address = [ip_address_pre_edit stringByReplacingOccurrencesOfString:@")" withString:@""];
    self.remote_ip_address=raspberry_pi_ip_address;
    NSLog (@"arp returned:\n%@",_remote_ip_address);
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end

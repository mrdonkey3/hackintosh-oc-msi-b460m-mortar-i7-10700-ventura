//
//  AppDelegate.h
//  FixEDID
//
//  Created by Andy Vandijck on 23/06/13.
//  Copyright (c) 2013 Andy Vandijck. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <stdlib.h>
#import <unistd.h>

int CalcGCD(int a, int b);

typedef struct EDIDStruct {
    char Header[8];
    char Serial[10];
    char Version[2];
    char BasicParams[5];
    char Chroma[10];
    char Established[3];
    char Standard[16];
    char Descriptor1[18];
    char Descriptor2[18];
    char Descriptor3[18];
    char Descriptor4[18];
    char Extensions;
    char Checksum;
} EDIDStruct_t;

@interface AppDelegate : NSObject
{
    IBOutlet NSWindow *window;

    IBOutlet NSTextField *ScreenCount;
    IBOutlet NSTextField *VendorID;
    IBOutlet NSTextField *VendorDecID;
    IBOutlet NSTextField *DeviceID;
    IBOutlet NSTextField *DeviceDecID;
    IBOutlet NSTextField *EDIDPath;
    IBOutlet NSTextField *DisplayPrefsKey;
    IBOutlet NSTextField *VersionString;
    IBOutlet NSTextField *ResolutionCount;
    IBOutlet NSTextField *ResolutionHorizontal;
    IBOutlet NSTextField *ResolutionVertical;
    IBOutlet NSTextField *AspectRatio;

    IBOutlet NSButton *IgnoreDisplayPrefsButton;
    IBOutlet NSButton *FixMonitorRangesButton;
    
    IBOutlet NSPopUpButton *DisplayClassButton;
    IBOutlet NSPopUpButton *OverrideClassButton;
    IBOutlet NSPopUpButton *Displays;

    IBOutlet NSTableView *ResTable;
    
    IBOutlet NSArrayController *arrayController;

    NSOpenPanel *EDIDPanel;

    NSMutableArray *ResDataArray;

    BOOL EDIDFileOpened;
    BOOL IgnoreDisplayPrefs;

    char *EDIDRawData;
    char PanelSelected;
    
    unsigned char ResDataEntry[16];

    EDIDStruct_t *EDIDStructure;

    int EDIDSize;
    int panelresult;
    int displayclass;
    int ResCnt;

    NSNumber *VendorNumber;
    NSNumber *DeviceNumber;

    NSInteger IgnoreDisplayPrefsInteger;
    NSInteger FixMonitorRangesInteger;

    NSData *EDIDData;

    NSString *DesktopPath;
    NSString *NewEDIDPath;
    NSString *NewDisplayOverridePath;
    NSString *NewDisplayDriverPath;
    NSString *DriverBinPath;
    NSString *DriverBinResPath;
    NSString *DriverBinCSPath;
    NSString *DriverBinCSTarget;
    NSString *TotalNumberDisplays;
    NSString *displayclassoverride;
    NSString *ScreenNrString;
    NSString* outStr;
    NSString *tmp;
    NSString *devId;
    NSString *venId;
    NSString *displayPref;
    NSString *devDecId;
    NSString *venDecId;

    NSDictionary *DriverDict;
    NSDictionary *IOProviderMergeProperties;
    NSDictionary *IOKitPersonalities;
    NSDictionary *MonInjection;
    NSDictionary *OSBundleLibraries;
    NSDictionary *EDIDOverride;

    NSMutableDictionary *displayInfo;

    NSMutableArray *displayArray;
    
    NSArray *temparray;

    NSTask *task;

    NSPipe *pipe;

    FILE *file;
}

-(IBAction)GetScreenVendorDevice:(id)sender;
-(IBAction)OpenEDIDFile:(id)sender;
-(IBAction)SelectDisplay:(id)sender;

-(IBAction)SetRawEDID:(id)sender;
-(IBAction)SetColorPatchedEDID:(id)sender;
-(IBAction)SetiMac:(id)sender;
-(IBAction)SetMacbookPro:(id)sender;
-(IBAction)SetCinemaHD:(id)sender;
-(IBAction)SetThunderbolt:(id)sender;
-(IBAction)SetLEDCinema:(id)sender;
-(IBAction)SetRetinaiMac:(id)sender;
-(IBAction)SetMacbookAir:(id)sender;

-(IBAction)SetAppleDisplay:(id)sender;
-(IBAction)SetAppleBacklightDisplay:(id)sender;
-(IBAction)SetOverrideAppleDisplay:(id)sender;
-(IBAction)SetOverrideAppleBacklightDisplay:(id)sender;

-(IBAction)AddResolution:(id)sender;
-(IBAction)DelResolution:(id)sender;
-(IBAction)showHelp:(id)sender;

-(IBAction)MakeFiles:(id)sender;

-(int)hex2int:(const char *)s;
-(int)CalcGCD:(int)a vert:(int)b;

-(void)FixRanges;
-(void)DetermineAspectRatio;

-(unsigned char)make_checksum:(unsigned char *)x;
-(unsigned char)ScanForNameDescriptor:(unsigned char *)Descriptor;
-(unsigned char)ScanForRangeDescriptor:(unsigned char *)Descriptor;
-(unsigned char)ScanForSerialDescriptor:(unsigned char *)Descriptor;
-(unsigned char)ScanForOtherDescriptor:(unsigned char *)Descriptor;
-(unsigned char)ScanForDetailedDescriptor:(unsigned char *)Descriptor;
@end

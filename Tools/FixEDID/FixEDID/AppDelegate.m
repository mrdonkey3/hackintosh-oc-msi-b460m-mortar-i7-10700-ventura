//
//  AppDelegate.m
//  FixEDID
//
//  Created by Andy Vandijck on 23/06/13.
//  Copyright (c) 2013 Andy Vandijck. All rights reserved.
//

#import "AppDelegate.h"
#import "Vers.h"

@implementation AppDelegate

/* Needed to check the EDID header */
const char EDID_Header[8] = { 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00 };

/* Version override - fixes some issues */
const char Version_1_4[2] = { 0x01, 0x04 };

/* Monitor Ranges override - fixes some issues */
const char monitor_ranges_descriptor[18] = { 0x00, 0x00, 0x00, 0xfd, 0x00, 0x38, 0x4c, 0x1e, 0x53, 0x11, 0x00, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20 };

/* Apple iMac Display fixes */
const char *iMac_DPCAP = "model(iMac Cello) vcp(10 8D B6 C8 C9 DF) ver(2.2)";
const char iMac_BaseParms[5] = { 0xb5, 0x30, 0x1b, 0x78, 0x22 };
const char iMac_CFlags[4] = { 0x84, 0x49, 0x00, 0x00 };
const char iMac_CTRL_FL[4] = { 0x01, 0x00, 0x00, 0x00 };
const char iMac_MCSS[4] = { 0x00, 0x02, 0x02, 0x00 };
const char iMac_TechT[4] = { 0xff, 0xff, 0x02, 0x03 };
const char iMac_serial[10] = { 0x06, 0x10, 0x12, 0xa0, 0x00, 0x00, 0x00, 0x00, 0x1c, 0x16 };
const char iMac_chroma[10] = { 0x6f, 0xb1, 0xa7, 0x55, 0x4c, 0x9e, 0x25, 0x0c, 0x50, 0x54 };
const char iMac_descriptor[18] = { 0x00, 0x00, 0x00, 0xfc, 0x00, 0x69, 0x4d, 0x61, 0x63, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20 };
int iMacVendor = 1552;
int iMacDevice = 40978;

/* Apple iMac Retina Display fixes */
const char *iMacRetina_DPCAP = "(prot(backlight) type(led) model(iMac) vcp(02 10 52 8D C8 C9 DE DF FC FD FE) mccs_ver(2.2))";
const char iMacRetina_BaseParms[5] = { 0xb5, 0x30, 0x1b, 0x78, 0x22 };
const char iMacRetina_CFlags[4] = { 0x84, 0x49, 0x00, 0x00 };
const char iMacRetina_CTRL[4] = { 0x02, 0x04, 0x11, 0xff };
const char iMacRetina_FL[4] = { 0x00, 0x00, 0x02, 0x04 };
const char iMacRetina_MCSS[4] = { 0x00, 0x02, 0x02, 0x00 };
const char iMacRetina_serial[10] = { 0x06, 0x10, 0x05, 0xb0, 0x00, 0x00, 0x00, 0x00, 0x1c, 0x16 };
const char iMacRetina_chroma[10] = { 0x6f, 0xb1, 0xa7, 0x55, 0x4c, 0x9e, 0x25, 0x0c, 0x50, 0x54 };
const char iMacRetina_descriptor[18] = { 0x00, 0x00, 0x00, 0xfc, 0x00, 0x69, 0x4d, 0x61, 0x63, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20 };
int iMacRetinaVendor = 1552;
int iMacRetinaDevice = 45061;

/* Apple MacBook Pro Display fixes */
const char MBP_BaseParms[5] = { 0xa5, 0x1d, 0x12, 0x78, 0x02 };
const char MBP_CFLAGS[4] = { 0x00, 0x08, 0x00, 0x00 };
const char MBP_serial[10] = { 0x06, 0x10, 0x14, 0xa0, 0x00, 0x00, 0x00, 0x00, 0x0a, 0x16 };
const char MBP_chroma[10] = { 0x6f, 0xb1, 0xa7, 0x55, 0x4c, 0x9e, 0x25, 0x0c, 0x50, 0x54 };
const char MBP_descriptor[18] = { 0x00, 0x00, 0x00, 0xfc, 0x00, 0x43, 0x6f, 0x6c, 0x6f, 0x72, 0x20, 0x4c, 0x43, 0x44, 0x0a, 0x20, 0x20, 0x20 };
int MBPVendor = 1552;
int MBPDevice = 40980;

/* Apple MacBook Air Display fixes */
const char MBA_BaseParms[5] = { 0x95, 0x1a, 0x0e, 0x78, 0x02 };
const char MBA_CFLAGS[4] = { 0x00, 0x08, 0x00, 0x00 };
const char MBA_serial[10] = { 0x06, 0x10, 0xf2, 0x9c, 0x00, 0x00, 0x00, 0x00, 0x1a, 0x15 };
const char MBA_chroma[10] = { 0xef, 0x05, 0x97, 0x57, 0x54, 0x92, 0x27, 0x22, 0x50, 0x54 };
const char MBA_descriptor[18] = { 0x00, 0x00, 0x00, 0xfc, 0x00, 0x43, 0x6f, 0x6c, 0x6f, 0x72, 0x20, 0x4c, 0x43, 0x44, 0x0a, 0x20, 0x20, 0x20 };
int MBAVendor = 1552;
int MBADevice = 40178;

/* Apple Cinema HD Display fixes */
const char CHD_BaseParms[5] = { 0x80, 0x40, 0x28, 0x78, 0x2A };
const char CHD_CFLAGS[4] = { 0xc4, 0x41, 0x00, 0x00 };
const char CHD_serial[10] = { 0x06, 0x10, 0x32, 0x92, 0x7c, 0x9f, 0x00, 0x02, 0x2a, 0x10 };
const char CHD_chroma[10] = { 0xfe, 0x87, 0xa3, 0x57, 0x4a, 0x9c, 0x25, 0x13, 0x50, 0x54 };
const char CHD_name_descriptor[18] = { 0x00, 0x00, 0x00, 0xfc, 0x00, 0x43, 0x69, 0x6e, 0x65, 0x6d, 0x61, 0x20, 0x48, 0x44, 0x0a, 0x00, 0x00, 0x00 };
const char CHD_serial_descriptor[18] = { 0x00, 0x00, 0x00, 0xff, 0x00, 0x43, 0x59, 0x36, 0x34, 0x32, 0x30, 0x5a, 0x36, 0x55, 0x47, 0x31, 0x0a, 0x00 };
int CHDVendor = 1552;
int CHDDevice = 37426;

/* Apple Thunderbolt Display fixes */
const char *TDB_DPCAP = "prot(monitor) type(LCD) model(Thunderbolt Display) cmds(01 02 03 E3 F3) VCP(02 05 10 52 62 66 8D 93 B6 C0 C8 C9 CA D6(01 02 03 04) DF E9 EB ED FD) mccs_ver(2.2)";
const char TDB_BaseParms[5] = { 0xb5, 0x3c, 0x22, 0x78, 0x22 };
const char TDB_CFLAGS[4] = { 0x00, 0x00, 0x00, 0x00 };
const char TDB_CTRL[4] = { 0x00, 0x00, 0x00, 0xff };
const char TDB_FL[4] = { 0xff, 0xff, 0x01, 0x38 };
const char TDB_MCSS[4] = { 0x00, 0x02, 0x02, 0x00 };
const char TDB_TechT[4] = { 0x00, 0xff, 0x02, 0x03 };
const char TDB_serial[10] = { 0x06, 0x10, 0x27, 0x92, 0x1f, 0x00, 0x23, 0x16, 0x23, 0x16 };
const char TDB_chroma[10] = { 0x6f, 0xb1, 0xa7, 0x55, 0x4c, 0x9e, 0x25, 0x0c, 0x50, 0x54 };
const char TDB_name_descriptor[18] = { 0x00, 0x00, 0x00, 0xfc, 0x00, 0x54, 0x68, 0x75, 0x6e, 0x64, 0x65, 0x72, 0x62, 0x6f, 0x6c, 0x74, 0x0a, 0x20 };
const char TDB_serial_descriptor[18] = { 0x00, 0x00, 0x00, 0xff, 0x00, 0x43, 0x30, 0x32, 0x4a, 0x39, 0x30, 0x30, 0x58, 0x46, 0x32, 0x47, 0x43, 0x0a };
int TDBVendor = 1552;
int TDBDevice = 37415;

/* Apple LED Cinema Display fixes */
const char LED_BaseParms[5] = { 0xa5, 0x34, 0x20, 0x78, 0x26 };
const char LED_CFLAGS[4] = { 0x84, 0x41, 0x00, 0x00 };
const char LED_serial[10] = { 0x06, 0x10, 0x36, 0x92, 0x00, 0x22, 0x0d, 0x02, 0x03, 0x13 };
const char LED_chroma[10] = { 0x6e, 0xa1, 0xa7, 0x55, 0x4c, 0x9d, 0x25, 0x0e, 0x50, 0x54 };
const char LED_name_descriptor[18] = { 0x00, 0x00, 0x00, 0xfc, 0x00, 0x4c, 0x45, 0x44, 0x20, 0x43, 0x69, 0x6e, 0x65, 0x6d, 0x61, 0x0a, 0x20, 0x20 };
const char LED_serial_descriptor[18] = { 0x00, 0x00, 0x00, 0xff, 0x00, 0x32, 0x41, 0x39, 0x30, 0x33, 0x34, 0x31, 0x5a, 0x30, 0x4b, 0x30, 0x0a, 0x20 };
int LEDVendor = 1552;
int LEDDevice = 37430;

-(void)showHelp:(id)sender
{
    NSString *helpHTMLPatch = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"FixEDID.help"] stringByAppendingPathComponent:@"index.html"];
    char HelpOpenCmd[512];

    snprintf(HelpOpenCmd, sizeof(HelpOpenCmd), "/usr/bin/open \"%s\"", [helpHTMLPatch cStringUsingEncoding:NSUTF8StringEncoding]);

    system(HelpOpenCmd);
}

-(int)CalcGCD:(int)a vert:(int)b
{
    return ((b == 0) ? a : [self CalcGCD:b vert:(a % b)]);
}

- (void)DetermineAspectRatio
{
    unsigned char *descriptor = NULL;
    int hres = 0;
    int vres = 0;
    int gcd = 0;

    if ([self ScanForDetailedDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 1)
    {
        descriptor = (unsigned char *)EDIDStructure->Descriptor1;
    } else if ([self ScanForDetailedDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 1)
    {
        descriptor = (unsigned char *)EDIDStructure->Descriptor2;
    } else if ([self ScanForDetailedDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 1)
    {
        descriptor = (unsigned char *)EDIDStructure->Descriptor3;
    } else if ([self ScanForDetailedDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 1)
    {
        descriptor = (unsigned char *)EDIDStructure->Descriptor4;
    } else {
        [AspectRatio setStringValue:@"Ratio N/A"];

        return;
    }

    hres = (descriptor[2] + ((descriptor[4] & 0xF0) << 4));
    vres = (descriptor[5] + ((descriptor[7] & 0xF0) << 4));

    gcd = [self CalcGCD:hres vert:vres];

    [AspectRatio setStringValue:[NSString stringWithFormat:@"%d:%d", (hres / gcd), (vres / gcd)]];
}

- (void)DelResolution:(id)sender
{
    int selection = (int)[ResTable selectedRow];

    if ((ResCnt == 0) || (selection == -1))
    {
        return;
    }

    [ResDataArray removeObjectAtIndex:selection];
    [arrayController removeObjectAtArrangedObjectIndex:selection];
    [ResTable reloadData];

    --ResCnt;

    [ResolutionCount setStringValue:[NSString stringWithFormat:@"%u Resolutions", (unsigned int)ResCnt]];
}

- (void)AddResolution:(id)sender
{
    unsigned int horiz = 0;
    unsigned int vert = 0;
    NSData *tempData = nil;
    
    if (([ResolutionVertical stringValue] == nil) || ([ResolutionHorizontal stringValue] == nil))
        return;

    horiz = atoi([[ResolutionHorizontal stringValue] cStringUsingEncoding:NSUTF8StringEncoding]);
    vert = atoi([[ResolutionVertical stringValue] cStringUsingEncoding:NSUTF8StringEncoding]);

    ResDataEntry[0] = (horiz & 0xFF000000) >> 24;
    ResDataEntry[1] = (horiz & 0x00FF0000) >> 16;
    ResDataEntry[2] = (horiz & 0x0000FF00) >> 8;
    ResDataEntry[3] = horiz & 0x000000FF;

    ResDataEntry[4] = (vert & 0xFF000000) >> 24;
    ResDataEntry[5] = (vert & 0x00FF0000) >> 16;
    ResDataEntry[6] = (vert & 0x0000FF00) >> 8;
    ResDataEntry[7] = vert & 0x000000FF;

    ResDataEntry[8] = 0x00;
    ResDataEntry[9] = 0x00;
    ResDataEntry[10] = 0x00;
    ResDataEntry[11] = 0x01;

    ResDataEntry[12] = 0x00;
    ResDataEntry[13] = 0x20;
    ResDataEntry[14] = 0x00;
    ResDataEntry[15] = 0x00;

    tempData = [[NSData alloc] initWithBytes:ResDataEntry length:sizeof(ResDataEntry)];
    [ResDataArray addObject:tempData];

    ++ResCnt;

    [ResolutionCount setStringValue:[NSString stringWithFormat:@"%u Resolutions", (unsigned int)ResCnt]];

    [arrayController addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%u x %u", horiz, vert],@"Res",nil]];
    
    [ResTable reloadData];
}

- (void)dealloc
{
    free(EDIDRawData);

    if (file)
    {
        fclose(file);
    }

    [ResDataArray release];

    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    EDIDFileOpened = NO;
    PanelSelected = 1;
    displayclass = 1;
    ResDataArray = [[NSMutableArray alloc] init];

    [self GetScreenVendorDevice:self];

    [VersionString setStringValue:[[NSString alloc] initWithFormat:@"FixEDID V%4.2f", FixEDIDVersionNumber]];

    [ResolutionCount setStringValue:[NSString stringWithFormat:@"%u Resolutions", (unsigned int)ResCnt]];
}

-(int)hex2int:(const char *)s
{
    char *charset = "0123456789abcdef";
    int i = (int)strlen(s), len = i, num = 0, j = 0;
    while (i >= 0) {
        for (j = 0; j < 16; j++) {
            if (charset[j] == s[i]) {
                num += j * (int)pow(16, len-i-1);
                break;
            }
        }
        i--;
    }
    return (num);
}

-(void)FixRanges
{
    BOOL DescriptorSet = NO;

    if ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 1)
    {
        memcpy(EDIDStructure->Descriptor1, monitor_ranges_descriptor, sizeof(monitor_ranges_descriptor));
        DescriptorSet = YES;
    }
    
    if (([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 1) && (DescriptorSet == NO))
    {
        memcpy(EDIDStructure->Descriptor2, monitor_ranges_descriptor, sizeof(monitor_ranges_descriptor));
        DescriptorSet = YES;
    }
    
    if (([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 1) && (DescriptorSet == NO))
    {
        memcpy(EDIDStructure->Descriptor3, monitor_ranges_descriptor, sizeof(monitor_ranges_descriptor));
        DescriptorSet = YES;
    }
    
    if (([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 1) && (DescriptorSet == NO))
    {
        memcpy(EDIDStructure->Descriptor4, monitor_ranges_descriptor, sizeof(monitor_ranges_descriptor));
        DescriptorSet = YES;
    }
    
    
    if ([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 1)
    {
        memcpy(EDIDStructure->Descriptor1, monitor_ranges_descriptor, sizeof(monitor_ranges_descriptor));
        DescriptorSet = YES;
    }
    
    if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 1) && (DescriptorSet == NO))
    {
        memcpy(EDIDStructure->Descriptor2, monitor_ranges_descriptor, sizeof(monitor_ranges_descriptor));
        DescriptorSet = YES;
    }
    
    if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 1) && (DescriptorSet == NO))
    {
        memcpy(EDIDStructure->Descriptor3, monitor_ranges_descriptor, sizeof(monitor_ranges_descriptor));
        DescriptorSet = YES;
    }
    
    if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 1) && (DescriptorSet == NO))
    {
        memcpy(EDIDStructure->Descriptor4, monitor_ranges_descriptor, sizeof(monitor_ranges_descriptor));
        DescriptorSet = YES;
    }
    
    if (DescriptorSet == NO)
    {
        if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
            ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
            ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
            (DescriptorSet == NO))
        {
            memcpy(EDIDStructure->Descriptor4, monitor_ranges_descriptor, sizeof(monitor_ranges_descriptor));
            DescriptorSet = YES;
        }
        
        if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
            ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
            ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
            (DescriptorSet == NO))
        {
            memcpy(EDIDStructure->Descriptor3, monitor_ranges_descriptor, sizeof(monitor_ranges_descriptor));
            DescriptorSet = YES;
        }
        
        if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
            ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
            ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
            (DescriptorSet == NO))
        {
            memcpy(EDIDStructure->Descriptor2, monitor_ranges_descriptor, sizeof(monitor_ranges_descriptor));
            DescriptorSet = YES;
        }
        
        if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
            ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
            ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
            (DescriptorSet == NO))
        {
            memcpy(EDIDStructure->Descriptor1, monitor_ranges_descriptor, sizeof(monitor_ranges_descriptor));
            DescriptorSet = YES;
        }
    }
}

-(unsigned char)make_checksum:(unsigned char *)x
{
    unsigned char sum = 0;
    int i = 0;

    for (i = 0; i < 127; i++)
       sum += x[i];

    return((unsigned char)((((unsigned short)0x100) - sum) & 0xFF));
}

-(unsigned char)ScanForNameDescriptor:(unsigned char *)Descriptor
{
    if ((Descriptor[0] == 0) && (Descriptor[1] == 0) && (Descriptor[2] == 0) && (Descriptor[3] == 0xFC))
    {
        return(1);
    }

    return(0);
}

-(unsigned char)ScanForRangeDescriptor:(unsigned char *)Descriptor
{
    if ((Descriptor[0] == 0) && (Descriptor[1] == 0) && (Descriptor[2] == 0) && (Descriptor[3] == 0xFD))
    {
        return(1);
    }
    
    return(0);
}

-(unsigned char)ScanForSerialDescriptor:(unsigned char *)Descriptor
{
    if ((Descriptor[0] == 0) && (Descriptor[1] == 0) && (Descriptor[2] == 0) && (Descriptor[3] == 0xFF))
    {
        return(1);
    }
    
    return(0);
}

-(unsigned char)ScanForOtherDescriptor:(unsigned char *)Descriptor
{
    if ((Descriptor[0] == 0) && (Descriptor[1] == 0) && (Descriptor[2] == 0))
    {
        switch(Descriptor[3])
        {
            case 0x00:
            case 0x01:
            case 0x02:
            case 0x03:
            case 0x04:
            case 0x05:
            case 0x06:
            case 0x07:
            case 0x08:
            case 0x09:
            case 0x0A:
            case 0x0B:
            case 0x0C:
            case 0x0D:
            case 0x0E:
            case 0x0F:
            case 0x10:
            case 0xF7:
            case 0xF8:
            case 0xF9:
            case 0xFA:
            case 0xFB:
            case 0xFE:
                return(1);	
                break;

            case 0xFC: /* Don't override set name */
            case 0xFD: /* XXX: Probably don't want to override monitor ranges... */
            case 0xFF: /* XXX: Probably don't want to override serial number... */
                return(0);
        }
    }

    return(0);
}

-(unsigned char)ScanForDetailedDescriptor:(unsigned char *)Descriptor
{
    if ((Descriptor[0] == 0) && (Descriptor[1] == 0) && (Descriptor[2] == 0))
    {
        switch(Descriptor[3])
        {
            case 0x00:
            case 0x01:
            case 0x02:
            case 0x03:
            case 0x04:
            case 0x05:
            case 0x06:
            case 0x07:
            case 0x08:
            case 0x09:
            case 0x0A:
            case 0x0B:
            case 0x0C:
            case 0x0D:
            case 0x0E:
            case 0x0F:
            case 0x10:
            case 0xF7:
            case 0xF8:
            case 0xF9:
            case 0xFA:
            case 0xFB:
            case 0xFE:
            case 0xFC:
            case 0xFD:
            case 0xFF:
                return(0);
                break;
        }
    }
    
    return(1);
}

-(void)MakeFiles:(id)sender
{
    BOOL DescriptorSet = NO;
    char CopyPath[512];
    char CopyCSPath[512];
#if MAC_OS_X_VERSION_MIN_REQUIRED >= 1050
    NSError *err;
    NSAlert *alert;
    NSString *errorstring;
#endif

    if (EDIDFileOpened == NO)
    {
        NSRunAlertPanel(@"Couldn't run!", @"Open an EDID file first!", @"OK", nil, nil);

        return;
    }

    switch(PanelSelected)
    {
        case 0:

            FixMonitorRangesInteger = [FixMonitorRangesButton state];

            if (FixMonitorRangesInteger == YES)
            {
                [self FixRanges];
            }
            
            EDIDStructure->Checksum = [self make_checksum:(unsigned char *)EDIDRawData];

            if (ResCnt > 0)
            {
                IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", ResDataArray, @"scale-resolutions", nil ];
            } else {
                IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", nil ];
            }

            DeviceNumber = [NSNumber numberWithInt:[DeviceDecID intValue]];
            VendorNumber = [NSNumber numberWithInt:[VendorDecID intValue]];
            
            break;

        case 1:
            memcpy(EDIDStructure->Serial, iMac_serial, sizeof(iMac_serial));
            memcpy(EDIDStructure->Chroma, iMac_chroma, sizeof(iMac_chroma));
            memcpy(EDIDStructure->BasicParams, iMac_BaseParms, sizeof(iMac_BaseParms));
            memcpy(EDIDStructure->Version, Version_1_4, sizeof(Version_1_4));

            if ([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 1)
            {
                memcpy(EDIDStructure->Descriptor1, iMac_descriptor, sizeof(iMac_descriptor));
                DescriptorSet = YES;
            }

            if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor2, iMac_descriptor, sizeof(iMac_descriptor));
                DescriptorSet = YES;
            }

            if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor3, iMac_descriptor, sizeof(iMac_descriptor));
                DescriptorSet = YES;
            }

            if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor4, iMac_descriptor, sizeof(iMac_descriptor));
                DescriptorSet = YES;
            }


            if ([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 1)
            {
                memcpy(EDIDStructure->Descriptor1, iMac_descriptor, sizeof(iMac_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor2, iMac_descriptor, sizeof(iMac_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor3, iMac_descriptor, sizeof(iMac_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor4, iMac_descriptor, sizeof(iMac_descriptor));
                DescriptorSet = YES;
            }

            if (DescriptorSet == NO)
            {
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor4, iMac_descriptor, sizeof(iMac_descriptor));
                    DescriptorSet = YES;
                }

                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor3, iMac_descriptor, sizeof(iMac_descriptor));
                    DescriptorSet = YES;
                }

                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor2, iMac_descriptor, sizeof(iMac_descriptor));
                    DescriptorSet = YES;
                }

                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor1, iMac_descriptor, sizeof(iMac_descriptor));
                    DescriptorSet = YES;
                }
            }

            FixMonitorRangesInteger = [FixMonitorRangesButton state];

            if (FixMonitorRangesInteger == YES)
            {
                [self FixRanges];
            }

            EDIDStructure->Checksum = [self make_checksum:(unsigned char *)EDIDRawData];

            DeviceNumber = [NSNumber numberWithInt:iMacDevice];
            VendorNumber = [NSNumber numberWithInt:iMacVendor];

            if (ResCnt > 0)
            {
                if (displayclass == 2)
                {
                    IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:iMacDevice], @"DisplayProductID", [NSNumber numberWithInt:iMacVendor], @"DisplayVendorID", [NSNumber numberWithInt:2], @"AppleDisplayType", [NSNumber numberWithInt:1854], @"AppleSense", [NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", [NSData dataWithBytes:iMac_DPCAP length:strlen(iMac_DPCAP)], @"IODisplayCapabilityString", [NSData dataWithBytes:iMac_CFlags length:sizeof(iMac_CFlags)], @"IODisplayConnectFlags", [NSData dataWithBytes:iMac_CTRL_FL length:sizeof(iMac_CTRL_FL)], @"IODisplayControllerID", [NSData dataWithBytes:iMac_CTRL_FL length:sizeof(iMac_CTRL_FL)], @"IODisplayFirmwareLevel", [NSData dataWithBytes:iMac_MCSS length:sizeof(iMac_MCSS)], @"IODisplayMCCSVersion", [NSData dataWithBytes:iMac_TechT length:sizeof(iMac_TechT)], @"IODisplayTechnologyType", [[[DisplayPrefsKey stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-610-a012", displayclassoverride]], @"IODisplayPrefsKey", displayclassoverride, @"IOClass", ResDataArray, @"scale-resolutions", nil ];
                } else {
                    IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:iMacDevice], @"DisplayProductID", [NSNumber numberWithInt:iMacVendor], @"DisplayVendorID", [NSNumber numberWithInt:2], @"AppleDisplayType", [NSNumber numberWithInt:1854], @"AppleSense", [NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", [NSData dataWithBytes:iMac_DPCAP length:strlen(iMac_DPCAP)], @"IODisplayCapabilityString", [NSData dataWithBytes:iMac_CFlags length:sizeof(iMac_CFlags)], @"IODisplayConnectFlags", [NSData dataWithBytes:iMac_CTRL_FL length:sizeof(iMac_CTRL_FL)], @"IODisplayControllerID", [NSData dataWithBytes:iMac_CTRL_FL length:sizeof(iMac_CTRL_FL)], @"IODisplayFirmwareLevel", [NSData dataWithBytes:iMac_MCSS length:sizeof(iMac_MCSS)], @"IODisplayMCCSVersion", [NSData dataWithBytes:iMac_TechT length:sizeof(iMac_TechT)], @"IODisplayTechnologyType", [[[DisplayPrefsKey stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-610-a012", displayclassoverride]], @"IODisplayPrefsKey", displayclassoverride, @"IOClass",  ResDataArray, @"scale-resolutions", nil ];
                }
            } else {
                if (displayclass == 2)
                {
                    IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:iMacDevice], @"DisplayProductID", [NSNumber numberWithInt:iMacVendor], @"DisplayVendorID", [NSNumber numberWithInt:2], @"AppleDisplayType", [NSNumber numberWithInt:1854], @"AppleSense", [NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", [NSData dataWithBytes:iMac_DPCAP length:strlen(iMac_DPCAP)], @"IODisplayCapabilityString", [NSData dataWithBytes:iMac_CFlags length:sizeof(iMac_CFlags)], @"IODisplayConnectFlags", [NSData dataWithBytes:iMac_CTRL_FL length:sizeof(iMac_CTRL_FL)], @"IODisplayControllerID", [NSData dataWithBytes:iMac_CTRL_FL length:sizeof(iMac_CTRL_FL)], @"IODisplayFirmwareLevel", [NSData dataWithBytes:iMac_MCSS length:sizeof(iMac_MCSS)], @"IODisplayMCCSVersion", [NSData dataWithBytes:iMac_TechT length:sizeof(iMac_TechT)], @"IODisplayTechnologyType", [[[DisplayPrefsKey stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-610-a012", displayclassoverride]], @"IODisplayPrefsKey", displayclassoverride, @"IOClass", nil ];
                } else {
                    IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:iMacDevice], @"DisplayProductID", [NSNumber numberWithInt:iMacVendor], @"DisplayVendorID", [NSNumber numberWithInt:2], @"AppleDisplayType", [NSNumber numberWithInt:1854], @"AppleSense", [NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", [NSData dataWithBytes:iMac_DPCAP length:strlen(iMac_DPCAP)], @"IODisplayCapabilityString", [NSData dataWithBytes:iMac_CFlags length:sizeof(iMac_CFlags)], @"IODisplayConnectFlags", [NSData dataWithBytes:iMac_CTRL_FL length:sizeof(iMac_CTRL_FL)], @"IODisplayControllerID", [NSData dataWithBytes:iMac_CTRL_FL length:sizeof(iMac_CTRL_FL)], @"IODisplayFirmwareLevel", [NSData dataWithBytes:iMac_MCSS length:sizeof(iMac_MCSS)], @"IODisplayMCCSVersion", [NSData dataWithBytes:iMac_TechT length:sizeof(iMac_TechT)], @"IODisplayTechnologyType", [[[DisplayPrefsKey stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-610-a012", displayclassoverride]], @"IODisplayPrefsKey", displayclassoverride, @"IOClass",  nil ];
                }
            }

            break;

        case 2:
            memcpy(EDIDStructure->Serial, MBP_serial, sizeof(MBP_serial));
            memcpy(EDIDStructure->Chroma, MBP_chroma, sizeof(MBP_chroma));
            memcpy(EDIDStructure->BasicParams, MBP_BaseParms, sizeof(MBP_BaseParms));
            memcpy(EDIDStructure->Version, Version_1_4, sizeof(Version_1_4));

            if ([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 1)
            {
                memcpy(EDIDStructure->Descriptor1, MBP_descriptor, sizeof(MBP_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor2, MBP_descriptor, sizeof(MBP_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor3, MBP_descriptor, sizeof(MBP_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor4, MBP_descriptor, sizeof(MBP_descriptor));
                DescriptorSet = YES;
            }
            
            
            if ([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 1)
            {
                memcpy(EDIDStructure->Descriptor1, MBP_descriptor, sizeof(MBP_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor2, MBP_descriptor, sizeof(MBP_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor3, MBP_descriptor, sizeof(MBP_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor4, MBP_descriptor, sizeof(MBP_descriptor));
                DescriptorSet = YES;
            }
            
            if (DescriptorSet == NO)
            {
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor4, MBP_descriptor, sizeof(MBP_descriptor));
                    DescriptorSet = YES;
                }
                
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor3, MBP_descriptor, sizeof(MBP_descriptor));
                    DescriptorSet = YES;
                }
                
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor2, MBP_descriptor, sizeof(MBP_descriptor));
                    DescriptorSet = YES;
                }
                
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor1, MBP_descriptor, sizeof(MBP_descriptor));
                    DescriptorSet = YES;
                }
            }

            FixMonitorRangesInteger = [FixMonitorRangesButton state];
            
            if (FixMonitorRangesInteger == YES)
            {
                [self FixRanges];
            }

            EDIDStructure->Checksum = [self make_checksum:(unsigned char *)EDIDRawData];
            
            DeviceNumber = [NSNumber numberWithInt:MBPDevice];
            VendorNumber = [NSNumber numberWithInt:MBPVendor];

            if (ResCnt > 0)
            {
                if (displayclass == 2)
                {
                    IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:MBPDevice], @"DisplayProductID", [NSNumber numberWithInt:MBPVendor], @"DisplayVendorID", [NSNumber numberWithLongLong:436849163854938112], @"IODisplayGUID", [NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", [NSData dataWithBytes:MBP_CFLAGS length:sizeof(MBP_CFLAGS)], @"IODisplayConnectFlags" , [[[DisplayPrefsKey stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-610-a014", displayclassoverride]], @"IODisplayPrefsKey", displayclassoverride, @"IOClass", ResDataArray, @"scale-resolutions", nil ];
                } else {
                    IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:MBPDevice], @"DisplayProductID", [NSNumber numberWithInt:MBPVendor], @"DisplayVendorID", [NSNumber numberWithLongLong:436849163854938112], @"IODisplayGUID", [NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", [NSData dataWithBytes:MBP_CFLAGS length:sizeof(MBP_CFLAGS)], @"IODisplayConnectFlags" , [[[DisplayPrefsKey stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-610-a014", displayclassoverride]], @"IODisplayPrefsKey", displayclassoverride, @"IOClass", ResDataArray, @"scale-resolutions", nil ];
                }
            } else {
                if (displayclass == 2)
                {
                    IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:MBPDevice], @"DisplayProductID", [NSNumber numberWithInt:MBPVendor], @"DisplayVendorID", [NSNumber numberWithLongLong:436849163854938112], @"IODisplayGUID", [NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", [NSData dataWithBytes:MBP_CFLAGS length:sizeof(MBP_CFLAGS)], @"IODisplayConnectFlags" , [[[DisplayPrefsKey stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-610-a014", displayclassoverride]], @"IODisplayPrefsKey", displayclassoverride, @"IOClass", nil ];
                } else {
                    IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:MBPDevice], @"DisplayProductID", [NSNumber numberWithInt:MBPVendor], @"DisplayVendorID", [NSNumber numberWithLongLong:436849163854938112], @"IODisplayGUID", [NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", [NSData dataWithBytes:MBP_CFLAGS length:sizeof(MBP_CFLAGS)], @"IODisplayConnectFlags" , [[[DisplayPrefsKey stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-610-a014", displayclassoverride]], @"IODisplayPrefsKey", displayclassoverride, @"IOClass", nil ];
                }
            }

            break;

        case 3:
            memcpy(EDIDStructure->Serial, CHD_serial, sizeof(CHD_serial));
            memcpy(EDIDStructure->Chroma, CHD_chroma, sizeof(CHD_chroma));
            memcpy(EDIDStructure->BasicParams, CHD_BaseParms, sizeof(CHD_BaseParms));
            memcpy(EDIDStructure->Version, Version_1_4, sizeof(Version_1_4));

            if ([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 1)
            {
                memcpy(EDIDStructure->Descriptor1, CHD_name_descriptor, sizeof(CHD_name_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor2, CHD_name_descriptor, sizeof(CHD_name_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor3, CHD_name_descriptor, sizeof(CHD_name_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor4, CHD_name_descriptor, sizeof(CHD_name_descriptor));
                DescriptorSet = YES;
            }
            
            
            if ([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 1)
            {
                memcpy(EDIDStructure->Descriptor1, CHD_name_descriptor, sizeof(CHD_name_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor2, CHD_name_descriptor, sizeof(CHD_name_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor3, CHD_name_descriptor, sizeof(CHD_name_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor4, CHD_name_descriptor, sizeof(CHD_name_descriptor));
                DescriptorSet = YES;
            }
            
            if (DescriptorSet == NO)
            {
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor4, CHD_name_descriptor, sizeof(CHD_name_descriptor));
                    DescriptorSet = YES;
                }
                
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor3, CHD_name_descriptor, sizeof(CHD_name_descriptor));
                    DescriptorSet = YES;
                }
                
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor2, CHD_name_descriptor, sizeof(CHD_name_descriptor));
                    DescriptorSet = YES;
                }
                
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor1, CHD_name_descriptor, sizeof(CHD_name_descriptor));
                    DescriptorSet = YES;
                }
            }

            DescriptorSet = NO;

            if ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 1)
            {
                memcpy(EDIDStructure->Descriptor1, CHD_serial_descriptor, sizeof(CHD_serial_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor2, CHD_serial_descriptor, sizeof(CHD_serial_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor3, CHD_serial_descriptor, sizeof(CHD_serial_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor4, CHD_serial_descriptor, sizeof(CHD_serial_descriptor));
                DescriptorSet = YES;
            }
            
            
            if ([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 1)
            {
                memcpy(EDIDStructure->Descriptor1, CHD_serial_descriptor, sizeof(CHD_serial_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor2, CHD_serial_descriptor, sizeof(CHD_serial_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor3, CHD_serial_descriptor, sizeof(CHD_serial_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor4, CHD_serial_descriptor, sizeof(CHD_serial_descriptor));
                DescriptorSet = YES;
            }
            
            if (DescriptorSet == NO)
            {
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor4, CHD_serial_descriptor, sizeof(CHD_serial_descriptor));
                    DescriptorSet = YES;
                }
                
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor3, CHD_serial_descriptor, sizeof(CHD_serial_descriptor));
                    DescriptorSet = YES;
                }
                
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor2, CHD_serial_descriptor, sizeof(CHD_serial_descriptor));
                    DescriptorSet = YES;
                }
                
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor1, CHD_serial_descriptor, sizeof(CHD_serial_descriptor));
                    DescriptorSet = YES;
                }
            }

            FixMonitorRangesInteger = [FixMonitorRangesButton state];
            
            if (FixMonitorRangesInteger == YES)
            {
                [self FixRanges];
            }

            EDIDStructure->Checksum = [self make_checksum:(unsigned char *)EDIDRawData];
            
            DeviceNumber = [NSNumber numberWithInt:CHDDevice];
            VendorNumber = [NSNumber numberWithInt:CHDVendor];

            if (ResCnt > 0)
            {
                if (displayclass == 2)
                {
                    IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:CHDDevice], @"DisplayProductID", [NSNumber numberWithInt:CHDVendor], @"DisplayVendorID", [NSNumber numberWithInt:2], @"AppleDisplayType", [NSNumber numberWithInt:36864], @"AppleSense", [NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", [NSData dataWithBytes:CHD_CFLAGS length:sizeof(CHD_CFLAGS)], @"IODisplayConnectFlags" , [[[DisplayPrefsKey stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-610-9223", displayclassoverride]], @"IODisplayPrefsKey", displayclassoverride, @"IOClass", ResDataArray, @"scale-resolutions", nil ];
                } else {
                    IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:CHDDevice], @"DisplayProductID", [NSNumber numberWithInt:CHDVendor], @"DisplayVendorID", [NSNumber numberWithInt:2], @"AppleDisplayType", [NSNumber numberWithInt:36864], @"AppleSense", [NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", [NSData dataWithBytes:CHD_CFLAGS length:sizeof(CHD_CFLAGS)], @"IODisplayConnectFlags" , [[[DisplayPrefsKey stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-610-9223", displayclassoverride]], @"IODisplayPrefsKey", displayclassoverride, @"IOClass", ResDataArray, @"scale-resolutions", nil ];
                }
            } else {
                if (displayclass == 2)
                {
                    IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:CHDDevice], @"DisplayProductID", [NSNumber numberWithInt:CHDVendor], @"DisplayVendorID", [NSNumber numberWithInt:2], @"AppleDisplayType", [NSNumber numberWithInt:36864], @"AppleSense", [NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", [NSData dataWithBytes:CHD_CFLAGS length:sizeof(CHD_CFLAGS)], @"IODisplayConnectFlags" , [[[DisplayPrefsKey stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-610-9223", displayclassoverride]], @"IODisplayPrefsKey", displayclassoverride, @"IOClass", nil ];
                } else {
                    IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:CHDDevice], @"DisplayProductID", [NSNumber numberWithInt:CHDVendor], @"DisplayVendorID", [NSNumber numberWithInt:2], @"AppleDisplayType", [NSNumber numberWithInt:36864], @"AppleSense", [NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", [NSData dataWithBytes:CHD_CFLAGS length:sizeof(CHD_CFLAGS)], @"IODisplayConnectFlags" , [[[DisplayPrefsKey stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-610-9223", displayclassoverride]], @"IODisplayPrefsKey", displayclassoverride, @"IOClass", nil ];
                }
            }

            break;

        case 4:
            memcpy(EDIDStructure->Serial, TDB_serial, sizeof(TDB_serial));
            memcpy(EDIDStructure->Chroma, TDB_chroma, sizeof(TDB_chroma));
            memcpy(EDIDStructure->BasicParams, TDB_BaseParms, sizeof(TDB_BaseParms));
            memcpy(EDIDStructure->Version, Version_1_4, sizeof(Version_1_4));

            if ([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 1)
            {
                memcpy(EDIDStructure->Descriptor1, TDB_name_descriptor, sizeof(TDB_name_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor2, TDB_name_descriptor, sizeof(TDB_name_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor3, TDB_name_descriptor, sizeof(TDB_name_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor4, TDB_name_descriptor, sizeof(TDB_name_descriptor));
                DescriptorSet = YES;
            }
            
            
            if ([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 1)
            {
                memcpy(EDIDStructure->Descriptor1, TDB_name_descriptor, sizeof(TDB_name_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor2, TDB_name_descriptor, sizeof(TDB_name_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor3, TDB_name_descriptor, sizeof(TDB_name_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor4, TDB_name_descriptor, sizeof(TDB_name_descriptor));
                DescriptorSet = YES;
            }
            
            if (DescriptorSet == NO)
            {
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor4, TDB_name_descriptor, sizeof(TDB_name_descriptor));
                    DescriptorSet = YES;
                }
                
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor3, TDB_name_descriptor, sizeof(TDB_name_descriptor));
                    DescriptorSet = YES;
                }
                
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor2, TDB_name_descriptor, sizeof(TDB_name_descriptor));
                    DescriptorSet = YES;
                }
                
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor1, TDB_name_descriptor, sizeof(TDB_name_descriptor));
                    DescriptorSet = YES;
                }
            }
            
            DescriptorSet = NO;
            
            if ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 1)
            {
                memcpy(EDIDStructure->Descriptor1, TDB_serial_descriptor, sizeof(TDB_serial_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor2, TDB_serial_descriptor, sizeof(TDB_serial_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor3, TDB_serial_descriptor, sizeof(TDB_serial_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor4, TDB_serial_descriptor, sizeof(TDB_serial_descriptor));
                DescriptorSet = YES;
            }
            
            
            if ([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 1)
            {
                memcpy(EDIDStructure->Descriptor1, TDB_serial_descriptor, sizeof(TDB_serial_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor2, TDB_serial_descriptor, sizeof(TDB_serial_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor3, TDB_serial_descriptor, sizeof(TDB_serial_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor4, TDB_serial_descriptor, sizeof(TDB_serial_descriptor));
                DescriptorSet = YES;
            }
            
            if (DescriptorSet == NO)
            {
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor4, TDB_serial_descriptor, sizeof(TDB_serial_descriptor));
                    DescriptorSet = YES;
                }
                
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor3, TDB_serial_descriptor, sizeof(TDB_serial_descriptor));
                    DescriptorSet = YES;
                }
                
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor2, TDB_serial_descriptor, sizeof(TDB_serial_descriptor));
                    DescriptorSet = YES;
                }
                
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor1, TDB_serial_descriptor, sizeof(TDB_serial_descriptor));
                    DescriptorSet = YES;
                }
            }

            FixMonitorRangesInteger = [FixMonitorRangesButton state];
            
            if (FixMonitorRangesInteger == YES)
            {
                [self FixRanges];
            }

            EDIDStructure->Checksum = [self make_checksum:(unsigned char *)EDIDRawData];
            
            DeviceNumber = [NSNumber numberWithInt:TDBDevice];
            VendorNumber = [NSNumber numberWithInt:TDBVendor];

            if (ResCnt > 0)
            {
                if (displayclass == 2)
                {
                    IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:TDBDevice], @"DisplayProductID", [NSNumber numberWithInt:TDBVendor], @"DisplayVendorID", [NSNumber numberWithInt:371392543], @"DisplaySerialNumber", [NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", [NSData dataWithBytes:TDB_DPCAP length:strlen(TDB_DPCAP)], @"IODisplayCapabilityString", [NSData dataWithBytes:TDB_CFLAGS length:sizeof(TDB_CFLAGS)], @"IODisplayConnectFlags", [NSData dataWithBytes:TDB_CTRL length:sizeof(TDB_CTRL)], @"IODisplayControllerID", [NSData dataWithBytes:TDB_FL length:sizeof(TDB_FL)], @"IODisplayFirmwareLevel", [NSData dataWithBytes:TDB_MCSS length:sizeof(TDB_MCSS)], @"IODisplayMCCSVersion", [NSData dataWithBytes:TDB_TechT length:sizeof(TDB_TechT)], @"IODisplayTechnologyType", [[[DisplayPrefsKey stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-610-9227", displayclassoverride]], @"IODisplayPrefsKey", displayclassoverride, @"IOClass", ResDataArray, @"scale-resolutions", nil ];
                } else {
                    IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:TDBDevice], @"DisplayProductID", [NSNumber numberWithInt:TDBVendor], @"DisplayVendorID", [NSNumber numberWithInt:371392543], @"DisplaySerialNumber", [NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", [NSData dataWithBytes:TDB_DPCAP length:strlen(TDB_DPCAP)], @"IODisplayCapabilityString", [NSData dataWithBytes:TDB_CFLAGS length:sizeof(TDB_CFLAGS)], @"IODisplayConnectFlags", [NSData dataWithBytes:TDB_CTRL length:sizeof(TDB_CTRL)], @"IODisplayControllerID", [NSData dataWithBytes:TDB_FL length:sizeof(TDB_FL)], @"IODisplayFirmwareLevel", [NSData dataWithBytes:TDB_MCSS length:sizeof(TDB_MCSS)], @"IODisplayMCCSVersion", [NSData dataWithBytes:TDB_TechT length:sizeof(TDB_TechT)], @"IODisplayTechnologyType", [[[DisplayPrefsKey stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-610-9227", displayclassoverride]], @"IODisplayPrefsKey", displayclassoverride, @"IOClass", ResDataArray, @"scale-resolutions", nil ];
                }
            } else {
                if (displayclass == 2)
                {
                    IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:TDBDevice], @"DisplayProductID", [NSNumber numberWithInt:TDBVendor], @"DisplayVendorID", [NSNumber numberWithInt:371392543], @"DisplaySerialNumber", [NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", [NSData dataWithBytes:TDB_DPCAP length:strlen(TDB_DPCAP)], @"IODisplayCapabilityString", [NSData dataWithBytes:TDB_CFLAGS length:sizeof(TDB_CFLAGS)], @"IODisplayConnectFlags", [NSData dataWithBytes:TDB_CTRL length:sizeof(TDB_CTRL)], @"IODisplayControllerID", [NSData dataWithBytes:TDB_FL length:sizeof(TDB_FL)], @"IODisplayFirmwareLevel", [NSData dataWithBytes:TDB_MCSS length:sizeof(TDB_MCSS)], @"IODisplayMCCSVersion", [NSData dataWithBytes:TDB_TechT length:sizeof(TDB_TechT)], @"IODisplayTechnologyType", [[[DisplayPrefsKey stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-610-9227", displayclassoverride]], @"IODisplayPrefsKey", displayclassoverride, @"IOClass", nil ];
                } else {
                    IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:TDBDevice], @"DisplayProductID", [NSNumber numberWithInt:TDBVendor], @"DisplayVendorID", [NSNumber numberWithInt:371392543], @"DisplaySerialNumber", [NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", [NSData dataWithBytes:TDB_DPCAP length:strlen(TDB_DPCAP)], @"IODisplayCapabilityString", [NSData dataWithBytes:TDB_CFLAGS length:sizeof(TDB_CFLAGS)], @"IODisplayConnectFlags", [NSData dataWithBytes:TDB_CTRL length:sizeof(TDB_CTRL)], @"IODisplayControllerID", [NSData dataWithBytes:TDB_FL length:sizeof(TDB_FL)], @"IODisplayFirmwareLevel", [NSData dataWithBytes:TDB_MCSS length:sizeof(TDB_MCSS)], @"IODisplayMCCSVersion", [NSData dataWithBytes:TDB_TechT length:sizeof(TDB_TechT)], @"IODisplayTechnologyType", [[[DisplayPrefsKey stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-610-9227", displayclassoverride]], @"IODisplayPrefsKey", displayclassoverride, @"IOClass", nil ];
                }
            }

        break;

        case 5:
            memcpy(EDIDStructure->Serial, LED_serial, sizeof(LED_serial));
            memcpy(EDIDStructure->Chroma, LED_chroma, sizeof(LED_chroma));
            memcpy(EDIDStructure->BasicParams, LED_BaseParms, sizeof(LED_BaseParms));
            memcpy(EDIDStructure->Version, Version_1_4, sizeof(Version_1_4));
            
            if ([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 1)
            {
                memcpy(EDIDStructure->Descriptor1, LED_name_descriptor, sizeof(LED_name_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor2, LED_name_descriptor, sizeof(LED_name_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor3, LED_name_descriptor, sizeof(LED_name_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor4, LED_name_descriptor, sizeof(LED_name_descriptor));
                DescriptorSet = YES;
            }
            
            
            if ([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 1)
            {
                memcpy(EDIDStructure->Descriptor1, LED_name_descriptor, sizeof(LED_name_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor2, LED_name_descriptor, sizeof(LED_name_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor3, LED_name_descriptor, sizeof(LED_name_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor4, LED_name_descriptor, sizeof(LED_name_descriptor));
                DescriptorSet = YES;
            }
            
            if (DescriptorSet == NO)
            {
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor4, LED_name_descriptor, sizeof(LED_name_descriptor));
                    DescriptorSet = YES;
                }
                
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor3, LED_name_descriptor, sizeof(LED_name_descriptor));
                    DescriptorSet = YES;
                }
                
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor2, LED_name_descriptor, sizeof(LED_name_descriptor));
                    DescriptorSet = YES;
                }
                
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor1, LED_name_descriptor, sizeof(LED_name_descriptor));
                    DescriptorSet = YES;
                }
            }
            
            DescriptorSet = NO;
            
            if ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 1)
            {
                memcpy(EDIDStructure->Descriptor1, LED_serial_descriptor, sizeof(LED_serial_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor2, LED_serial_descriptor, sizeof(LED_serial_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor3, LED_serial_descriptor, sizeof(LED_serial_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor4, LED_serial_descriptor, sizeof(LED_serial_descriptor));
                DescriptorSet = YES;
            }
            
            
            if ([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 1)
            {
                memcpy(EDIDStructure->Descriptor1, LED_serial_descriptor, sizeof(LED_serial_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor2, LED_serial_descriptor, sizeof(LED_serial_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor3, LED_serial_descriptor, sizeof(LED_serial_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor4, LED_serial_descriptor, sizeof(LED_serial_descriptor));
                DescriptorSet = YES;
            }
            
            if (DescriptorSet == NO)
            {
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor4, LED_serial_descriptor, sizeof(LED_serial_descriptor));
                    DescriptorSet = YES;
                }
                
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor3, LED_serial_descriptor, sizeof(LED_serial_descriptor));
                    DescriptorSet = YES;
                }
                
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor2, LED_serial_descriptor, sizeof(LED_serial_descriptor));
                    DescriptorSet = YES;
                }
                
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor1, LED_serial_descriptor, sizeof(LED_serial_descriptor));
                    DescriptorSet = YES;
                }
            }

            FixMonitorRangesInteger = [FixMonitorRangesButton state];
            
            if (FixMonitorRangesInteger == YES)
            {
                [self FixRanges];
            }

            EDIDStructure->Checksum = [self make_checksum:(unsigned char *)EDIDRawData];
            
            DeviceNumber = [NSNumber numberWithInt:CHDDevice];
            VendorNumber = [NSNumber numberWithInt:CHDVendor];

            if (ResCnt > 0)
            {
                if (displayclass == 2)
                {
                    IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:LEDDevice], @"DisplayProductID", [NSNumber numberWithInt:LEDVendor], @"DisplayVendorID", [NSNumber numberWithInt:2], @"AppleDisplayType", [NSNumber numberWithInt:1854], @"AppleSense", [NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", [NSData dataWithBytes:LED_CFLAGS length:sizeof(LED_CFLAGS)], @"IODisplayConnectFlags" , [[[DisplayPrefsKey stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-610-9236", displayclassoverride]], @"IODisplayPrefsKey", displayclassoverride, @"IOClass", ResDataArray, @"scale-resolutions", nil ];
                } else {
                    IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:LEDDevice], @"DisplayProductID", [NSNumber numberWithInt:LEDVendor], @"DisplayVendorID", [NSNumber numberWithInt:2], @"AppleDisplayType", [NSNumber numberWithInt:1854], @"AppleSense", [NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", [NSData dataWithBytes:LED_CFLAGS length:sizeof(LED_CFLAGS)], @"IODisplayConnectFlags" , [[[DisplayPrefsKey stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-610-9236", displayclassoverride]], @"IODisplayPrefsKey", displayclassoverride, @"IOClass", ResDataArray, @"scale-resolutions", nil ];
                }
            } else {
                if (displayclass == 2)
                {
                    IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:LEDDevice], @"DisplayProductID", [NSNumber numberWithInt:LEDVendor], @"DisplayVendorID", [NSNumber numberWithInt:2], @"AppleDisplayType", [NSNumber numberWithInt:1854], @"AppleSense", [NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", [NSData dataWithBytes:LED_CFLAGS length:sizeof(LED_CFLAGS)], @"IODisplayConnectFlags" , [[[DisplayPrefsKey stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-610-9236", displayclassoverride]], @"IODisplayPrefsKey", displayclassoverride, @"IOClass", nil ];
                } else {
                    IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:LEDDevice], @"DisplayProductID", [NSNumber numberWithInt:LEDVendor], @"DisplayVendorID", [NSNumber numberWithInt:2], @"AppleDisplayType", [NSNumber numberWithInt:1854], @"AppleSense", [NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", [NSData dataWithBytes:LED_CFLAGS length:sizeof(LED_CFLAGS)], @"IODisplayConnectFlags" , [[[DisplayPrefsKey stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-610-9236", displayclassoverride]], @"IODisplayPrefsKey", displayclassoverride, @"IOClass", nil ];
                }
            }
            
            break;

        case 6:

            memcpy(EDIDStructure->Chroma, iMac_chroma, sizeof(iMac_chroma));

            FixMonitorRangesInteger = [FixMonitorRangesButton state];

            if (FixMonitorRangesInteger == YES)
            {
                [self FixRanges];
            }
            
            EDIDStructure->Checksum = [self make_checksum:(unsigned char *)EDIDRawData];

            if (ResCnt > 0)
            {
                IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", ResDataArray, @"scale-resolutions", nil ];
            } else {
                IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", nil ];
            }
            
            DeviceNumber = [NSNumber numberWithInt:[DeviceDecID intValue]];
            VendorNumber = [NSNumber numberWithInt:[VendorDecID intValue]];
            
            break;

        case 7:
            memcpy(EDIDStructure->Serial, iMac_serial, sizeof(iMacRetina_serial));
            memcpy(EDIDStructure->Chroma, iMac_chroma, sizeof(iMacRetina_chroma));
            memcpy(EDIDStructure->BasicParams, iMac_BaseParms, sizeof(iMacRetina_BaseParms));
            memcpy(EDIDStructure->Version, Version_1_4, sizeof(Version_1_4));
            
            if ([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 1)
            {
                memcpy(EDIDStructure->Descriptor1, iMacRetina_descriptor, sizeof(iMacRetina_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor2, iMacRetina_descriptor, sizeof(iMacRetina_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor3, iMacRetina_descriptor, sizeof(iMacRetina_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor4, iMacRetina_descriptor, sizeof(iMacRetina_descriptor));
                DescriptorSet = YES;
            }
            
            
            if ([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 1)
            {
                memcpy(EDIDStructure->Descriptor1, iMacRetina_descriptor, sizeof(iMacRetina_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor2, iMacRetina_descriptor, sizeof(iMacRetina_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor3, iMacRetina_descriptor, sizeof(iMacRetina_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor4, iMacRetina_descriptor, sizeof(iMacRetina_descriptor));
                DescriptorSet = YES;
            }
            
            if (DescriptorSet == NO)
            {
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor4, iMacRetina_descriptor, sizeof(iMacRetina_descriptor));
                    DescriptorSet = YES;
                }
                
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor3, iMacRetina_descriptor, sizeof(iMacRetina_descriptor));
                    DescriptorSet = YES;
                }
                
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor2, iMacRetina_descriptor, sizeof(iMacRetina_descriptor));
                    DescriptorSet = YES;
                }
                
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor1, iMacRetina_descriptor, sizeof(iMacRetina_descriptor));
                    DescriptorSet = YES;
                }
            }
            
            FixMonitorRangesInteger = [FixMonitorRangesButton state];
            
            if (FixMonitorRangesInteger == YES)
            {
                [self FixRanges];
            }
            
            EDIDStructure->Checksum = [self make_checksum:(unsigned char *)EDIDRawData];
            
            DeviceNumber = [NSNumber numberWithInt:iMacRetinaDevice];
            VendorNumber = [NSNumber numberWithInt:iMacRetinaVendor];
            
            if (ResCnt > 0)
            {
                if (displayclass == 2)
                {
                    IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:iMacRetinaDevice], @"DisplayProductID", [NSNumber numberWithInt:iMacRetinaVendor], @"DisplayVendorID", [NSNumber numberWithInt:2], @"AppleDisplayType", [NSNumber numberWithInt:1854], @"AppleSense", [NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", [NSData dataWithBytes:iMacRetina_DPCAP length:strlen(iMacRetina_DPCAP)], @"IODisplayCapabilityString", [NSData dataWithBytes:iMacRetina_CFlags length:sizeof(iMacRetina_CFlags)], @"IODisplayConnectFlags", [NSData dataWithBytes:iMacRetina_CTRL length:sizeof(iMacRetina_CTRL)], @"IODisplayControllerID", [NSData dataWithBytes:iMacRetina_FL length:sizeof(iMacRetina_FL)], @"IODisplayFirmwareLevel", [NSData dataWithBytes:iMacRetina_MCSS length:sizeof(iMacRetina_MCSS)], @"IODisplayMCCSVersion", [NSNumber numberWithBool:YES], @"DisplayParameterHandlerUsesCharPtr", [[[DisplayPrefsKey stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-610-b005", displayclassoverride]], @"IODisplayPrefsKey", displayclassoverride, @"IOClass", ResDataArray, @"scale-resolutions", nil ];
                } else {
                    IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:iMacRetinaDevice], @"DisplayProductID", [NSNumber numberWithInt:iMacRetinaVendor], @"DisplayVendorID", [NSNumber numberWithInt:2], @"AppleDisplayType", [NSNumber numberWithInt:1854], @"AppleSense", [NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", [NSData dataWithBytes:iMacRetina_DPCAP length:strlen(iMacRetina_DPCAP)], @"IODisplayCapabilityString", [NSData dataWithBytes:iMacRetina_CFlags length:sizeof(iMacRetina_CFlags)], @"IODisplayConnectFlags", [NSData dataWithBytes:iMacRetina_CTRL length:sizeof(iMacRetina_CTRL)], @"IODisplayControllerID", [NSData dataWithBytes:iMacRetina_FL length:sizeof(iMacRetina_FL)], @"IODisplayFirmwareLevel", [NSData dataWithBytes:iMacRetina_MCSS length:sizeof(iMacRetina_MCSS)], @"IODisplayMCCSVersion", [NSNumber numberWithBool:YES], @"DisplayParameterHandlerUsesCharPtr", [[[DisplayPrefsKey stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-610-b005", displayclassoverride]], @"IODisplayPrefsKey", displayclassoverride, @"IOClass",  ResDataArray, @"scale-resolutions", nil ];
                }
            } else {
                if (displayclass == 2)
                {
                    IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:iMacRetinaDevice], @"DisplayProductID", [NSNumber numberWithInt:iMacRetinaVendor], @"DisplayVendorID", [NSNumber numberWithInt:2], @"AppleDisplayType", [NSNumber numberWithInt:1854], @"AppleSense", [NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", [NSData dataWithBytes:iMacRetina_DPCAP length:strlen(iMacRetina_DPCAP)], @"IODisplayCapabilityString", [NSData dataWithBytes:iMacRetina_CFlags length:sizeof(iMacRetina_CFlags)], @"IODisplayConnectFlags", [NSData dataWithBytes:iMacRetina_CTRL length:sizeof(iMacRetina_CTRL)], @"IODisplayControllerID", [NSData dataWithBytes:iMacRetina_FL length:sizeof(iMacRetina_FL)], @"IODisplayFirmwareLevel", [NSData dataWithBytes:iMacRetina_MCSS length:sizeof(iMacRetina_MCSS)], @"IODisplayMCCSVersion", [NSNumber numberWithBool:YES], @"DisplayParameterHandlerUsesCharPtr", [[[DisplayPrefsKey stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-610-b005", displayclassoverride]], @"IODisplayPrefsKey", displayclassoverride, @"IOClass", nil ];
                } else {
                    IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:iMacRetinaDevice], @"DisplayProductID", [NSNumber numberWithInt:iMacRetinaVendor], @"DisplayVendorID", [NSNumber numberWithInt:2], @"AppleDisplayType", [NSNumber numberWithInt:1854], @"AppleSense", [NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", [NSData dataWithBytes:iMacRetina_DPCAP length:strlen(iMacRetina_DPCAP)], @"IODisplayCapabilityString", [NSData dataWithBytes:iMacRetina_CFlags length:sizeof(iMacRetina_CFlags)], @"IODisplayConnectFlags", [NSData dataWithBytes:iMacRetina_CTRL length:sizeof(iMacRetina_CTRL)], @"IODisplayControllerID", [NSData dataWithBytes:iMacRetina_FL length:sizeof(iMacRetina_FL)], @"IODisplayFirmwareLevel", [NSData dataWithBytes:iMacRetina_MCSS length:sizeof(iMacRetina_MCSS)], @"IODisplayMCCSVersion", [NSNumber numberWithBool:YES], @"DisplayParameterHandlerUsesCharPtr", [[[DisplayPrefsKey stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-610-b005", displayclassoverride]], @"IODisplayPrefsKey", displayclassoverride, @"IOClass",  nil ];
                }
            }
            
            break;

        case 8:
            memcpy(EDIDStructure->Serial, MBA_serial, sizeof(MBA_serial));
            memcpy(EDIDStructure->Chroma, MBA_chroma, sizeof(MBA_chroma));
            memcpy(EDIDStructure->BasicParams, MBA_BaseParms, sizeof(MBA_BaseParms));
            memcpy(EDIDStructure->Version, Version_1_4, sizeof(Version_1_4));
            
            if ([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 1)
            {
                memcpy(EDIDStructure->Descriptor1, MBA_descriptor, sizeof(MBA_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor2, MBA_descriptor, sizeof(MBA_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor3, MBA_descriptor, sizeof(MBA_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor4, MBA_descriptor, sizeof(MBA_descriptor));
                DescriptorSet = YES;
            }
            
            
            if ([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 1)
            {
                memcpy(EDIDStructure->Descriptor1, MBA_descriptor, sizeof(MBA_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor2, MBA_descriptor, sizeof(MBA_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor3, MBA_descriptor, sizeof(MBA_descriptor));
                DescriptorSet = YES;
            }
            
            if (([self ScanForOtherDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 1) && (DescriptorSet == NO))
            {
                memcpy(EDIDStructure->Descriptor4, MBA_descriptor, sizeof(MBA_descriptor));
                DescriptorSet = YES;
            }
            
            if (DescriptorSet == NO)
            {
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor4] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor4, MBA_descriptor, sizeof(MBA_descriptor));
                    DescriptorSet = YES;
                }
                
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor3] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor3, MBA_descriptor, sizeof(MBA_descriptor));
                    DescriptorSet = YES;
                }
                
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor2] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor2, MBA_descriptor, sizeof(MBA_descriptor));
                    DescriptorSet = YES;
                }
                
                if (([self ScanForNameDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    ([self ScanForSerialDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    ([self ScanForRangeDescriptor:(unsigned char *)EDIDStructure->Descriptor1] == 0) &&
                    (DescriptorSet == NO))
                {
                    memcpy(EDIDStructure->Descriptor1, MBA_descriptor, sizeof(MBA_descriptor));
                    DescriptorSet = YES;
                }
            }
            
            FixMonitorRangesInteger = [FixMonitorRangesButton state];
            
            if (FixMonitorRangesInteger == YES)
            {
                [self FixRanges];
            }
            
            EDIDStructure->Checksum = [self make_checksum:(unsigned char *)EDIDRawData];
            
            DeviceNumber = [NSNumber numberWithInt:MBADevice];
            VendorNumber = [NSNumber numberWithInt:MBAVendor];
            
            if (ResCnt > 0)
            {
                if (displayclass == 2)
                {
                    IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:MBADevice], @"DisplayProductID", [NSNumber numberWithInt:MBAVendor], @"DisplayVendorID", [NSNumber numberWithLongLong:436849163854938112], @"IODisplayGUID", [NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", [NSData dataWithBytes:MBA_CFLAGS length:sizeof(MBA_CFLAGS)], @"IODisplayConnectFlags" , [[[DisplayPrefsKey stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-610-9cf2", displayclassoverride]], @"IODisplayPrefsKey", displayclassoverride, @"IOClass", ResDataArray, @"scale-resolutions", nil ];
                } else {
                    IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:MBADevice], @"DisplayProductID", [NSNumber numberWithInt:MBAVendor], @"DisplayVendorID", [NSNumber numberWithLongLong:436849163854938112], @"IODisplayGUID", [NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", [NSData dataWithBytes:MBA_CFLAGS length:sizeof(MBA_CFLAGS)], @"IODisplayConnectFlags" , [[[DisplayPrefsKey stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-610-9cf2", displayclassoverride]], @"IODisplayPrefsKey", displayclassoverride, @"IOClass", ResDataArray, @"scale-resolutions", nil ];
                }
            } else {
                if (displayclass == 2)
                {
                    IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:MBADevice], @"DisplayProductID", [NSNumber numberWithInt:MBAVendor], @"DisplayVendorID", [NSNumber numberWithLongLong:436849163854938112], @"IODisplayGUID", [NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", [NSData dataWithBytes:MBA_CFLAGS length:sizeof(MBA_CFLAGS)], @"IODisplayConnectFlags" , [[[DisplayPrefsKey stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-610-9cf2", displayclassoverride]], @"IODisplayPrefsKey", displayclassoverride, @"IOClass", nil ];
                } else {
                    IOProviderMergeProperties = [ NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:MBADevice], @"DisplayProductID", [NSNumber numberWithInt:MBAVendor], @"DisplayVendorID", [NSNumber numberWithLongLong:436849163854938112], @"IODisplayGUID", [NSData dataWithBytes:EDIDRawData length:EDIDSize], @"IODisplayEDID", [NSData dataWithBytes:MBA_CFLAGS length:sizeof(MBA_CFLAGS)], @"IODisplayConnectFlags" , [[[DisplayPrefsKey stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-610-9cf2", displayclassoverride]], @"IODisplayPrefsKey", displayclassoverride, @"IOClass", nil ];
                }
            }
            
            break;
    }

    EDIDData = [NSData dataWithBytes:EDIDRawData length:EDIDSize];

    if (ResCnt > 0)
    {
        EDIDOverride = [NSDictionary dictionaryWithObjectsAndKeys:DeviceNumber, @"DisplayProductID", VendorNumber, @"DisplayVendorID", EDIDData, @"IODisplayEDID", ResDataArray, @"scale-resolutions", nil];
    } else {
        EDIDOverride = [NSDictionary dictionaryWithObjectsAndKeys:DeviceNumber, @"DisplayProductID", VendorNumber, @"DisplayVendorID", EDIDData, @"IODisplayEDID", nil];
    }

    DesktopPath = NSHomeDirectory();
    DesktopPath = [DesktopPath stringByAppendingPathComponent:@"Desktop"];

#if MAC_OS_X_VERSION_MIN_REQUIRED >= 1050
    NewDisplayDriverPath = [DesktopPath stringByAppendingPathComponent:@"DisplayMergeNub.kext"];
    NewDisplayDriverPath = [NewDisplayDriverPath stringByAppendingPathComponent:@"Contents"];
    DriverBinCSTarget = [NewDisplayDriverPath stringByAppendingPathComponent:@"_CodeSignature"];
    DriverBinPath = [NewDisplayDriverPath stringByAppendingPathComponent:@"MacOS"];
    NewDisplayDriverPath = [NewDisplayDriverPath stringByAppendingPathComponent:@"Info.plist"];
    if ([[NSFileManager defaultManager] createDirectoryAtPath:DriverBinPath withIntermediateDirectories:YES attributes:nil error:&err] == NO)
    {
        errorstring = [err localizedDescription];
        errorstring = [errorstring stringByAppendingString:@"\n"];
        errorstring = [errorstring stringByAppendingString:[err localizedFailureReason]];

        alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert setIcon:[[NSApplication sharedApplication] applicationIconImage]];
        [alert setMessageText:@"Error occured while making kext path!"];
        [alert setInformativeText:errorstring];
        [alert runModal];
        [alert release];
    }
#else
    NewDisplayDriverPath = [DesktopPath stringByAppendingPathComponent:@"DisplayMergeNub.kext"];
    [[NSFileManager defaultManager] createDirectoryAtPath:NewDisplayDriverPath attributes:nil];
    NewDisplayDriverPath = [NewDisplayDriverPath stringByAppendingPathComponent:@"Contents"];
    [[NSFileManager defaultManager] createDirectoryAtPath:NewDisplayDriverPath attributes:nil];
    DriverBinCSTarget = [NewDisplayDriverPath stringByAppendingPathComponent:@"_CodeSignature"];
    DriverBinPath = [NewDisplayDriverPath stringByAppendingPathComponent:@"MacOS"];
    [[NSFileManager defaultManager] createDirectoryAtPath:DriverBinPath attributes:nil];
    DriverBinResPath = [DriverBinPath stringByAppendingPathComponent:@"DisplayMergeNub"];
    NewDisplayDriverPath = [NewDisplayDriverPath stringByAppendingPathComponent:@"Info.plist"];
#endif

    DriverBinResPath = [[NSBundle mainBundle] resourcePath];
    DriverBinCSPath = [DriverBinResPath stringByAppendingPathComponent:@"_CodeSignature"];
    DriverBinResPath = [DriverBinResPath stringByAppendingPathComponent:@"DisplayMergeNub"];

    snprintf(CopyPath, sizeof(CopyPath), "/bin/cp -f \"%s\" \"%s\"", [DriverBinResPath cStringUsingEncoding:NSUTF8StringEncoding], [DriverBinPath cStringUsingEncoding:NSUTF8StringEncoding]);
    system(CopyPath);

    snprintf(CopyCSPath, sizeof(CopyPath), "/bin/cp -Rf \"%s\" \"%s\"", [DriverBinCSPath cStringUsingEncoding:NSUTF8StringEncoding], [DriverBinCSTarget cStringUsingEncoding:NSUTF8StringEncoding]);
    system(CopyCSPath);

    NewEDIDPath = [DesktopPath stringByAppendingPathComponent:@"EDID-"];
    NewEDIDPath = [NewEDIDPath stringByAppendingString:[VendorID stringValue]];
    NewEDIDPath = [NewEDIDPath stringByAppendingString:@"-"];
    NewEDIDPath = [NewEDIDPath stringByAppendingString:[DeviceID stringValue]];
    NewEDIDPath = [NewEDIDPath stringByAppendingPathExtension:@"bin"];
    
    NewDisplayOverridePath = [DesktopPath stringByAppendingPathComponent:@"DisplayVendorID-"];
    NewDisplayOverridePath = [NewDisplayOverridePath stringByAppendingString:[VendorID stringValue]];

#if MAC_OS_X_VERSION_MIN_REQUIRED >= 1050
    if ([[NSFileManager defaultManager] createDirectoryAtPath:NewDisplayOverridePath withIntermediateDirectories:YES attributes:nil error:&err] == NO)
    {
        errorstring = [err localizedDescription];
        errorstring = [errorstring stringByAppendingString:@"\n"];
        errorstring = [errorstring stringByAppendingString:[err localizedFailureReason]];
        
        alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert setIcon:[[NSApplication sharedApplication] applicationIconImage]];
        [alert setMessageText:@"Error occured while making displayoverride path!"];
        [alert setInformativeText:errorstring];
        [alert runModal];
        [alert release];
    }
#else
    [[NSFileManager defaultManager] createDirectoryAtPath:NewDisplayOverridePath attributes:nil];
#endif

    NewDisplayOverridePath = [NewDisplayOverridePath stringByAppendingPathComponent:@"DisplayProductID-"];
    NewDisplayOverridePath = [NewDisplayOverridePath stringByAppendingString:[DeviceID stringValue]];

    [EDIDOverride writeToFile:NewDisplayOverridePath atomically:YES];
    [EDIDData writeToFile:NewEDIDPath atomically:YES];

    IgnoreDisplayPrefsInteger = [IgnoreDisplayPrefsButton state];

    if (IgnoreDisplayPrefsInteger == YES)
    {
        IgnoreDisplayPrefs = YES;
    } else {
        IgnoreDisplayPrefs = NO;
    }

    if (displayclass == 2)
    {
        MonInjection = [NSDictionary dictionaryWithObjectsAndKeys:@"com.AnV.Software.driver.AppleMonitor", @"CFBundleIdentifier", @"DisplayMergeNub", @"IOClass", @"AppleBacklightDisplay", @"IOProviderClass", IOProviderMergeProperties, @"IOProviderMergeProperties", [NSNumber numberWithInt:[DeviceDecID intValue]], @"DisplayProductID", [NSNumber numberWithInt:[VendorDecID intValue]], @"DisplayVendorID", [NSNumber numberWithBool:IgnoreDisplayPrefs], @"IgnoreDisplayPrefs", [DisplayPrefsKey stringValue], @"IODisplayPrefsKey", nil];
    } else {
        MonInjection = [NSDictionary dictionaryWithObjectsAndKeys:@"com.AnV.Software.driver.AppleMonitor", @"CFBundleIdentifier", @"DisplayMergeNub", @"IOClass", @"AppleDisplay", @"IOProviderClass", IOProviderMergeProperties, @"IOProviderMergeProperties", [NSNumber numberWithInt:[DeviceDecID intValue]], @"DisplayProductID", [NSNumber numberWithInt:[VendorDecID intValue]], @"DisplayVendorID", [NSNumber numberWithBool:IgnoreDisplayPrefs], @"IgnoreDisplayPrefs", [DisplayPrefsKey stringValue], @"IODisplayPrefsKey", nil];
    }

    IOKitPersonalities = [NSDictionary dictionaryWithObjectsAndKeys:MonInjection, @"Monitor Apple ID Injection", nil];

    OSBundleLibraries = [NSDictionary dictionaryWithObjectsAndKeys:@"8.0.0b1", @"com.apple.kpi.bsd", @"8.0.0b1", @"com.apple.kpi.iokit", @"8.0.0b1", @"com.apple.kpi.libkern", nil];

    DriverDict = [NSDictionary dictionaryWithObjectsAndKeys:@"English", @"CFBundleDevelopmentRegion", @"com.AnV.Software.driver.AppleMonitor", @"CFBundleIdentifier", @"DisplayMergeNub", @"CFBundleExecutable", @"6.0", @"CFBundleInfoDictionaryVersion", @"Display Injector", @"CFBundleName", @"KEXT", @"CFBundlePackageType", @"????", @"CFBundleSignature", @"9.9.9", @"CFBundleVersion", @"9.9.9", @"CFBundleShortVersionString", @"Copright (C) 2013 AnV Software", @"CFBundleGetInfoString", @"", @"DTCompiler", @"4G2008a", @"DTPlatformBuild", @"GM", @"DTPlatformVersion", @"12C37", @"DTSDKBuild", @"Custom", @"DTSDKName", @"0452", @"DTXcode" , @"4G2008a", @"DTXcodeBuild", OSBundleLibraries, @"OSBundleLibraries", IOKitPersonalities, @"IOKitPersonalities", @"Root", @"OSBundleRequired", @"8.8.8", @"OSBundleCompatibleVerson", nil];
    

    [DriverDict writeToFile:NewDisplayDriverPath atomically:YES];
}

-(void)SetRawEDID:(id)sender
{
    PanelSelected = 0;
}

-(void)SetiMac:(id)sender
{
    PanelSelected = 1;
}

-(void)SetMacbookPro:(id)sender
{
    PanelSelected = 2;
}

-(void)SetCinemaHD:(id)sender
{
    PanelSelected = 3;
}

-(void)SetThunderbolt:(id)sender
{
    PanelSelected = 4;
}

-(void)SetLEDCinema:(id)sender
{
    PanelSelected = 5;
}

-(void)SetColorPatchedEDID:(id)sender
{
    PanelSelected = 6;
}

-(void)SetRetinaiMac:(id)sender
{
    PanelSelected = 7;
}

-(void)SetMacbookAir:(id)sender
{
    PanelSelected = 8;
}

-(void)SetAppleDisplay:(id)sender
{
    displayclass = 1;
}

-(void)SetAppleBacklightDisplay:(id)sender
{
    displayclass = 2;
}

-(void)SetOverrideAppleBacklightDisplay:(id)sender
{
    displayclassoverride = @"AppleBacklightDisplay";
}

-(void)SetOverrideAppleDisplay:(id)sender
{
    displayclassoverride = @"AppleDisplay";
}

-(void)OpenEDIDFile:(id)sender
{
    EDIDPanel = [NSOpenPanel openPanel];

    [EDIDPanel setAllowsMultipleSelection:NO];
    [EDIDPanel setCanChooseFiles:YES];
    [EDIDPanel setCanChooseDirectories:NO];

    panelresult = (int)[EDIDPanel runModal];

    if (panelresult != 0)
    {
        [EDIDPath setStringValue:[[[EDIDPanel URLs] objectAtIndex:0] path]];

        file = fopen([[EDIDPath stringValue] cStringUsingEncoding:NSUTF8StringEncoding], "rb");

        if (!file)
        {
            NSRunAlertPanel(@"Open EDID file failed!", @"Open failed!", @"OK", nil, nil);
            
            EDIDFileOpened = NO;
            [EDIDPath setStringValue:@""];

            return;
        }

        fseek(file, 0, SEEK_END);
        EDIDSize = (int)ftell(file);

        if (EDIDSize == 0)
        {
            NSRunAlertPanel(@"Open EDID file failed!", @"File is empty!", @"OK", nil, nil);

            EDIDFileOpened = NO;
            [EDIDPath setStringValue:@"Open an EDID file"];

            return;
        }

        fseek(file, 0, SEEK_SET);

        EDIDRawData = malloc(EDIDSize);

        if (!EDIDRawData)
        {
            NSRunAlertPanel(@"Open EDID file failed!", @"Memory allocation error!", @"OK", nil, nil);
            
            EDIDFileOpened = NO;
            [EDIDPath setStringValue:@"Open an EDID file"];
            
            return;
        }
        
        fread(EDIDRawData, 1, EDIDSize, file);

        EDIDStructure = (EDIDStruct_t *)EDIDRawData;

        if (memcmp(EDIDStructure->Header, EDID_Header, sizeof(EDID_Header)))
        {
            NSRunAlertPanel(@"Open EDID file failed!", @"EDID header is incorrect!", @"OK", nil, nil);

            EDIDFileOpened = NO;
            [EDIDPath setStringValue:@"Open an EDID file"];
            free(EDIDRawData);

            return;
        }

        [self DetermineAspectRatio];

        EDIDFileOpened = YES;
    }
}

-(void)GetScreenVendorDevice:(id)sender
{
    displayInfo = [[NSMutableDictionary alloc] init];
    displayArray = [[NSMutableArray alloc] init];
    
    task = [NSTask  new];
    pipe = [NSPipe pipe];
    [task setLaunchPath:@"/bin/sh"];
    [task setArguments:[NSArray arrayWithObjects:@"-c", @"ioreg -lxw0 |  grep IODisplayPrefsKey | cut -d\"=\" -f2 | cut -d\"\\\"\" -f2",  nil]];
    [task setStandardOutput:pipe];
    [task launch];
    
    outStr = [[[NSString alloc] initWithData:[[pipe fileHandleForReading] readDataToEndOfFile] encoding:NSUTF8StringEncoding] autorelease];
    outStr = [outStr substringToIndex:[outStr length]-1];
    
    temparray = [NSArray arrayWithArray:[outStr componentsSeparatedByString:@"\n"]];
    [Displays removeAllItems];
    for (int i = 0; i < temparray.count ; i++) {
        tmp = [temparray objectAtIndex:i];
        [displayArray addObject:
         [NSDictionary dictionaryWithObjectsAndKeys:
          /*                                    Value                                 ||        Key       */
          tmp,                                                                          @"IODisplayPrefsKey",
          [[[tmp lastPathComponent] componentsSeparatedByString:@"-"] objectAtIndex:1], @"DisplayVendorID",
          [[[tmp lastPathComponent] componentsSeparatedByString:@"-"] objectAtIndex:2], @"DisplayProductID",
          nil]];
        [Displays addItemWithTitle:[NSString stringWithFormat:@"Display 0x%@:0x%@",
                                    [[[tmp lastPathComponent] componentsSeparatedByString:@"-"] objectAtIndex:1],
                                    [[[tmp lastPathComponent] componentsSeparatedByString:@"-"] objectAtIndex:2]]];
        [[Displays itemAtIndex:i] setTag:i];
        if ([Displays numberOfItems] > 1)
        {
            TotalNumberDisplays = [NSString stringWithFormat:@"%d displays found", (int)[Displays numberOfItems]];
        } else if ([Displays numberOfItems] == 1) {
            TotalNumberDisplays = [NSString stringWithFormat:@"%d display found", (int)[Displays numberOfItems]];
        }
        [ScreenCount setStringValue:TotalNumberDisplays];
    }
    
    [Displays selectItemAtIndex:0];
    [self SelectDisplay:Displays];
}

- (void)SelectDisplay:(id)sender
{
    devId = [[displayArray objectAtIndex:[sender selectedTag]] objectForKey:@"DisplayProductID"];
    venId = [[displayArray objectAtIndex:[sender selectedTag]] objectForKey:@"DisplayVendorID"];
    displayPref = [[displayArray objectAtIndex:[sender selectedTag]] objectForKey:@"IODisplayPrefsKey"];
    devDecId = [NSString stringWithFormat:@"%d",[self hex2int:[devId UTF8String]]];
    venDecId = [NSString stringWithFormat:@"%d",[self hex2int:[venId UTF8String]]];
    
    [DeviceID setStringValue:devId];
    
    [DeviceDecID setStringValue:devDecId];
    
    [VendorID setStringValue:venId];
    
    [VendorDecID setStringValue:venDecId];
    
    [DisplayPrefsKey setStringValue:displayPref];
    
    if ([[[DisplayPrefsKey stringValue] lastPathComponent] rangeOfString:@"AppleDisplay"].length > 0)
    {
        [DisplayClassButton selectItemAtIndex:0];
        [OverrideClassButton selectItemAtIndex:0];
        [self SetOverrideAppleDisplay:sender];
        
        displayclass = 1;
    } else if ([[[DisplayPrefsKey stringValue] lastPathComponent] rangeOfString:@"AppleBacklightDisplay"].length > 0) {
        [DisplayClassButton selectItemAtIndex:1];
        [OverrideClassButton selectItemAtIndex:1];
        [self SetOverrideAppleBacklightDisplay:sender];

        displayclass = 2;
    }
}
@end

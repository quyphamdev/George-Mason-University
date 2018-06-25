//
//  ECGSketch.h
//  BluetoothECG
//
//  Created by Quy Pham on 3/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"


@interface ECGSketch : UIViewController <CPPlotDataSource> {
	CPXYGraph *graph;
	NSMutableArray *dataForPlot;
}

-(void)setDataForPlot:(NSMutableArray *)data;

@property(readwrite, retain, nonatomic) NSMutableArray *dataForPlot;

@end

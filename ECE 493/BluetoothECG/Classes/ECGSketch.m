//
//  ECGSketch.m
//  BluetoothECG
//
//  Created by Quy Pham on 3/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ECGSketch.h"


@implementation ECGSketch

@synthesize dataForPlot;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	graph = [[CPXYGraph alloc] initWithFrame:self.view.bounds];
	CPTheme *theme = [CPTheme themeNamed:kCPDarkGradientTheme];
	[graph applyTheme:theme];
	CPLayerHostingView *hostingView = (CPLayerHostingView *)self.view;
	hostingView.hostedView = graph;
	
	graph.paddingLeft = 10.0;
	graph.paddingTop = 10.0;
	graph.paddingRight = 10.0;
	graph.paddingBottom = 10.0;
	
	// Setup plot space
    CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(1.0) length:CPDecimalFromFloat(2.0)];
    plotSpace.yRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(1.0) length:CPDecimalFromFloat(3.0)];
	
    // Axes
	CPXYAxisSet *axisSet = (CPXYAxisSet *)graph.axisSet;
    CPXYAxis *x = axisSet.xAxis;
    x.majorIntervalLength = CPDecimalFromString(@"0.5");
    x.orthogonalCoordinateDecimal = CPDecimalFromString(@"2");
    x.minorTicksPerInterval = 2;
 	NSArray *exclusionRanges = [NSArray arrayWithObjects:
								[CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(1.99) length:CPDecimalFromFloat(0.02)], 
								[CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(0.99) length:CPDecimalFromFloat(0.02)],
								[CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(2.99) length:CPDecimalFromFloat(0.02)],
								nil];
	x.labelExclusionRanges = exclusionRanges;
	
    CPXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength = CPDecimalFromString(@"0.5");
    y.minorTicksPerInterval = 5;
    y.orthogonalCoordinateDecimal = CPDecimalFromString(@"2");
	exclusionRanges = [NSArray arrayWithObjects:
					   [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(1.99) length:CPDecimalFromFloat(0.02)], 
					   [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(0.99) length:CPDecimalFromFloat(0.02)],
					   [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(3.99) length:CPDecimalFromFloat(0.02)],
					   nil];
	y.labelExclusionRanges = exclusionRanges;
	
	// Create a blue plot area
	CPScatterPlot *boundLinePlot = [[[CPScatterPlot alloc] init] autorelease];
    boundLinePlot.identifier = @"Blue Plot";
	boundLinePlot.dataLineStyle.miterLimit = 1.0f;
	boundLinePlot.dataLineStyle.lineWidth = 3.0f;
	boundLinePlot.dataLineStyle.lineColor = [CPColor blueColor];
    boundLinePlot.dataSource = self;
	[graph addPlot:boundLinePlot];
	
	// Do a blue gradient
	CPColor *areaColor1 = [CPColor colorWithComponentRed:0.3 green:0.3 blue:1.0 alpha:0.8];
    CPGradient *areaGradient1 = [CPGradient gradientWithBeginningColor:areaColor1 endingColor:[CPColor clearColor]];
    areaGradient1.angle = -90.0f;
    CPFill *areaGradientFill = [CPFill fillWithGradient:areaGradient1];
    boundLinePlot.areaFill = areaGradientFill;
    boundLinePlot.areaBaseValue = [[NSDecimalNumber zero] decimalValue];
	
	// Add some initial data
	NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:100];
	NSUInteger i;
	for ( i = 0; i < 60; i++ ) {
		id x = [NSNumber numberWithFloat:1+i*0.05];
		id y = [NSNumber numberWithFloat:1.2*rand()/(float)RAND_MAX + 1.2];
		[contentArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
	}
	self.dataForPlot = contentArray;
}

-(void)setDataForPlot:(NSMutableArray *)data {
	self.dataForPlot = data;
}

-(NSUInteger)numberOfRecordsForPlot:(CPPlot *)plot {
    return [dataForPlot count];
}

-(NSNumber *)numberForPlot:(CPPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index 
{
    NSNumber *num = [[dataForPlot objectAtIndex:index] valueForKey:(fieldEnum == CPScatterPlotFieldX ? @"x" : @"y")];
	// Green plot gets shifted above the blue
	if ([(NSString *)plot.identifier isEqualToString:@"Green Plot"])
	{
		if ( fieldEnum == CPScatterPlotFieldY ) 
			num = [NSNumber numberWithDouble:[num doubleValue] + 1.0];
	}
    return num;
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[dataForPlot release];
    [super dealloc];
}


@end

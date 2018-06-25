// Project2.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "math.h"
#include "conio.h"

#define X_SEMIRANGE 3
#define Y_SEMIRANGE 1
#define ROW (Y_SEMIRANGE*20 + 1)
#define COL (X_SEMIRANGE*20 + 1)
#define X_AXIS (Y_SEMIRANGE*10)
#define Y_AXIS (X_SEMIRANGE*10)

char graph[ROW][COL];

// function prototypes
double f(double x);
void init(void);
void printPlot(void);
void initAxis(void);
void initPlotPoints(void);

int _tmain(int argc, _TCHAR* argv[])
{
	// initialize the graph[][] array
	// - x and y axis
	// - plotting points
	init();
	// mapping the graph[][] array to the screen
	printPlot();

	return 0;
}

double f(double x)
{
	//return sin(3*x);
	//return x*x;
	//return cos(x*x);
	return exp(-1/(x*x));
}

void init()
{
	// mapping x and y axis into the graph[][] array
	initAxis();
	// mapping the plotting point into the graph[][] array
	initPlotPoints();
}


void initAxis()
{
	// loop through the graph[][] array
	for(int i=0; i<ROW; i++)
		for(int j=0; j<COL; j++)
		{
			// find the center indexes
			// and mark them as x or y axis w/ char '-' and '|'
			if(i == X_AXIS)
				graph[i][j] = '-';
			else if(j == Y_AXIS)
				graph[i][j] = '|';
			// elsewhere, put space ' ' instead
			else
				graph[i][j] = ' ';
		}
}

// take input as double and then round it up
// then convert it to integer
int roundoff(double x)
{
	int i;
	if (x >= 0)
		i = (int)(x + 0.5);
	else /* i < 0 */
		i = (int)(x - 0.5);
	return i;
}

// take all values on x axis
// then plug in the f() function to get values on y axis
// convert those values (x or y coordinates) into array indexes
// and store char 'o' to the graph[][] array at those indexes
void initPlotPoints()
{
	double yd;
	int y;
	for(int x=-Y_AXIS; x <= Y_AXIS; x++)
	{
		yd = f((double)x/10.0);
		y = roundoff(yd*10);
	
		y = X_AXIS - y;	

		if((y >= 0)&&(y <= ROW))
		{
			graph[y][x+Y_AXIS] = 'o';
		}
	}
}

void printPlot()
{
	for(int i=0; i<ROW; i++)
	{
		for(int j=0; j<COL; j++)
		{
			printf("%c",graph[i][j]);
		}
		printf("\n");
	}
}
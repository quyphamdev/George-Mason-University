#-------------------------------------------------------------------------------
# Quy_Pham_206_PA1.py
# Student Name: Quy Pham
# Assignment: Lab #1
# Submission Date: 01/28/2010
#-------------------------------------------------------------------------------
# Honor Code Statement: I received no assistance on this assignment that
# violates the ethical guidelines as set forth by the
# instructor and the class syllabus.
#-------------------------------------------------------------------------------
# References: (list of web sites, texts, and any other resources used)
#	- http://docs.python.org/tutorial/index.html
#-------------------------------------------------------------------------------
# Comments: (a note to the grader as to any problems or uncompleted aspects of
# of the assignment)
#	- Code checked and compiled
#-------------------------------------------------------------------------------
# pseudocode
#-------------------------------------------------------------------------------
# Getting user input by using input() function for:
# 	- Principal amount (save to variable P)
#	- Rate of interest in % (save to variable R)
#	- Time duration (save to variable Y)
#	- Number of additional months (save to variable M)
# 		(execute a loop check on M < 12)
# Calculate the Simple and Compound Interest with the provided formulars
#	N = Y + M /12
#	r = R/100
#	SimpleInterest = P *N * r
#	CompoundInterest = P(1+ r)^N - P
# Print the results out to screen
#	- Round up the results with round() function to 2 decimals
#-------------------------------------------------------------------------------
# NOTE: width of source code should be < 80 characters to facilitate printing
#-------------------------------------------------------------------------------


# define main() function
def main():
	# getting user inputs
	P = input("Enter principal amount, P = ")
	R = input("Enter rate of interest in % (per annum), R = ")
	Y = input("Enter time duration in number of year, Y = ")
	M = input("Enter Number of additional Months (< 12), M = ")
	# M should be no more than 12. Keep asking for value of M if input > 12
	while (M > 12):
		M = input("Enter Number of additional Months (< 12), M = ")
	# calculating simple and compound interest
	N = Y + M/12.0	# time period in year
	r = R/100.0
	SimpleInterest = P*N*r
	CompoundInterest = P*((1.0+r)**N) - P
	# print out results with numbers are rounded up to 2 decimal points
	print "Simple Interest: ", round(SimpleInterest,2)
	print "Compound Interest: ", round(CompoundInterest,2)

# call main() function
main()


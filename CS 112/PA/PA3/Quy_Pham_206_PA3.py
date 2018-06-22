#-------------------------------------------------------------------------------
# Quy_Pham_206_PA3.py
# Student Name: Quy Pham
# Assignment: Lab #3
# Submission Date: 02/26/2010
#-------------------------------------------------------------------------------
# Honor Code Statement: I received no assistance on this assignment that
# violates the ethical guidelines as set forth by the
# instructor and the class syllabus.
#-------------------------------------------------------------------------------
# References: (list of web sites, texts, and any other resources used)
#	- http://docs.python.org/tutorial/index.html
#	- PA3
#-------------------------------------------------------------------------------
# Comments: (a note to the grader as to any problems or uncompleted aspects of
# of the assignment)
#	- Code checked and compiled
#-------------------------------------------------------------------------------
# pseudocode
#-------------------------------------------------------------------------------
# - Print out main menu, let user choose either 2 option below (handle invalid input)
# 	1) Interest calculation
#	2) exit
# - If user chooses option 2, notify that program is about to terminated
# - If user chooses option 1:
#	+ Take input value for principle, rate, number of year and additional month (handle invalid input)
#	+ Print out submenu with:
#		1) calculate simple interest
#		2) calculate compound interest for each month
#	+ Perform conversions before calculate each options above
#		N = Year + AdditionalMonth/12.0
#		r = RateInterest/100.0
#	+ If user chooses option 1, use this formula to calculate and print out result:
#		SimpleInterest = Principle*N*r
#	+ If user chooses option 2, use this formula to calculate and print out result:
#		CompoundInterest = (Principle*((1.0+r)**Month) - Principle)
#		MonthlyCompoundInterest = CompoundInterest - LastCompoundInterest
# - Loop through the above steps until the user chooses to exit
#-------------------------------------------------------------------------------
# NOTE: width of source code should be < 80 characters to facilitate printing
#-------------------------------------------------------------------------------

# define main() function
def main():
	loop = 1
	while (loop):
		# main menu
		print " "
		print "Main menu: "
		print "1) Interest Calculation"
		print "2) Exit"
		resp = input("Choose menu item with corresponding number: ")
		while (resp != 1 and resp != 2):
			resp = input("Invalid. Choose menu item with corresponding number: ")
			
		if (resp == 1): # option 1 - interest calculation
			# getting user inputs
			Principle = input("Enter principal amount, P = ")
			RateInterest = input("Enter rate of interest in % (per annum), R = ")
			Year = input("Enter time duration in number of year, Y = ")
			AdditionalMonth = input("Enter Number of additional Months (< 12), M = ")
			# M should be no more than 12. Keep asking for value of M if input > 12
			while (AdditionalMonth > 12):
				AdditionalMonth = input("Enter Number of additional Months (< 12), M = ")
			
			print " "
			print "Submenu - Select one: "
			print "1) Calculate Simple Interest"
			print "2) Calculate Compound Interest Detail for each month"
			resp = input("Choose menu item with corresponding number: ")
			while (resp != 1 and resp != 2): # handle invalid input
				resp = input("Invalid. Choose menu item with corresponding number: ")
			
			# appropriate conversions
			N = Year + AdditionalMonth/12.0
			r = RateInterest/100.0
			
			if (resp == 1): # chose option 1 cal simple interest				
				SimpleInterest = Principle*N*r
				# print out results with numbers are rounded up to 2 decimal points
				print "Simple Interest: ", round(SimpleInterest,2)
			
			else: # cal monthly compound interest
				Month = 1
				MonthPeriod = Year*12.0 + AdditionalMonth
				LastCompoundInterest = 0
				while (Month <= MonthPeriod): # print out interest of each month					
					CompoundInterest = (Principle*((1.0+r)**Month) - Principle)
					MonthlyCompoundInterest = CompoundInterest -LastCompoundInterest 					
					print "%i) %.2f" %(Month, MonthlyCompoundInterest)
					Month += 1
					LastCompoundInterest = CompoundInterest
					
			
		else: # resp = 2
			print "Program terminated..."
			loop = 0
		
	

# call main() function
main()


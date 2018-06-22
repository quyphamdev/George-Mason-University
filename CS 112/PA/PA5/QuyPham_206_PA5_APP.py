#-------------------------------------------------------------------------------
# Quy_Pham_206_PA5_APP.py
# Student Name: Quy Pham
# Assignment: Lab #4
# Submission Date: 04/01/2010
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
# - Prompt for first term, last term and common difference
# - Call NumberOfTerm() function to calculate the numbers of term
# - Call SumOfSeq() function to calculate the sum of sequence
# - Print out the result
#-------------------------------------------------------------------------------
# NOTE: width of source code should be < 80 characters to facilitate printing
#-------------------------------------------------------------------------------

from QuyPham_206_PA5_UTIL import *

# function definition
def main():
	# prompt for first term, last term and common difference
	first_term,last_term,common_diff = input("Enter first term, last term, and common different:")
	# call NumberOfTerm() function to calculate the numbers of term
	num_of_term = NumberOfTerm(first_term,last_term,common_diff)
	# call SumOfSeq() function to calculate the sum of sequence
	sum_of_seq = SumOfSeq(first_term,last_term,num_of_term)
	# print out the result
	print "Sum of the sequence = ", sum_of_seq

# call main()
main()


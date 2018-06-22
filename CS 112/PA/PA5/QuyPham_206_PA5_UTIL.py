#-------------------------------------------------------------------------------
# Quy_Pham_206_PA5_UTIL.py
# Student Name: Quy Pham
# Assignment: Lab #5
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
# - 
#-------------------------------------------------------------------------------
# NOTE: width of source code should be < 80 characters to facilitate printing
#-------------------------------------------------------------------------------

# Function definitions
# Calculate the number of terms
#	Inputs: first term, last term and common difference
#	Output: the numbers of term
def NumberOfTerm(first_term, last_term, common_diff):
	return (last_term-first_term)/common_diff + 1
	
# Calculate the sum of the sequence
#	Inputs: first term, last term and numbers of term
#	Output: the sum of sequence
def SumOfSeq(first_term, last_term, num_of_term):
	return (first_term + last_term)*(num_of_term/2)
	


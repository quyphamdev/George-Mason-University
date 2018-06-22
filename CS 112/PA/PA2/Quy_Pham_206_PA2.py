#-------------------------------------------------------------------------------
# Quy_Pham_206_PA2.py
# Student Name: Quy Pham
# Assignment: Lab #2
# Submission Date: 02/09/2010
#-------------------------------------------------------------------------------
# Honor Code Statement: I received no assistance on this assignment that
# violates the ethical guidelines as set forth by the
# instructor and the class syllabus.
#-------------------------------------------------------------------------------
# References: (list of web sites, texts, and any other resources used)
#	- http://docs.python.org/tutorial/index.html
#	- PA2
#-------------------------------------------------------------------------------
# Comments: (a note to the grader as to any problems or uncompleted aspects of
# of the assignment)
#	- Code checked and compiled
#-------------------------------------------------------------------------------
# pseudocode
#-------------------------------------------------------------------------------
# - Request user input for the length of the chord of a circle
# - Calculate:
#	+ The angle subtended (in degrees)
# 		AM = chord/2
# 		AO = r
#		AOM_angle = asin(AM / AO)
# 		AOB_angle = 2 * AOM_angle
# 	+ The length of Major Arc
# 		Circumference = C = 2 * pi * r
# 		Minor Arc = (AOB_angle/360) * C
#	+ The length of Minor Arc
# 		Major Arc = C - Minor Arc
# - Print out the results
#-------------------------------------------------------------------------------
# NOTE: width of source code should be < 80 characters to facilitate printing
#-------------------------------------------------------------------------------

from math import *

#define main() function
def main():
	# radius
	r = input("Enter radius of a circle, r = ")
	d = 2.0*r
	# circumference
	C = 2*r*pi	
	# user input length of the chord of a circle
	chord = input("Enter the length of the chord of a circle: ")
	while (chord > d):
		chord = input("Chord should be <= %.1f " %(d))
	# calulate angle subtended by this chord
	AM = chord/2.0
	AOM_angle = asin(AM/r)
	AOB_angle = 2.0*AOM_angle
	# asin() output angle in radian, we need it in degree
	AOB_angle = degrees(AOB_angle)
	# calulate minor arc
	AB_minor_arc = (AOB_angle/360.0)*C
	# calculate major arc
	AB_major_arc = C - AB_minor_arc
	# print out results
	print "Circle with r=%.1f, C=%.1f, chord=%.1f, has:\n" %(r,C,chord)
	print "Subtended angle AOB=%.1f (in degree)\n" %(AOB_angle)
	print "Major arc = %.2f\n" %(AB_major_arc)
	print "Minor arc = %.2f\n" %(AB_minor_arc)
	
# call main()
main()


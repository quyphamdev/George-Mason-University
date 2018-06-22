#-------------------------------------------------------------------------------
# Quy_Pham_206_PA6.py
# Student Name: Quy Pham
# Assignment: Lab #6
# Submission Date: 04/06/2010
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
# Questions
#-------------------------------------------------------------------------------
# 1) When is __init__ methods invoked?
#	It is invoked when an instance of a class is created
# 2) How can you access the instance variables of Complex (real and imaginary)?
# (within and outside the class)
#	+ Within the class: self.real and self.imaginary
#	+ Outside the class: instance_of_complex.real and instance_of_complex.imagniary
# 3) How do you access the class level variable? (within and outside the class)
#	+ Within the class: self
#	+ Outside the class: class_name_variable
# 4) Instance variables are associated with an object of a class, so they exist
# only when an object of the class exists, is the same true for class level variables?
#	No. A static class can be accessed without its instance is created
#-------------------------------------------------------------------------------
# NOTE: width of source code should be < 80 characters to facilitate printing
#-------------------------------------------------------------------------------

from math import *

class Complex(object):

	#class variable
	count = 0
	real = 0
	imag = 0

	#incomplete
	def __init__(self,real,imag):
		print "creating complex ... "
		#complete the definition of this method 
		#by creating two instance variables with the names
		#real and imag
		self.real = real
		self.imag = imag
		#also increment the class variable count
		Complex.count += 1
		
	#incomplete
	def  conjugate(self):
		self.imag = -1*self.imag
		#HINT:something in the parameters is missing
		# -> need to pass in 'self'
		#NOTE:this method modifies the attribute of the class
		#and does not return anything
		
	#incomplete	
	def absolute(self):
		return sqrt(pow(self.real,2) + pow(self.imag,2))
		#this method always returns a 0 
		#modify the implementations so that 
		#it returns the absolute value of this complex number
	
	
	#incomplete
	def __str__(self):
		#this method is called whenever str(obj) is called on the
		#object of this class
		return "{0}{1:+}j".format(self.real,self.imag)
		#your implementation should return a string of the format
		# 8 + 9j for Complex(8,9) and 
		# 8 - 9j for Complex(8,-9)
		# notice the sign change 
		# HINT: you can use str.format() for a single line implementation

	#complete - example implementation do not modify		
	def __mul__(self,other):
		real = self.real*other.real - self.imag*other.imag
		imag = self.real*other.imag + self.imag*other.real
		return Complex(real,imag)
	
	#incomplete 
	def __add__(self,other):
		#using the __mul__ method as template
		#implement this method which return the 
		#sum of two complex numbers
		real = self.real + other.real
		imag = self.imag + other.imag
		return Complex(real,imag)

	#incomplete 	
	def __div__(self,other):
		#using the __mul__ method as template
		#implement this method which return the 
		#quotient of two complex numbers
		temp = Complex(other.real,other.imag)
		temp.conjugate()
		nominator = self*temp
		denominator = other.real*other.real + other.imag*other.imag
		real = nominator.real/denominator
		imag = nominator.imag/denominator
		del temp
		del nominator
		return Complex(real,imag)
	
	#complete - example implementation do not modify
	def __del__(self):
		print "deleting complex ..."
		Complex.count -= 1
		
		#this method is invoked whenever del is called
		#on the object reference or whenever the object is
		#automatically destroyed by python
		

#complete - do not modify
def main():

	#print count
	print "Complex.count before creating any complex objects =",Complex.count	
	
	#creating complex numbers
	c1 = Complex(8,9)
	print "{0} created".format(c1)
	c2 = Complex(3,4)
	print "{0} created".format(c2)

	#print count
	print "Complex.count after creating {0} and {1} = {2}".format(c1,c2,Complex.count)
	
	#addition
	c3 = c1 + c2
	print "{0} + {1} = {2}".format(c1,c2,c3)
	
	
	#multiplication
	c4 = c3*c1
	print "{0} * {1} = {2}".format(c3,c1,c4)
	
	#division
	c5 = Complex(8,1)
	c6 = Complex(2,-1)
	c7 = c5/c6
	print "{0} / {1} = {2}".format(c5,c6,c7)
	
	#conjugate modifies the number 
	print "before conjugate()", c1
	c1.conjugate()
	print "after conjugate()", c1
	
	
	#absolute value
	print "absolute value of",c1, "is",c1.absolute()
	
	
	#print count
	print "count of complex numbers is",Complex.count
	
	del c4
	print "count after deleting a complex number", Complex.count
	

main()
		



	

	
		
		
	

	
		
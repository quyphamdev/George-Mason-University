#-------------------------------------------------------------------------------
# Quy_Pham_206_PA7.py
# Student Name: Quy Pham
# Assignment: Lab #7
# Submission Date: 04/11/2010
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
# Error scenarios:
# - Input number:
#	+ Contains whitespace at beginning and endding or in between numbers
#	+ Contains other characters other than numbers
#	+ Contains more than one decimal point
#	+ Decimal point should only be in between numbers, not begin or end of it
#	+ Negative number with only one negative sign '-'
# - Input operator:
#	+ Contains other character other than +,-,*,/,**,%
#	+ Contains whitespace
#-------------------------------------------------------------------------------
# NOTE: width of source code should be < 80 characters to facilitate printing
#-------------------------------------------------------------------------------

from Tkinter import *

class CustomFrame(Frame):
	def __init__(self, root):
		Frame.__init__(self, root)
		# default values
		self.setup_interface()
		
	def setup_interface(self):
		# labels
		self.l_op1 = Label(self, text="Operand1")
		self.l_op = Label(self, text="Operator")
		self.l_op2 = Label(self, text="Operand2")
		self.l_result = Label(self, text="Result")
		# variables for entries
		self.v_op1 = StringVar(self, "0.0")
		self.v_op = StringVar(self, '+')
		self.v_op2 = StringVar(self, "0.0")
		self.v_result = StringVar(self, "0.0")
		# set up entries
		self.en_op1 = Entry(self, textvariable = self.v_op1)
		self.en_op = Entry(self, textvariable = self.v_op)
		self.en_op2 = Entry(self, textvariable = self.v_op2)
		self.en_result = Entry(self, textvariable = self.v_result)
		# set up buttons and their event handlers
		self.b_clear = Button(self, text="Clear", command=self.b_clear_press)
		self.b_execute = Button(self, text="Execute", command=self.b_execute_press)
		# laying out widgets using grid
		# labels
		self.l_op1.grid(row=0, column=0)
		self.l_op.grid(row=0, column=1)
		self.l_op2.grid(row=0, column=2)
		self.l_result.grid(row=0, column=3)
		# entries
		self.en_op1.grid(row=1, column=0)
		self.en_op.grid(row=1, column=1)
		self.en_op2.grid(row=1, column=2)
		self.en_result.grid(row=1, column=3)
		# buttons
		self.b_clear.grid(row=2, column=0, columnspan=2)
		self.b_execute.grid(row=2, column=2, columnspan=2)
		
	# event handler for clear button
	def b_clear_press(self):
		self.v_op1.set("0.0")
		self.v_op.set("+")
		self.v_op2.set("0.0")
		self.v_result.set("0.0")
		
	# event handler for execute button
	def b_execute_press(self):
		# error handling
		# check for valid input numbers
		if self.check_valid_num(self.v_op1.get()) == False:
			self.v_result.set("Invalid Operand 1")
			return
		if self.check_valid_num(self.v_op2.get()) == False:
			self.v_result.set("Invalid Operand 2")
			return
		# check for valid input operator
		if self.check_valid_op(self.v_op.get()) == False:
			self.v_result.set("Invalid Operator")
			return
		# calculation
		op = self.v_op.get()
		# remove front and back whitespace
		op = op.lstrip()
		op = op.rstrip()
		# remove front and back whitespace
		op1 = self.v_op1.get()
		op1 = op1.lstrip()
		op1 = op1.rstrip()
		op2 = self.v_op2.get()
		op2 = op2.lstrip()
		op2 = op2.rstrip()
		# convert from string to float nums
		op1 = float(op1)
		op2 = float(op2)
		if op == '+':
			r = op1 + op2
		elif op == '-':
			r = op1 - op2
		elif op == '*':
			r = op1 * op2
		elif op == '/':
			r = op1 / op2
		elif op == '**': # power
			r = op1 ** op2
		elif op == '%': # modulus
			r = op1 % op2
		# show final result
		self.v_result.set(str(r))
		
		
	# Check the input number is valid.
	# It should contain only numbers and may be decimal point
	# There should be only one decimal point and in between numbers
	# There shouldn't be space between numbers too
	def check_valid_num(self, s):
		# remove front and back whitespace
		s = s.lstrip()
		s = s.rstrip()
		if (s[0] == '.') | (s[-1] == '.'):
			return False
		elif s.count('.') > 1:
			return False
		else:
			s = s.replace('.','')
			if s[0] == '-': # negative number
				s = s[1:] # remove that sign out
			return s.isdigit()
			
		return True
		
	# Check for the input of the operator
	# The input operator is one of +,-,*,/,**,%
	def check_valid_op(self, s):
		operators = ('+','-','*','/','**','%')
		# remove front and back whitespace
		s = s.lstrip()
		s = s.rstrip()
		if s not in operators:
			return False
		return True
		
	
root = Tk()
f = CustomFrame(root)
f.pack()
root.title('Calculator')
root.mainloop()


#-------------------------------------------------------------------------------
# Quy_Pham_206_PP2.py
# Student Name: Quy Pham
# Assignment: Project Assignment #2
# Submission Date: 05/5/2010
#-------------------------------------------------------------------------------
# Honor Code Statement: I received no assistance on this assignment that
# violates the ethical guidelines as set forth by the
# instructor and the class syllabus.
#-------------------------------------------------------------------------------
# References: (list of web sites, texts, and any other resources used)
#	- http://docs.python.org/tutorial/index.html
#	- PAs
#	- Lecture slices
#-------------------------------------------------------------------------------
# Comments: (a note to the grader as to any problems or uncompleted aspects of
# of the assignment)
#	- Code checked and compiled
#-------------------------------------------------------------------------------
# pseudocode
#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------
# NOTE: width of source code should be < 80 characters to facilitate printing
#-------------------------------------------------------------------------------

class GomokuClass(object):
	
	# constructor
	def __init__(self):
		print "Creating GomokuClass..."
		# dimension
		self.dim = 15
		# create a 2-Dimensional list 15x15, init w/ all '_'
		self.board = ['_']*self.dim*self.dim
		#self.board = [self.board]*self.dim
		# current row and column
		self.row = -1
		self.col = -1
		# a list for keep track of player turn and stone's position
		# for undo functionality
		self.history = [''] # at first, no move yet so it's empty
		# current player (black/white)
		self.curPlayer = 0 # black, 1=white
		# current winner
		self.winner = -1 # -1=tie, 0=black, 1=white
		
		
	# player places a stone on a game cell, the handler will call this func
	# w/ row and column
	# Return: 	-1: invalid move
	#		0/1: winner
	#		2: valid move
	def addMove(self, row, col):
		# no piece at this position yet
		if self.board[row*self.dim+col] == '_':
			# mark it w/ current player id (black/white)
			self.board[row*self.dim+col] = self.curPlayer
			# save position to history for undo later
			self.history.append([row,col])
			# save for later use
			self.row = row
			self.col = col
		else:
			return -1 # invalid, has piece already
		
		# switch player's turn
		if self.curPlayer == 0:
			self.curPlayer = 1
		else:
			self.curPlayer = 0
			
		# check if this is a winner's move
		if self.checkWinner(row,col) != 2:
			return self.board[row*self.dim+col]
		
		return 2 # valid move
	
	# return 0/1: winner (black/white)
	#	 2: no winner yet (tie)
	def checkWinner(self,row,col):
		# determine left,right,top,bottom border around the cur position
		left = col-4
		if left < 0:
			left = 0
		right = col+4
		if right > (self.dim-1):
			right = self.dim-1
		top = row-4
		if top < 0:
			top = 0
		bottom = row+4
		if bottom > (self.dim-1):
			bottom = self.dim-1
		# start checking...
		# ..from left to right
		i = left
		while (i+4) <= right:
			if (self.board[row*self.dim+col]==self.board[row*self.dim+i])\
				and(self.board[row*self.dim+col]==self.board[row*self.dim+i+1])\
				and(self.board[row*self.dim+col]==self.board[row*self.dim+i+2])\
				and(self.board[row*self.dim+col]==self.board[row*self.dim+i+3])\
				and(self.board[row*self.dim+col]==self.board[row*self.dim+i+4]):
					return self.curPlayer # found a winner
			i = i+1
		# ..from top to bottom
		j = top
		while (j+4) <= bottom:
			if (self.board[row*self.dim+col]==self.board[j*self.dim+col])\
				and(self.board[row*self.dim+col]==self.board[(j+1)*self.dim+col])\
				and(self.board[row*self.dim+col]==self.board[(j+2)*self.dim+col])\
				and(self.board[row*self.dim+col]==self.board[(j+3)*self.dim+col])\
				and(self.board[row*self.dim+col]==self.board[(j+4)*self.dim+col]):
					return self.curPlayer # found a winner
			j = j+1
		# ..from upper left to bottom right
		i = top
		j = left
		while ((i+4)<=bottom) and ((j+4)<=right):
			if (self.board[row*self.dim+col]==self.board[i*self.dim+j])\
				and(self.board[row*self.dim+col]==self.board[(i+1)*self.dim+j+1])\
				and(self.board[row*self.dim+col]==self.board[(i+2)*self.dim+j+2])\
				and(self.board[row*self.dim+col]==self.board[(i+3)*self.dim+j+3])\
				and(self.board[row*self.dim+col]==self.board[(i+4)*self.dim+j+4]):
					return self.curPlayer # found a player
			i = i+1
			j = j+1
		# ..from lower left to upper right
		i = bottom
		j = left
		while ((i-4)>=top) and ((j+4)<=right):
			if (self.board[row*self.dim+col]==self.board[i*self.dim+j])\
				and(self.board[row*self.dim+col]==self.board[(i-1)*self.dim+j+1])\
				and(self.board[row*self.dim+col]==self.board[(i-2)*self.dim+j+2])\
				and(self.board[row*self.dim+col]==self.board[(i-3)*self.dim+j+3])\
				and(self.board[row*self.dim+col]==self.board[(i-4)*self.dim+j+4]):
					return self.curPlayer
			i = i-1
			j = j+1
		# no winner yet
		return 2
		
	def undo(self):
		size = len(self.history)
		if size > 1: # first item is ['']
			# remove from history list
			[row,col] = self.history.pop()
			# change current player to last player
			self.curPlayer = self.board[row*self.dim+col]
			# remove the last move from board[][]
			self.board[row*self.dim+col] = '_'
			# save last position for later use (not sure when)
			#[self.row,self.col] = self.history[size-1]
			# return the removed move
			return [row,col]
			
		# nothing to undo
		return [-1,-1]
		
	def reset(self):
		self.board = ['_']*self.dim*self.dim
		self.history = ['']
		self.row = -1
		self.col = -1
		self.winner = -1
		self.curPlayer = 0 # first player
		
	

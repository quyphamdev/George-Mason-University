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

from Tkinter import *
import tkMessageBox
from QuyPham_206_PP2_CLASS import *

class GomokuGUI(Frame):
	
	def __init__(self, root):
		Frame.__init__(self, root)
		self.dim = 15
		self.board = []
		self.gomokuClass = GomokuClass()
		self.setup_interface()
		
	def setup_interface(self):
		self.cell_img = PhotoImage(file="cell.gif")
		self.black_img = PhotoImage(file="black.gif")
		self.white_img = PhotoImage(file="white.gif")
		# game board using buttons
		for i in range(self.dim):
			for j in range(self.dim):
				cell = Button(self, image=self.cell_img)
				cell.bind("<Button-1>", self.onBoardClick)
				cell.config(borderwidth=0,bg="yellow",relief=FLAT)
				cell.grid(row=i, column=j)
				self.board.append(cell)
				
		# labels
		lbl = Label(self, text="Current Player: ")
		lbl.grid(row=2, column=17)
		lbl = Label(self, text="Last Winner: ")
		lbl.grid(row=4, column=17)
		# label for showing current player
		self.l_curPlayer = StringVar(self, "Black")
		lbl = Label(self, textvariable=self.l_curPlayer)
		lbl.grid(row=2, column=18)
		# label for showing the winner
		self.l_winner = StringVar(self, "______")
		lbl = Label(self, textvariable=self.l_winner)
		lbl.grid(row=4, column=18)
		# control buttons
		# Reset button
		btn = Button(self, text="Reset")
		btn.bind("<Button-1>", self.onCtrlBtnClick)
		btn.grid(row=7, column=17, columnspan=2)
		# undo button
		btn = Button(self, text="Undo")
		btn.bind("<Button-1>", self.onCtrlBtnClick)
		btn.grid(row=9, column=17, columnspan=2)
		# quit button
		btn = Button(self, text="Quit")
		btn.bind("<Button-1>", self.onCtrlBtnClick)
		btn.grid(row=11, column=17, columnspan=2)
		
		
		
	def onBoardClick(self, event):
		cell = event.widget
		# get grid info of which this widget belong to
		dict_btn_grid = cell.grid_info()
		# this is a dictionary type
		# get row and column of this widget
		row = int(dict_btn_grid["row"])
		col = int(dict_btn_grid["column"])
		print "row="+str(row)+" ,col="+str(col)
		# save position to GomokuClass
		fb = self.gomokuClass.addMove(row,col)
		print fb
		if fb == -1: # already has stone there
			return # do nothing
		else: # fb == 2/0/1, valid move or found a winner
			# put in an image of current player's stone
			if self.gomokuClass.curPlayer == 0:
				cell.config(image=self.white_img)
				self.l_curPlayer.set("Black")
			else:
				cell.config(image=self.black_img)
				self.l_curPlayer.set("White")
			
			if fb == 0: # black wins
				tkMessageBox.showinfo("Game End", "Black wins !!")
				self.reset() # reset the game
				self.l_winner.set("Black") # but still show the last winner
			elif fb == 1: # white wins
				tkMessageBox.showinfo("Game End", "White wins !!")
				self.reset() # reset the game
				self.l_winner.set("White") # but still show the last winner
			
		
		
	def onCtrlBtnClick(self, event):
		text = event.widget["text"]
		if text == "Reset":
			print "Reset clicked"
			self.reset()
			
		elif text == "Undo":
			print "Undo clicked"
			self.undo()
			
		else: # Quit
			print "Quit"
			sys.exit()
			
	def reset(self):
		# reset for GUI
		for i in range(self.dim):
			for j in range(self.dim):
				self.board[i*self.dim+j].config(image=self.cell_img)
				
		self.l_curPlayer.set("Black")
		self.l_winner.set("______")
		# reset for GomokuClass
		self.gomokuClass.reset()
		
	def undo(self):
		# get last move
		[row,col] = self.gomokuClass.undo()
		print row,col
		if (row==-1): # nothing to undo
			return
		# remove stone from game board
		self.board[row*self.dim+col].config(image=self.cell_img)
		if self.gomokuClass.curPlayer == 0:
			self.l_curPlayer.set("Black")
		else:
			self.l_curPlayer.set("White")
	
	
root = Tk()
f = GomokuGUI(root)
f.pack()
root.title("GOMOKU")
root.mainloop()


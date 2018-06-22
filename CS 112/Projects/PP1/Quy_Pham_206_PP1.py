#-------------------------------------------------------------------------------
# Quy_Pham_206_PP1.py
# Student Name: Quy Pham
# Assignment: Project Assignment #1
# Submission Date: 03/08/2010
#-------------------------------------------------------------------------------
# Honor Code Statement: I received no assistance on this assignment that
# violates the ethical guidelines as set forth by the
# instructor and the class syllabus.
#-------------------------------------------------------------------------------
# References: (list of web sites, texts, and any other resources used)
#	- http://docs.python.org/tutorial/index.html
#	- PA1,2,3
#	- Lecture slices
#-------------------------------------------------------------------------------
# Comments: (a note to the grader as to any problems or uncompleted aspects of
# of the assignment)
#	- Code checked and compiled
#-------------------------------------------------------------------------------
# pseudocode
#-------------------------------------------------------------------------------
# - Take input from user for a string which is to be encoded
# - Create an unique prefixes list and initalize it with empty string
# - Create an empty encoding list
# - Encoding procedure:
#	 - Scan through the input string, each character at a time to find 
#	   a new prefix
#		+ Check if it is in unique prefixes list. If not, save it to 
#		  the list
#		+ If the character is already in the unique prefixes, take the 
#		  next character and concatinate with the current
#		  Go back previous step
#		+ Divide the prefix into 2 parts: the last character and the 
#		  remainder of the prefix string
#		+ Find the index of the remainder in the unique prefixes list
#		+ Create a tuple of the index and the last character and append 
#		  it to the encoding list
#		+ Keep doing the above steps for the whole input string
#		+ For the last scanning prefix, if it is in the uniquie prefixes
#		  list, then make the prefix as the remainder and the 
#		  last character as empty string
#	- Convert the encoding list into string of binary for each element in
#	  each tuple
#		+ The length of the binary string of the indexes are different
#		  for each tuple in the encoding list and are calculated with:
#			floor(tuple_index/2) + 1
#		  Where the tuple index is the index of the processing tuple
#		  in the encoding list
#		+ The length of the binary string of the character is 8 for all
#		+ If any of the above is less than the require length, pad it
#		  with zeroes ('0') to make it full
#	- Concatenate all the element in the encoding list after the above
#	  conversion to generate a encoded string (with all '0' and '1')
# - Decoding procedure:
#	- Reverse all the steps in the encoding procedure with the unique
#	  prefixes list initialize with an empty string
#		+ Depends on the index of the tuple which we are decoding, 
#		  we can determine how many bits in the encoded string needed
#		  to be extracted for the index, by using the same formula above:
#			floor(tuple_index/2) + 1
#		+ The length of character is always 8 bits
#		+ Each decoded unique prefix should be added to the unique
#		  prefixes list for the next decoding
#-------------------------------------------------------------------------------
# NOTE: width of source code should be < 80 characters to facilitate printing
#-------------------------------------------------------------------------------

#import binascii
from math import *

# define main() function
def main():
	inputStr = raw_input("Enter a string for encoding: ")
	prefix = ''
	uniquePrefixes = ['']
	encodingList = []
	for c in inputStr: # take each char at a time
		# append to previous char(s) to form an unique prefix
		prefix = prefix + c
		# found an unique prefix
		if prefix not in uniquePrefixes:
			# add it to the list
			uniquePrefixes.append(prefix)
			# encode the unique prefix
			remainder = prefix[0:-1]
			lastChar = prefix[-1]			
			index = uniquePrefixes.index(remainder)
			encodingTuple = (index,lastChar)
			# add it to encoding list
			encodingList.append(encodingTuple)
			prefix = ''
			
		else: # already in unique prefix list
			# is this the last prefix in inputStr ?
			if prefix == inputStr[len(inputStr)-len(prefix):]:
				remainder = prefix
				lastChar = ''
				index = uniquePrefixes.index(remainder)
				encodingTuple = (index,lastChar)
				encodingList.append(encodingTuple)
				prefix = ''
				
			# else: not the last, keep scanning
		
	print "Unique Prefixes: "
	print uniquePrefixes
	print "Encoding List: "
	print encodingList
	
	# Encode the encoding list into a string of binary
	encodedStr = ''
	encodedList = []
	tupleIndex = 0
	for eachTuple in encodingList:
		# convert index into string of binary
		indexInBinary = bin(eachTuple[0])
		# cut off '0b'
		indexInBinary = indexInBinary.split('0b')[1]
		# calculate number of bits in index bit string
		indexBitLen = int(floor(tupleIndex/2) + 1)
		tupleIndex = tupleIndex + 1
		# pad with zero if index bit string less than the calculated len
		indexInBinary = indexInBinary.rjust(indexBitLen,'0')
		# append it to encoded string
		encodedStr = encodedStr + indexInBinary
		# now convert the character into string of binary and append it too
		charInBinary = ''
		if eachTuple[1] != '':
			charInBinary = bin(ord(eachTuple[1]))
			charInBinary = charInBinary.split('0b')[1]
			# make it 8 bits long by padding it with zero infront
			charInBinary = charInBinary.rjust(8,'0')
			encodedStr = encodedStr + charInBinary
		
		# save encoded string of index and character into a list
		# this makes it easier for checking the result
		encodedList.append((indexInBinary,charInBinary))
		
	print "Encoded List:"
	print encodedList
	print "Encoded String:"
	print encodedStr
	print ''
	
	# decoding process
	tupleIndex = 0
	decodingList = []
	while(len(encodedStr) != 0):
		# extract and convert index binary string into index in decimal number
		indexBitLen = int(floor(tupleIndex/2) + 1)
		indexBinStr = encodedStr[0:indexBitLen]
		index = eval('0b'+indexBinStr)
		encodedStr = encodedStr[indexBitLen:]
		# extract and convert binary string of a character into a string
		char = ''
		if encodedStr != '':
			charBinStr = encodedStr[0:8]
			charAscii = eval('0b'+charBinStr)
			char = chr(charAscii)
			encodedStr = encodedStr[8:]
			
		# put them into a tuple and append it to decoding list
		decodingList.append((index,char))
		# next tuple
		tupleIndex = tupleIndex + 1
		
	print "Decoding List:"
	print decodingList
	
	# reconstruct the unique prefixes and original string
	decodedStr = ''
	uniquePrefixes = ['']
	for eachTuple in decodingList:
		prefix = uniquePrefixes[eachTuple[0]] + eachTuple[1]
		uniquePrefixes.append(prefix)
		decodedStr = decodedStr + prefix
		
	print "Unique Prefixes:"
	print uniquePrefixes
	print "Decoded String:"
	print decodedStr
	

# call main()
main()


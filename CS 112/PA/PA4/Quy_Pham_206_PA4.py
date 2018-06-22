#-------------------------------------------------------------------------------
# Quy_Pham_206_PA4.py
# Student Name: Quy Pham
# Assignment: Lab #4
# Submission Date: 03/23/2010
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
# - Open inventory.dat file
# - Read and map all data into a data structure (Records) with item id is dictionary key
# - Close the file
# - Create a loop doing the following:
#	+ Display menu option for viewing,creating,deleting,editting...
#	+ Prompt user for input for chosen menu option
#	+ Process each choices:
#		- View item: prompt for item id and display
#		- Create item:
#			+ Prompt for item id
#			+ Check if it already exist
#			+ If not exist yet, prompt for name,price and quantity
#			+ Save new item to Records
#		- Delete item: prompt for item id and delete it from Records
#		- Edit item:
#			+ Prompt for item id
#			+ Check if it is in Records
#			+ If it is, delete it from Records
#			+ Prompt for new name,price and quantity
#			+ Save update item with the item id
#		- View inventory:
#			+ If it's empty, display saying so
#			+ If it's not, display all items in Records
#		- Exit:
#			+ Open the inventory.dat file to write (delete all data in it)
#			+ Format each item in Records as: "item_id,name,price,quantity" + "\n"
#			+ Write all items into file with above format
#			+ Close file
#			+ Exit loop to terminate program
#-------------------------------------------------------------------------------
# NOTE: width of source code should be < 80 characters to facilitate printing
#-------------------------------------------------------------------------------

# define main() function
def main():
	records = {}
	# loading all datas in data file into a dictionary
	fp = open("inventory.dat","r")
	file_data = fp.readlines()
	for line in file_data:
		line = line[:-1] # cut off '\n' at the end
		fields = line.split(',') # make a list of all fields
		records[fields[0]] = fields # item id is an ID of each record
		
	fp.close()
	exit = False
	while(exit == False):
		print ''
		print "======= Menu Option ======="
		print "1. View Item"
		print "2. Create Item"
		print "3. Delete Item"
		print "4. Edit Item"
		print "5. View Inventory"
		print "6. Exit"
		print "==========================="
		user_input = input("Enter menu item number: ")
		if user_input == 1: # view item
			loop = True
			while(loop):
				print ''
				print 'To go back to Menu Option, leave blank and press Enter'
				item_id = raw_input("Enter Item Id: ")
				if item_id == '': # if user not entering anything, and press Enter
					loop = False # exit to Menu Option
				elif item_id in records:
					# display item
					record = records[item_id]
					print '--------------------'
					print 'Item Id: ', record[0]
					print 'Name: ', record[1]
					print 'Price: ', record[2]
					print 'Quantity: ', record[3]
					print '--------------------'
				else:
					print "Item is not in records !!"
				
			
		elif user_input == 2: # create item
			loop = True
			while(loop):
				print ''
				print 'To go back to Menu Option, leave blank and press Enter'
				item_id = raw_input("New Item id: ")
				if item_id == '': # if user not entering anything, and press Enter
					loop = False # exit to Menu Option
				elif item_id in records:
					print 'Item Id is already in records !!'
				else:
					# prompt for new item
					name = raw_input('Item Name: ')
					price = raw_input('Item Price: ')
					quantity = raw_input('Item Quantity: ')
					record = list([item_id,name,price,quantity])
					# add new item to records
					records[item_id] = record
			
		elif user_input == 3: # delete item
			loop = True
			while(loop):
				print ''
				print 'To go back to Menu Option, leave blank and press Enter'
				item_id = raw_input("Item id to delete: ")
				if item_id == '': # if user not entering anything, and press Enter
					loop = False # exit to Menu Option
				elif item_id not in records:
					print 'Item Id is not in records !!'
				else:
					# delete item from records
					record = records.pop(item_id)
					# display deleted item
					print '-----Deleted Item-----'
					print 'Item Id: ', record[0]
					print 'Name: ', record[1]
					print 'Price: ', record[2]
					print 'Quantity: ', record[3]
					print '--------------------'
					
			
		elif user_input == 4: # edit item
			loop = True
			while(loop):
				print ''
				print 'To go back to Menu Option, leave blank and press Enter'
				item_id = raw_input("Item id to edit: ")
				if item_id == '':# if user not entering anything, and press Enter
					loop = False # exit to Menu Option
				elif item_id not in records:
					print 'Item Id is not in records !!'
				else:
					# take item out of records
					record = records.pop(item_id)
					# display it
					print '-----Editing Item-----'
					print 'Item Id: ', record[0]
					print 'Name: ', record[1]
					print 'Price: ', record[2]
					print 'Quantity: ', record[3]
					print '--------------------'
					# prompt for updated fields
					name = raw_input('Item Name: ')
					price = raw_input('Item Price: ')
					quantity = raw_input('Item Quantity: ')
					record = list([item_id,name,price,quantity])
					# save updated item to records
					records[item_id] = record
					# display it
					print '-----Updated Item-----'
					print 'Item Id: ', record[0]
					print 'Name: ', record[1]
					print 'Price: ', record[2]
					print 'Quantity: ', record[3]
					print '--------------------'
			
		elif user_input == 5: # view inventory
			if records != {}: # not empty, display all items in inventory
				for record in records.values():
					print '-----', record[0],'-----'
					print 'Name: ', record[1]
					print 'Price: ', record[2]
					print 'Quantity: ', record[3]
					print '--------------------'
					
			else: # inventory is empty
				print 'Inventory is empty !!'
			
		elif user_input == 6: # saved updated data to file and exit
			fp = open('inventory.dat', 'w')
			for record in records.values():
				line = ''
				for field in record:
					# format each record
					line = line + ',' + field
					
				# fix comma at beginning and add new feed line to the end
				line = line[1:] + '\n'
				# save record to file
				fp.write(line)
				
			fp.close() # done, close file
			print "Saved updated data to file and exit"
			exit = True # terminate program
			
	
	
main()


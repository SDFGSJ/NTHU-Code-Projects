import sys

class Record:
    """represent a record"""
    def __init__(self, cate, desc, amount):    #already check elsewhere
        self._category = cate
        self._description = desc
        self._amount = amount
    
    """getter method"""
    @property
    def category(self):
        return self._category
    @property
    def description(self):
        return self._description
    @property
    def amount(self):
        return self._amount

    """overloads '==' operator"""
    def __eq__(self, rhs):
        return self.category == rhs.category and self.description == rhs.description and self.amount == rhs.amount


class Records:
    """Maintain a list of Records and the initial amount of money."""
    def __init__(self):
        self._mymoney = 0
        self._expense_list = []   #a list of Record object
        self._cost_list = []  #a list of int
        try:
            with open("myrecord.txt",'r') as fh:
                #check if the file is empty
                content = fh.readlines()
                if len(content) == 0:
                    sys.stderr.write("myrecord.txt is empty.\nLoad failed.\n")
                    return

                #return the position to the beginning
                fh.seek(0)
                try:
                    self._mymoney = int(fh.readline())
                except ValueError as v:
                    sys.stderr.write(str(v)+"\nset mymoney to 0 by default\n")
                    self._mymoney = 0

                for rec in fh.readlines():
                    single_record = rec.split()   #a list of str

                    if len(single_record) == 3:
                        #check if the category is valid.if not,skip this record
                        if not categories.is_category_valid(single_record[0], categories._categories):
                            sys.stderr.write(f"'{single_record[0]}' is not in categories.\n")
                            sys.stderr.write(f"'{rec[:-1]}' will not be written into your record.\n")
                            continue

                        try:
                            single_record[2] = int(single_record[2])  #change the price from str to int

                            record = Record(*single_record)   #construct a Record object
                            self._expense_list.append(record)
                            self._cost_list.append(record.amount)
                        except ValueError as v:
                            sys.stderr.write(f"can't convert '{single_record[2]}' to int\n")
                            sys.stderr.write(f"'{' '.join(single_record)}' will not be written into your record\n")
                    else:
                        sys.stderr.write(f"failed to parse '{' '.join(single_record)}' due to unmatched length(it should be 3)\n")
                        sys.stderr.write(f"'{' '.join(single_record)}' will not be written into your record\n")
                print("Welcome back!")
        except FileNotFoundError:   #first time run this program
            try:
                #user input initial amount of money
                self._mymoney = int(input("How much money do you have? "))
            except ValueError:
                sys.stderr.write("Invalid value for money. Set to 0 by default.\n")
                self._mymoney = 0
        except ValueError as v:
            sys.stderr.write(str(v))

    def add(self,user_input):
        """
        user_input:a list of str
        add the record with '<category> <description> <amount>' if it is a valid category
        """
        try:
            #check its length
            if len(user_input) != 3:
                sys.stderr.write("invalid input format, should be '<category> <description> <price>'\n")
                return
            
            try:    #check its content
                user_input[2] = int(user_input[2])    #always convert the price to int before appending to cost_list
            except:
                sys.stderr.write(f"can't convert '{user_input[2]}' to int.\n")

            #check if the category added by user is valid or not
            valid = categories.is_category_valid(user_input[0], categories._categories)
            if not valid:
                print('The specified category is not in the category list.\nYou can check the category list by command "view categories".\nFail to add a record.')
                return

            record = Record(*user_input)    #construct a Record object
            self._expense_list.append(record)
            self._cost_list.append(record.amount)    #add money to costList
        except ValueError as v:
            sys.stderr.write(str(v) + "the format should be '<category> <description> <price>'\n")
            
    def view(self):
        """print the records in a neat format"""

        print("Here's your expense and income records:")
        print(f"{'Category':<20}{'Description':^20}{'Amount':>20}")
        print("=" * 60)
        for record in self._expense_list:
            print(f"{record.category:<20}{record.description:^20}{record.amount:>20}")
        print("=" * 60)
        print(f"Now you have {self._mymoney + sum(self._cost_list)} dollars.")   #can pass an iterable to sum()

    def delete(self, user_input):
        """
        user_input:a list of str
        delete the record user wants to delete
        if there are multiple records,it will ask the user which index to be deleted
        """
        try:
            #check its length
            if len(user_input) != 3:
                sys.stderr.write("invalid input format, should be '<category> <description> <price>'\n")
                return

            #check its content
            try:
                user_input[2] = int(user_input[2])    #always convert the price to int
            except ValueError as v:
                sys.stderr.write(f"can't convert {user_input[2]} to int.\n")
                return


            delete_record = Record(*user_input)   #construct a Record object

            to_be_deleted_list = []   #record the index to be deleted
            #want to know the index to be deleted,so use enumerate()
            for rec in enumerate(self._expense_list): #rec is a tuple.(idx, Record object)
                if delete_record == rec[1]:
                    to_be_deleted_list.append(rec[0])   #append the index to the list


            if len(to_be_deleted_list) == 0:  #the record to be deleted doesn't exist in expenseList
                tmp_list = [delete_record.category, delete_record.description, str(delete_record.amount)]  #just for output
                sys.stderr.write(f"there's no such record like '{' '.join(tmp_list)}'. delete failed!\n")
            elif len(to_be_deleted_list) == 1:  #exactly 1 record matched,simply pop the index
                self._expense_list.pop(to_be_deleted_list[0])
                self._cost_list.pop(to_be_deleted_list[0])
                print("delete success!")
            else:
                tmp_list = [user_input[0], user_input[1], str(user_input[2])]
                print(f"there are {len(to_be_deleted_list)} records of '{' '.join(tmp_list)}',which one do you want to delete? ")

                #show all the matched content to the user
                for idx in to_be_deleted_list:
                    print(f"'{' '.join(tmp_list)}' at index {idx}")

                try:
                    idx = int(input("Enter the index to be deleted: "))    #user enter which idx to be deleted

                    if idx not in to_be_deleted_list:
                        sys.stderr.write("invalid index! delete failed!\n")
                    else:
                        self._expense_list.pop(idx)   #simply pop the index
                        self._cost_list.pop(idx)
                        print("delete success!")
                except ValueError:
                    sys.stderr.write("the index should be a number. Please try again!\n")
        except ValueError as v:
            sys.stderr.write(str(v) + "the format should be '<category> <description> <price>'\n")

    def find(self, query_result):
        """find a certian category and all subcategories under it,and print their records"""

        find_result = list(filter(lambda rec:rec.category in query_result, self._expense_list))
        tmp_cost_list = [c.amount for c in find_result]   #get the cost of each matched record

        print(f"Here's your expense and income records under category '{category_query}':")
        print(f"{'Category':<20}{'Description':^20}{'Amount':>20}")   #both record[0],[1],[2] are strings
        print("=" * 60)
        for f in find_result:
            print(f"{f.category:<20}{f.description:^20}{f.amount:>20}")   #both f[0],[1],[2] are strings
        print("=" * 60)
        print(f"The total amount above is {self._mymoney + sum(tmp_cost_list)}.")   #can pass an iterable to sum()

    def save(self):
        """write the records to file before exit"""

        try:
            with open("myrecord.txt",'w') as fh:
                fh.write(str(self._mymoney))
                fh.write('\n')

                #since rec.amount is 'int',we have to convert to 'str' before join,or we'll get an error
                for rec in self._expense_list:
                    tmp_list = [rec.category, rec.description, str(rec.amount)]
                    fh.write(' '.join(tmp_list))
                    fh.write('\n')
        except FileNotFoundError as f:
            sys.stderr.write(str(f) + '\n')

class Categories():
    """Maintain the category list and provide some methods."""

    def __init__(self):
        self._categories = ['expense', ['food', ['meal', 'snack', 'drink'], 'transportation', ['bus', 'railway']], 'income', ['salary', 'bonus']]

    def view(self, categories, level = 0):
        """print the records with neat format"""

        if type(categories) in {list,tuple}:
            for child in categories:
                self.view(child, level+1)
        else:
            print(f"{' ' * 4 * level + '-'}{categories}")

    def is_category_valid(self, category, categories):
        """
        category: the target category you want to check
        categories: a predefined list
        """

        if type(categories) in {list,tuple}:
            for item in categories:
                valid = self.is_category_valid(category,item)
                if valid:
                    return True
        return category == categories

    def find_subcategories(self, category):
        """find a certain category and all subcategories under it"""
        def find_subcategories_gen(category, categories, found = False):
            if type(categories) == list:
                for index, child in enumerate(categories):
                    yield from find_subcategories_gen(category, child, found)
                    if child == category and index+1 < len(categories) and type(categories[index+1]) == list:
                        yield from find_subcategories_gen(category, categories[index+1], True)
            else:
                if categories == category or found:
                    yield categories
        return [i for i in find_subcategories_gen(category, self._categories)]


categories = Categories()
records = Records()

while True:
    operation = input("What do you want to do (add / view / delete / view categories / find / exit)?")

    if operation == "add":
        #user input a record (blank-seperated)
        user_input = input("Add an expense or income record with category, description, and amount (separate by spaces):").split()

        #pass in user input
        records.add(user_input)
    elif operation == "view":
        records.view()
    elif operation == "delete":
        #user input a record he/she wants to delete(blank-seperated)
        user_input = input("Which record do you want to delete? ").split()    #a list of str
        records.delete(user_input)
    elif operation == "view categories":
        categories.view(categories._categories, 0)
    elif operation == "find":
        try:
            category_query = input("Which category do you want to find? ")
        except ValueError as v:
            sys.stderr.write(str(v) + '\n')
            continue
        
        #check if the target category is in the predefined list
        valid = categories.is_category_valid(category_query, categories._categories)
        if not valid:
            print('The specified category is not in the category list.\nYou can check the category list by command "view categories".')
            continue

        #get a flatten list of all the items under the target category,including the target category itself
        query_result=categories.find_subcategories(category_query)
        records.find(query_result)
    elif operation == "exit":
        records.save()
        break
    else:
        sys.stderr.write("Invalid command. Try again.\n")
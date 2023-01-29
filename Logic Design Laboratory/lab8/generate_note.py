note=input()
note_list=note.split(',')

count_even=0
count_odd=1
i=0

bound=4
while bound<=64:
    while count_odd<bound:
        print("12'd"+str(count_even+28)+": toneR = `"+note_list[i]+';   '+"12'd"+str(count_odd+28)+": toneR = `"+note_list[i]+';')
        count_even+=2
        count_odd+=2
    bound+=4
    i+=1
    print()

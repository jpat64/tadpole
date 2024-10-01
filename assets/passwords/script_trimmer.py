from sys import argv
import re
from os import listdir

def clean(raw_word, regextext="[a-z]+"):
    new_word = re.search(regextext, raw_word.lower())
    if (new_word is not None):
        return new_word.group()
    else:
        return ""
    
def ends_with_txt(name):
    trimmed_name = clean(name, regextext="[a-z]+\.txt")
    return len(trimmed_name) > 4 and trimmed_name[-4:] == ".txt"

# glean 200 special words from a file
def main():
    if len(argv) <= 1:
        print('usage: script_trimmer.py [filename.txt]')
        return
    
    common_words = "the,be,to,and,of,a,in,that,have,i,it,for,not,on,with,he,as,you,do,at,this,but,his,by,from,they,we,say,her,she,or,an,will,my,one,all,would,there,their,what,so,up,out,if,about,who,get,which,go,me,when,make,can,like,time,no,just,him,know,take,people,into,year,your,good,some,could,them,see,other,than,then,now,look,only,come,its,over,think,also,back,after,use,two,how,our,work,first,well,way,even,new,want,because,any,these,give,day,most,us".split(",")
    
    process_all_files = argv[1] == "all"

    files_ending_in_txt = filter(ends_with_txt, listdir())
    for name in files_ending_in_txt:
        if process_all_files or name == argv[1]:
            print("processing " + str(name))
            filename = name
            lines = open(filename, 'r', encoding="utf-8").readlines()

            special_words = []
            for line in lines:
                words = [clean(raw_word) for raw_word in line.split(" ")]
                for word in words:
                    if (len(word) > 4):
                        if (word not in common_words):
                            if (word not in special_words):
                                special_words.append(word)
            
            index = len(special_words)
            while len(special_words) < 201:
                special_words.append(f'password{index}')
                index = len(special_words)

            file_contents = "\n".join(special_words)
            folder_filepath = "/".join(filename.split("/")[:-1])
            if (len(folder_filepath) > 0):
                folder_filepath = folder_filepath + "/"
            new_filename = f'{folder_filepath}filtered/filtered-{filename.split("/")[-1]}'
            writefile = open(new_filename, 'w+')
            writefile.write(file_contents)
            writefile.write("\n")
    return



main()
#!/usr/bin/python3 -u

import os,re,argparse

parser = argparse.ArgumentParser(description='namechange')
parser.add_argument('newname', metavar='name', type=str,
                    help='newname')
args=parser.parse_args()

newname=args.newname
oldname=open("./appname.txt").read()[:-1]

os.rename("./qml/"+oldname+".qml","./qml/"+newname+".qml")
os.rename("./dat/"+oldname+".desktop","./dat/"+newname+".desktop")
os.rename("./dat/"+oldname+".sh","./dat/"+newname+".sh")

def replaceInFile(oldname,newname,filename):
    makefile=open(filename,"r")
    maketxt=makefile.read()
    makefile.close()
    makefile=open(filename,"w")
    makefile.write(re.sub(oldname,newname,maketxt))
    makefile.close()

for filename in ["./Makefile","./dat/"+newname+".desktop"]:
    replaceInFile(oldname,newname,filename)


namefile=open("./appname.txt","w")
namefile.write(newname+"\n")
namefile.close()

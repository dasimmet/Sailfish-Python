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

makefile=open("./Makefile","r")
maketxt=makefile.read()
makefile.close()
makefile=open("./Makefile","w")
makefile.write(re.sub("Appname:="+oldname,"Appname:="+newname,maketxt))
makefile.close()

namefile=open("./appname.txt","w")
namefile.write(newname+"\n")
namefile.close()

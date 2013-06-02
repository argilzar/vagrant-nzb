#!/usr/bin/python
import ConfigParser, os, sys, getopt

def main(argv):
   inputfile = ''
   group = ''
   setting = ''
   value = None
   try:
      opts, args = getopt.getopt(argv,"hi:g:s:v:",["file=","group=","setting=","value="])
   except getopt.GetoptError:
      print 'config.py -i <inputfile> -g <group> -s <setting>  -v <value>'
      sys.exit(2)
   for opt, arg in opts:
      if opt == '-h':
         print 'config.py -i <inputfile> -g <group> -s <setting>  -v <value>'
         sys.exit()
      elif opt in ("-i", "--file"):
         inputfile = arg
      elif opt in ("-g", "--group"):
         group = arg
      elif opt in ("-s", "--setting"):
         setting = arg
      elif opt in ("-v", "--value"):
         value = arg
   config = ConfigParser.ConfigParser()
   config.read(inputfile)
   if value is None:
      print config.get(group, setting)
   else:
      config.set(group, setting, value)
      cfgfile = open(inputfile,'w')  
      config.write(cfgfile)
   

if __name__ == "__main__":
   main(sys.argv[1:])


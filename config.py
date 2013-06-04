#!/usr/bin/python
# Copyright 2013 Brian Bischoff <admin@argilzar.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

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


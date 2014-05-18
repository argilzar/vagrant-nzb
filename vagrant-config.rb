#Set to false those services you dont need
USE_NZEDB=false
USE_MEDIATOMB=false
#These can be combined into one box
USE_SABNZBD=true
USE_SICKBEARD=true
USE_COUCHPOTATO=true
USE_HEADPHONES=true

#Combine sabnzb,sickbeard,couchpotato and headephones into one box
#Note you still need to activate each service you need, default is all enabled
USE_COMBINED=true

#Host paths, they will be created automatically of they don't exist
TV_PATH="Videos/TV"
MOVIES_PATH="Videos/Movies"
MUSIC_PATH="Music"

#VM Paths
VM_TV_PATH="/media/video/TV"
VM_MOVIES_PATH="/media/video/Movies"
VM_MUSIC_PATH="/media/Music"

#Default location for all the setting files, incomplete downloads and cache
#If you do not change this then nzb folder will be created in current dir
CONFIG_PATH="nzb"
VM_CONFIG_PATH="/mnt/nzb" #Not recomended to change 

#Virtual box VM modifications, this is for the combined box only at the moment
VM_MEMORY=512 #Memory in MB
VM_CPU_COUNT=1 #Number of cpus
VM_GUI=false # gui boot, usefull if there are network problems
VM_EXEC_CAP=0 #0-100 cpu execution cap 0 to disable

#nzedb Config
NZEDB_USE_LOCAL_MYSQL=true
NZEDB_VM_MEMORY=2048 #Memory in MB
NZEDB_VM_CPU_COUNT=2 #Number of cpus
NZEDB_VM_GUI=false # gui boot, usefull if there are network problems
NZEDB_VM_EXEC_CAP=0 #0-100 cpu execution cap 0 to disable

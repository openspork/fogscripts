#!/usr/bin/python3
import xmltodict
from os import listdir, makedirs, symlink
from os.path import basename, dirname, exists, split
from pathlib import Path, PureWindowsPath
from re import compile, IGNORECASE
from fnmatch import translate
from glob import iglob

#build path database to resolve paths
paths = []
def build_path_db():
    global paths
    for filename in iglob('/mdt/**', recursive=True):
        abs_path = Path(filename).resolve() # get the absolute path
        rel_path = abs_path.relative_to('/mdt') # convert to relative path    
        paths.append(rel_path)
build_path_db()

#takes string, returns string
def unixify_path(win_path):
    pure_win_path = PureWindowsPath(win_path)
    #print(pure_win_path)
    posix_path = Path(pure_win_path)

    #check if path is valid
    if posix_path.exists():
        print('already correct!')
    else:
        #print('incorrect!')
        posix_path_str = str(posix_path)

        #computer case insensitive regex pattern for hunted file
        pattern = compile(translate(posix_path_str), IGNORECASE)

        #check to see if case inensitive pattern matches actual paths
        for path in paths:
            if pattern.match(str(path)):
                #print('match found! %s ' % path)
                return str(path)


driver_groups_xml = '/mdt/Control/DriverGroups.xml'
driver_xml = '/mdt/Control/Drivers.xml'

mdt_root = '/mdt'
fog_driver_root = '/images/drivers'

with open(driver_groups_xml) as fd:
    driver_groups = xmltodict.parse(fd.read())
    fd.close()

with open(driver_xml) as fd:
    drivers = xmltodict.parse(fd.read())
    fd.close()

#   drivers straight from XML are a list so lookups will be slow
#   therefore it is preferable to rearrange this data into a dictionary
#   this work is done once so all lookups can take place against the dict

driver_guid_sources = {}

drivers = drivers['drivers']['driver']

for driver in drivers:
    guid = driver['@guid']
    driver_source = driver['Source']

    source_inf_posix = unixify_path(driver_source)
    source_dir = mdt_root + '/' + dirname(source_inf_posix)
    driver_guid_sources[guid] = source_dir
    #print('guid %s points to %s' % (guid, source_dir))

#   now that we can efficiently convert guids into paths we can build symlinks

#print(driver_guid_sources)

driver_groups = driver_groups['groups']['group']

for driver_group in driver_groups:
    if 'Member' in driver_group: # only process if the group has drivers
        computer_name = driver_group['Name'] # get the name so we can name our FOG store
        guids = driver_group['Member'] #list of driver guids
        
        #iterate over the member drivers and create symlinks from MDT to FOG
        store = '/images/drivers/' + computer_name #create store, if missing
        if not exists(store):
            makedirs(store)

        dest = '/images/drivers/' + computer_name + '/' + guid
        for guid in guids:
            raw_driver_source = driver_guid_sources[guid]
            split_driver_source = split(raw_driver_source)
            driver_name = split_driver_source[1]
            driver_type = basename(split_driver_source[0])
            print(driver_type, driver_name)


            
            #symlink(driver_guid_sources[guid], dest)
            #print('guid %s is found in %s' % (guid, driver_guid_sources[guid]))
            #print('create symlink from:\n%sto\n%s\n\n' % (source, dest))



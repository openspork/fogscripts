#!/usr/bin/python3
import xmltodict
from os.path import dirname, join
from pathlib import Path, PureWindowsPath

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

    source_inf_win = PureWindowsPath(driver['Source'])
    print('Windows path: %s' % source_inf_win)
    # TODO convert relative Windows inf path to relative POSIX path
    # task 1: convert backslashes to forward slashes
    source_inf_posix_ci = str(Path(source_inf_win))
    print('Posix path insensitive: %s' % source_inf_posix_ci)
    # task 2: correct for case senstivity
    source_inf_posix = source_inf_posix_ci

    print('Posix path: %s' % source_inf_posix)

    #get parent folder
    source_dir = mdt_root + '/' + dirname(source_inf_posix)

    driver_guid_sources[guid] = source_dir
    print('guid %s points to %s' % (guid, source_dir))

#   now that we can efficiently convert guids into paths we can build symlinks

driver_groups = driver_groups['groups']['group']

for driver_group in driver_groups:
    if 'Member' in driver_group: # only process if the group has drivers
        name = driver_group['Name'] # get the name so we can name our FOG store
        guids = driver_group['Member'] #list of driver guids
        
        #iterate over the member drivers and create symlinks from MDT to FOG
        for guid in guids:
            print('guid %s is found in %s' % (guid, driver_guid_sources[guid]))
            print('creat symlink to %s' % name)



#!/usr/bin/python3
import xmltodict
driver_groups_xml = '/mdt/Control/DriverGroups.xml'
driver_xml = '/mdt/Control/Drivers.xml'

mdt_driver_root = '/mdt'
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
    source = mdt_driver_root+ '/' + driver['Source'].strip('.\\')
    driver_guid_sources[guid] = source
    print('guid %s points to %s' % (guid, source))

#   now that we can efficiently convert guids into paths we can build symlinks

driver_groups = driver_groups['groups']['group']

for driver_group in driver_groups:
    if 'Member' in driver_group: # only process if the group has drivers
        name = driver_group['Name'] # get the name so we can name our FOG store
        guids = driver_group['Member'] #list of driver guids
        
        #iterate over the member drivers and create symlinks from MDT to FOG
        for guid in guids:
            #print('guid %s is found in %s' % (guid, driver_guid_sources[guid]))

            #print(name)



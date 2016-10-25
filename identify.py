#!/usr/bin/env python
import sqlite3
#import version

if __name__ == '__main__':
    db = sqlite3.connect('/home/edulution/.kalite/database/data.sqlite')# could change depending on name of user
    c = db.cursor()
    results = c.execute(""" 
select d.name,d.version from securesync_device d
join securesync_devicemetadata s
where s.device_id = d.id
and s.is_own_device = 1 """)
    for row in results:
       device = row[0]
       version = row[1]

#    version = max([tuple(map(int, v.split('.'))) for v in version.VERSION_INFO.keys()])
    print 'Device:', device
    print 'Version:', version



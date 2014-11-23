#!/usr/bin/python

import dmenu_extended
import os
import imp

dmenu_extended_pm_path = os.path.expanduser('~') + '/.config/dmenu-extended/plugins/dmenuExtended_systemPackageManager.py'

dmenu_extended_systemPackageManager = imp.load_source('dmenuExtended_systemPackageManager ', dmenu_extended_pm_path)

p = dmenu_extended_systemPackageManager.extension()
p.build_package_cache(message=False)

d = dmenu_extended.extension()
d.cache_regenerate(message=False)
# print(dir(dmenu_extended.extension()))

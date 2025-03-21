#!/bin/bash

if [ -S /config/tvheadend/epggrab/xmltv.sock ]; then
   curl http://127.0.0.1:8081/epg | socat unix-connect:/config/tvheadend/epggrab/xmltv.sock STDIO
fi

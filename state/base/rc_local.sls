# Deploy /etc/rc.local
# Load macro
{% from 'libs/file.sls' import file_managed with context %}

{{ file_managed('salt://base/files/rc.local', '/etc/rc.local', mode='755') }}

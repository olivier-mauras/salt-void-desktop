# Load macros
{% from 'libs/file.sls' import file_managed with context %}
{% from 'libs/file.sls' import file_recurse with context %}

# Deploy files
{{ file_managed('salt://base/files/logrotate.conf', '/etc/logrotate.conf') }}
{{ file_recurse('salt://base/files/logrotate.d', '/etc/logrotate.d') }}

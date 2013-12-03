#!/usr/bin/env puppet --verbose

external_resource { "file exists":
    frequency => 1,
    timeout => 30,
    check => "/bin/ls /tmp/myfile"
}

notify { "File exists": require => External_resource["file exists"] }

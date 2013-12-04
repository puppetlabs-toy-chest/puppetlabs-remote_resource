Puppet External Resource
======================
This is a simple resource that just blocks transactions
until a check passes, theoretically indicating that some
kind of external resource is in a desired state.

If the resource does not reach the desired state within
a given timeout period (defaulting to 5 minutes), then
the resource fails and all dependent resources are skipped.

See ext/example.pp for example usage.

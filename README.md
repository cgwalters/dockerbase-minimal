# centosmin

An alternative base Docker image, targeted particularly for people who
are statically compiling native code (Go, Rust) or minimal C/C++
servers (nginx, redis) that don't tend to have big dependencies and
don't need translation infrastructure, etc.

Trying it
---------

See our [CentOS CI job](https://ci.centos.org/job/atomic-dockerimage-centosmin/).

```
curl https://ci.centos.org/job/atomic-dockerimage-centosmin/lastSuccessfulBuild/artifact/centosmin.tar.gz | docker import - cgwalters/centosmin
```

Implementation and size
-----------------------

Right now we're at 27MB compressed, 77MB uncompressed.  Compared to the main base image, there are
only two packages we include directly: `centos-release` and [micro-yuminst](https://github.com/cgwalters/micro-yuminst).
which is a trivial implementation of `yum -y install` in C.  Hence
this image doesn't include Python.

Primary minimization targets:

## libcurl dependencies

Build libcurl without libssh, ldap, etc. (EASY)

### RPM -> lua -> ncurses -> (libstdc++...)

We should be able to break the `lua` :arrow_right: `ncurses`
dependency.  I found https://github.com/luaposix/luaposix/pull/241

### Switch everything to openssl

So we can drop nss.

### Others

glib2 -> shared-mime-info

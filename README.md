# dockerbase-minimal

An alternative base Docker image (with CentOS7 and Fedora 24
versions), targeted particularly for people who are statically
compiling native code (Go, Rust) or minimal C/C++ servers (nginx,
redis) that don't tend to have big dependencies and don't need
translation infrastructure, etc.

There are only two packages to start:
[micro-yuminst](https://github.com/cgwalters/micro-yuminst) and the
`$distro-release` package for `/etc/yum.repos.d/` definitions -
everything else comes via dependencies.

Trying it
---------

See our CentOS CI jobs:

 - [Fedora](https://ci.centos.org/view/Atomic/job/atomic-dockerimage-fedora-24/)
 - [CentOS](https://ci.centos.org/view/Atomic/job/atomic-dockerimage-centos-7/)

Currently, uploads to the Docker Hub are manual, under the tags
`cgwalters/fedoramin` and `cgwalters/centosmin`.  You can also download the
tarballs directly from the Jenkins Jobs via:

```
curl https://ci.centos.org/job/atomic-dockerimage-fedora-24/lastSuccessfulBuild/artifact/fedoramin-24.tar.gz | docker import - cgwalters/fedoramin:24
curl https://ci.centos.org/job/atomic-dockerimage-centos-7/lastSuccessfulBuild/artifact/centosmin-7.tar.gz | docker import - cgwalters/centosmin:7
```

Implementation and size
-----------------------

Right now we're at ~27MB compressed, ~77MB uncompressed.

Work items
----------

## Ignore `Requires(post): systemd`

`yum -y install httpd` should *not* pull in systemd by default.  This
would likely require work in libsolv.

Primary minimization targets
----------------------------

## libcurl dependencies

Build libcurl without libssh, ldap, etc. (EASY)

### RPM -> lua -> ncurses -> (libstdc++...)

https://bugzilla.redhat.com/show_bug.cgi?id=1360404

### GNUPG minimization

https://bugzilla.redhat.com/show_bug.cgi?id=1361869

### Switch everything to openssl

So we can drop nss.  I noticed at least OpenSUSE at least avoids
the glibc :arrow_right: nss dependency.

### Others

glib2 -> shared-mime-info

Building locally
----------------

 - `./build-via-docker-and-yum.sh centos 7`
 - `./build-via-docker-and-yum.sh fedora 24`

Longer term plans/ideas:
------------------------

## Rebasing the current base image

I think the win overall versus the current base image would become
significantly clearer if it was "rebased" and just became a layer on
top of this.  Implementing this would entail some slightly nontrivial
transition code where `micro-yuminst` knows how to replace itself with
`yum` for example.

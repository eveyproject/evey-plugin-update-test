# Update test

A test fixture for the automatic updates of [Evey](https://github.com/eveyproject/evey)
plugins, not a plugin to install. Its releases walk through the cases the
server has to tell apart:

- a release that asks for nothing new, which installs on its own;
- a release that asks for a new permission, which waits for an admin;
- a release whose code the analysis refuses, which is never installed;
- a release signed with another key, which waits for an admin.

Releases are signed with a test key that is not the Evey project key.

## License

MIT, see [LICENSE](LICENSE).

# Manual Deployment

See [Development Environment](development.md) on how to get setup first.

This really needs automation, see [this github issue](https://github.com/bobsh/BTK/issues/12)
for status on this.

## Core

This is located in:

    ReplicatedStorage.BTK.Models.Core.MainModule

Right-click and select `Publish to roblox ...`.

Group is `BTK` model is `Core`.

# Rare Deployments

Most of the code is in Core, so it should be rare to need a Helper or Plugin upgrade.

## Helper

This is located in:

    ReplicatedStorage.BTK.Models.Helper.MainModule

Right-click and select `Publish to roblox ...`.

Group is `BTK` model is `Helper`.


## Plugin

This is located in:

    ReplicatedStorage.BTK.Plugins.BTK

Right-click and select `Publish as plugin ...`. Choose `BTK`
to overwrite.

## Content

`Content` I hope to remove or consolidate to Core, so we don't add things to it very often
so it should rarely need deployment.


This is located in:

    ReplicatedStorage.BTKContent

Right-click and select `Publish to roblox ...`.

Group is `BTK` model is `Content`.
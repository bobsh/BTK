# BTK Development

## API Reference

[API Docs ](/ldoc/index.html)

## Source Control

Github repo: [bobsh/BTK](https://github.com/bobsh/BTK/)

## Local Development

The project uses "Rojo" to sync up the source with Roblox Studio,
make sure this is running and you setup synchronisation for a solid development workflow.

To run rojo:

    # make dev

### Tests

Run

    # make test

### Lint

Or for lint:

    # make lint

## Project Management

Github project: [BTK](https://github.com/bobsh/BTK/projects/1)

## Automated testing

TravisCI: [bobsh/BTK](https://travis-ci.org/bobsh/BTK)
Coveralls: [bobsh/BTK](https://coveralls.io/github/bobsh/BTK)

## Manual Deployment

See [Development Environment](development.md) on how to get setup first.

This really needs automation, see [this github issue](https://github.com/bobsh/BTK/issues/12)
for status on this.

### Core

This is located in:

    ReplicatedStorage.BTK.Models.Core.MainModule

Right-click and select `Publish to roblox ...`.

Group is `BTK` model is `Core`.

## Rare Deployments

Most of the code is in Core, so it should be rare to need a Helper or Plugin upgrade.

### Helper

This is located in:

    ReplicatedStorage.BTK.Models.Helper.MainModule

Right-click and select `Publish to roblox ...`.

Group is `BTK` model is `Helper`.


### Plugin

This is located in:

    ReplicatedStorage.BTK.Plugins.BTK

Right-click and select `Publish as plugin ...`. Choose `BTK`
to overwrite.

### Content

`Content` I hope to remove or consolidate to Core, so we don't add things to it very often
so it should rarely need deployment.


This is located in:

    ReplicatedStorage.BTKContent

Right-click and select `Publish to roblox ...`.

Group is `BTK` model is `Content`.
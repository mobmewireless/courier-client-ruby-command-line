Courier Client
==============

[<img src="https://secure.travis-ci.org/mobmewireless/courier-client-ruby-command-line.png?branch=master" alt="Build Status" />](http://travis-ci.org/mobmewireless/courier-client-ruby-command-line)

It's a command line client for [Courier](https://github.com/mobmewireless/courier-server), written in Ruby!

Installation
============

With a version of Ruby (>= 1.9.3) installed, do:

    $ gem install courier_client

Setup
=====

    $ courier config API_BASE_URL ACCESS_TOKEN

For example:

    $ courier config https://courier.myhost.com/api CKXsr6npvUQTWWvX96gabQ

This will create the file `~/.courier/config.yml` to hold these values.

Usage
========

To send a message to all of your devices:

    $ courier send 'Something important just happened'

To send a device to just one of your devices, use the --device (-d) switch.

    $ courier send 'All done!' --device DEVICE_NAME

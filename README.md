Summary
=======

This is a a command that aims to make managing servers on ec2 a little easier.
It provides a convenient way to list your instances and interact with 
them using the Name tag or list index.

Supports the following commands:
ssh, start, stop, show, list

Planned: 
* scp command
* tmux integration for ssh
* interactive mode. 
* an easy way to plug in your own commands
* configuration file to be able to store different combinations 
  of credentials and regions for different projects

Configuration
=============

cloudo makes use of [Fog](https://github.com/fog/fog "Fog") so you need to make sure to have
the correct credentials in your ~/.fog file. 

The .fog file should look like this:

    :default:
      :aws_access_key_id:     <Access Key>
      :aws_secret_access_key: <Secret Access Key>

The -c option can be used to select another credential than default
to use if there are multiple credentials in the .fog file.

The ssh executable needs to be in your path for the ssh command
to work.
It is also assumed that the private key is named the same as the ec2 key name + .pem
and resides in ~/.ssh

Usage
=====

Using the default .fog credentials, this command lists the ec2 
instances in us-east-1 (default):

    cloudo list

to list instances in any other region use the -r option, for example:

    cloudo -r eu-west-1 list

The list command adds an index for each instance found, this index can
be used with commands that interacts with a single instance, like the 
ssh command:

    cloudo ssh user@<index>

instead of the index you can use the Name tag for the instance:

    cloudo ssh user@<name>

The user part is optional, if ommitted you will connect as the current user.

Run 

    cloudo -h 
    
to list all available optoins and commands.

For more help on a given command run 

    cloudo <command> -h

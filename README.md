# Munki Serial Enroll

A set of scripts to automatically enroll clients in Munki, allowing for a very flexible manifest structure.

## Why Munki Serial Enroll?

Using serial number manifests with human-readable display names and included group manifests allows for maximum flexibility. You can deploy software to a single machine or a group of machines.

### Wait, Doesn't Munki Do This Already?

Munki can target systems based on hostnames or serial numbers. However, each manifest must be created by hand. Munki Serial Enroll allows us to create specific manifests automatically, and to allow them to contain a more generic manifest for large-scale software management.

## How does this differ from regular Munki Enroll?
It has a few logistical tweaks for my organization that others may find immediately helpful or may find ideas in that they can tweak for their own organizations, but it's also different in approach.

The original Munki Enroll creates individual manifests based on hostname and writes the hostname back as a ClientIdentifier on the  client itself. Munki Serial Enroll goes based off of serial number, copies a template manifest (instead of creating one from scratch), and actually deletes the ClientIdentifier entirely.

## Server Configuration

Munki Enroll requires PHP to be working on the webserver hosting your Munki repository.

Copy the **munki-enroll** folder to the root of your Munki repository (the same directory as pkgs, pkginfo, manifests and catalogs). 

Also copy the **desktop_template** and **laptop_template** files to your manifests folder and modify them appropriately. Leave in the
```
	<key>display_name</key>
	<string>DISPLAYNAMETOREPLACE</string>
```
bit, though, because that's what gets replaced later after the template is copied.

Make sure the Apache or other &#95;www user has write access to the manifests folder.  

That's it on the server side! Be sure to make note of the full URL path to the enroll.php file.

## Client Configuration

On the client side, tweak (for your organization) the two user-defined variables and run the munki_enroll.sh script, which will then communicate with the server about what manifest to create.

The included munki_enroll.sh script can be executed in any number of ways (Terminal, ARD, DeployStudio workflow, LaunchAgent, etc.).

## What if this workflow doesn't fit my organization's?

It actually very likely _won't_ fit your organizations. Every organization has its own workflow. Vanilla Munki Serial Enroll assumes https with basic authentication. You might be using SSL client certificates. It also assumes you have different manifest display names in desktops than you do in laptops. All your display names may follow the same pattern, or you may differentiate on MacBook Airs vs. MacBook Pros. It's really impossible to write an enrollment script that will exactly match every organization's needs, even if some arguments were added in. I don't know what your server address is. I don't know what types of things you want to put in the display name (maybe you don't want a specific user or the name of the computer&mdash;maybe you want something else entirely).

The idea isn't that you just use this set of scripts out of the box. The idea is more "This has been helpful to me and my organization, and it may be helpful to you and your organization, too. The workflows in here may give you ideas of how you want to create your own workflows." Chances are, if you're a Mac admin using Munki, you have at least a little bit of scripting chops and can tweak these scripts to suit your organization's needs.

## Acknowledgements
I've done a hefty bit of work on this, but a lot of credit for this concept must go to [Cody Eding](https://github.com/edingc), the creator of Munki Enroll, which I forked this from.

## License

Munki Serial Enroll is published under the [MIT License](http://www.opensource.org/licenses/mit-license.php).

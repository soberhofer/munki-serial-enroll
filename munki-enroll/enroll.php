<?php

if((isset($_GET["serial"])) AND (isset($_GET["displayname"])) AND (isset($_GET["template"]))){

    // Get the variables passed by the enroll script
    $serial = $_GET["serial"];
    $displayname = $_GET["displayname"];
    $template = $_GET["template"];

    // Specify the template source to be copied as an individual template
    if($template == "desktop"){
    
            $source="../manifests/desktop_template";

        } elseif($template == "laptop") {
            
            $source="../manifests/laptop_template";
        
        } else {
        
            $source="";
        
        }

    // Double-check there is a source to copy from
    if(($source!="") AND (file_exists($source))){

        // Create destination
        $destination="../manifests/" . $serial;

        // Check if manifest already exists for this machine
        if ( file_exists($destination) ){
            
                // The manifest already exists. Nothing to do.
                echo "Computer manifest " . $serial . " already exists.";
        
            } else {
            
                // Create the manifest
                echo "Computer manifest does not exist. Will create " . $destination;
                copy($source, $destination);
            
                // Add in the proper display name with a quick find/replace
                shell_exec('/usr/bin/sed -i.bak ' . '"s/DISPLAYNAMETOREPLACE/' . $displayname . '/g" ' . $destination); 
                // Delete the backup file
                unlink("../manifests/" . $serial . ".bak");

            }

        // End checking for source manifest existence
        } else {
        
            echo "Cannot create manifest. The source template to copy from does not exist.";
        
        }

    // End checking for GET variables
    } else {
        echo "Cannot create manifest. Missing one or more variables. Need serial number, display name, and template";
    }

?>
